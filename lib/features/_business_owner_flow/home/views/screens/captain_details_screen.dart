import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_sizer.dart';
import 'package:point_nemo_service_and_activities/core/custom/more_widgets/custom_text_style.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/image_path.dart';
import 'package:point_nemo_service_and_activities/features/_business_owner_flow/home/controllers/captain_details_controller.dart';
import 'package:point_nemo_service_and_activities/features/_business_owner_flow/home/models/captain_model.dart';
import 'package:point_nemo_service_and_activities/routes/app_routes.dart';
import 'package:point_nemo_service_and_activities/features/.common/chat/models/chat_model.dart';
import 'package:point_nemo_service_and_activities/features/_business_owner_flow/home/views/widgets/captain_review_section.dart';
import 'package:point_nemo_service_and_activities/core/localization/app_localizations.dart';

class CaptainDetailsScreen extends StatelessWidget {
  final CaptainModel? captain;
  final String title;

  const CaptainDetailsScreen({
    super.key,
    this.captain,
    this.title = 'Captain Details',
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CaptainDetailsController>();
    if (captain != null) {
      controller.setCaptain(captain);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: EdgeInsets.only(left: 20.w),
          child: Center(
            child: GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                width: 40.w,
                height: 40.w,
                decoration: const BoxDecoration(
                  color: Color(0xFFEEEEEE),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_back,
                  color: Color(0xFF1D1B20),
                  size: 20,
                ),
              ),
            ),
          ),
        ),
        leadingWidth: 60.w,
        title: Text(
          captain != null ?  AppLocalizations.of(context)!.captainDetails : title,
          style: getTextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1D1B20),
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.w),
            child: const Icon(
              Icons.favorite_border,
              color: Color(0xFF1D1B20),
              size: 24,
            ),
          ),
        ],
      ),
      bottomNavigationBar: Obx(() {
        final cap = controller.captain.value;
        final price = cap?.captainRate ?? 300.00;

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.perHour,
                      style: getTextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '\$${price.toStringAsFixed(2)}',
                      style: getTextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1D1B20),
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    Get.toNamed(
                      AppRoute.captainBookingDetailsScreen,
                      arguments: {
                        'captainId': cap?.id ?? '',
                        'price': price,
                      },
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 32.w,
                      vertical: 16.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF040A18),
                      borderRadius: BorderRadius.circular(24.w),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.hireNow,
                      style: getTextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
      body: Obx(() {
        final cap = controller.captain.value;
        if (cap == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final profileImageUrl = cap.profileImage;
        final hasNetworkImage =
            profileImageUrl != null && profileImageUrl.isNotEmpty;
        final nameVal = cap.fullName;
        final loc = cap.address;
        final ratingVal =
            cap.captainRate ?? 5.0; // Assuming rating might be elsewhere
        final rev = 212; // Static for now, as not in model

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: 24.w,
            vertical: 16.h,
          ).copyWith(bottom: 40.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Image
              ClipRRect(
                borderRadius: BorderRadius.circular(20.w),
                child: hasNetworkImage
                    ? Image.network(
                        profileImageUrl,
                        width: double.infinity,
                        height: 240.h,
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter,
                        errorBuilder: (_, __, ___) => _buildPlaceholder(),
                      )
                    : _buildPlaceholder(),
              ),
              SizedBox(height: 20.h),

              // Title
              Text(
                nameVal,
                style: getTextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1D1B20),
                ),
              ),
              SizedBox(height: 8.h),

              // Location
              Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    color: const Color(0xFF6B7280),
                    size: 16.w,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    loc.isNotEmpty ? loc : AppLocalizations.of(context)!.saintMartinIsland,
                    style: getTextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),

              // Rating
              Row(
                children: [
                  Icon(Icons.star, color: const Color(0xFFF59E0B), size: 16.w),
                  SizedBox(width: 4.w),
                  Text(
                    ratingVal.toStringAsFixed(0),
                    style: getTextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF4B5563),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Container(
                    width: 4.w,
                    height: 4.w,
                    decoration: const BoxDecoration(
                      color: Color(0xFFD1D5DB),
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    AppLocalizations.of(context)!.reviewsCount(rev.toString()),
                    style: getTextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),

              // Owner Profile Row
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24.w),
                    child: hasNetworkImage
                        ? Image.network(
                            profileImageUrl,
                            width: 48.w,
                            height: 48.w,
                            fit: BoxFit.cover,
                            alignment: Alignment.topCenter,
                            errorBuilder: (_, __, ___) =>
                                _buildSmallPlaceholder(),
                          )
                        : _buildSmallPlaceholder(),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          nameVal.replaceAll('Captain ', ''),
                          style: getTextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1D1B20),
                          ),
                        ),
                        Text(
                          AppLocalizations.of(context)!.captainText,
                          style: getTextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Chat to a captain
                  GestureDetector(
                    onTap: () {
                      final chatUser = ChatModel(
                        id: cap.id,
                        name: cap.fullName,
                        lastMessage: '',
                        time: '',
                        avatarUrl: cap.profileImage,
                        imagePath: ImagePath.johnDoe,
                      );
                      Get.toNamed(
                        AppRoute.chatDetailsScreen,
                        arguments: chatUser,
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(10.w),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.chat_bubble_outline,
                        color: const Color(0xFF1D1B20),
                        size: 20.w,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),

              // Descriptions Section
              Text(
                AppLocalizations.of(context)!.descriptionsText,
                style: getTextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1D1B20),
                ),
              ),
              SizedBox(height: 12.h),
              RichText(
                text: TextSpan(
                  style: getTextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF6B7280),
                    height: 1.5,
                  ),
                  children: [
                    TextSpan(
                      text: AppLocalizations.of(context)!.captainDescriptionSnippet,
                    ),
                    TextSpan(
                      text: AppLocalizations.of(context)!.readMore,
                      style: getTextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1D1B20),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),

              // Specializations
              Text(
                AppLocalizations.of(context)!.specializationsText,
                style: getTextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1D1B20),
                ),
              ),
              SizedBox(height: 16.h),
              Wrap(
                spacing: 8.w,
                runSpacing: 12.h,
                children: [
                  _buildSpecializationChip(AppLocalizations.of(context)!.yachtOperationsText),
                  _buildSpecializationChip(AppLocalizations.of(context)!.deepSeaNavigationText),
                  _buildSpecializationChip(AppLocalizations.of(context)!.safetyExpertText),
                  _buildSpecializationChip(AppLocalizations.of(context)!.firstAidCertifiedText),
                ],
              ),
              SizedBox(height: 24.h),

              // Reviews Section
              const CaptainReviewSection(),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSpecializationChip(String title) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: const Color(0xFF040A18),
        borderRadius: BorderRadius.circular(20.w),
      ),
      child: Text(
        title,
        style: getTextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Image.asset(
      ImagePath.rentBoat1,
      width: double.infinity,
      height: 240.h,
      fit: BoxFit.cover,
      alignment: Alignment.topCenter,
    );
  }

  Widget _buildSmallPlaceholder() {
    return Image.asset(
      ImagePath.rentBoat1,
      width: 48.w,
      height: 48.w,
      fit: BoxFit.cover,
      alignment: Alignment.topCenter,
    );
  }
}
