import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:point_nemo_service_and_activities/core/custom/more_widgets/custom_text_style.dart';
import 'package:point_nemo_service_and_activities/core/custom/more_widgets/custom_loading_indicator.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_colors.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_sizer.dart';
import 'package:point_nemo_service_and_activities/features/_user_flow/service_bokings/controllers/user_bookings_controller.dart';
import 'package:point_nemo_service_and_activities/routes/app_routes.dart';
import 'package:point_nemo_service_and_activities/core/custom/widgets/custom_submit_button.dart';
import 'package:point_nemo_service_and_activities/core/localization/app_localizations.dart';
import 'package:point_nemo_service_and_activities/features/_user_flow/service_bokings/views/widgets/booking_card.dart';

class UserBookingsScreen extends StatelessWidget {
  const UserBookingsScreen({super.key});

  List<String> _tabs(BuildContext context) => [
    AppLocalizations.of(context)!.upcomingText,
    AppLocalizations.of(context)!.completedText,
    AppLocalizations.of(context)!.cancelText,
  ];

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UserBookingsController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 16.h),
            Text(
              AppLocalizations.of(context)!.myBookings,
              style: getTextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: 20.h),
            _buildTabBar(context, controller),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CustomLoadingIndicator());
                }

                final bookings = controller.filteredBookings;
                if (bookings.isEmpty) {
                  return _buildEmptyState(context, controller);
                }

                return RefreshIndicator(
                  onRefresh: controller.fetchBookings,
                  child: ListView.builder(
                    controller: controller.scrollController,
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    itemCount:
                        bookings.length +
                        (controller.isLoadingMore.value ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == bookings.length) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(child: CustomLoadingIndicator()),
                        );
                      }
                      final booking = bookings[index];
                      return BookingCard(
                        booking: booking,
                        onCancel: () => _showCancelDialog(
                          context,
                          controller,
                          booking.id,
                          booking.title,
                        ),
                        onRefundRequest: () => _showRefundBottomSheet(
                          context,
                          controller,
                          booking.id,
                        ),
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar(BuildContext context, UserBookingsController controller) {
    final tabs = _tabs(context);
    return Obx(
      () => Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Color(0xFFE5E7EB), width: 1),
          ),
        ),
        child: Row(
          children: List.generate(tabs.length, (index) {
            final isSelected = controller.selectedTabIndex.value == index;
            return Expanded(
              child: GestureDetector(
                onTap: () => controller.changeTab(index),
                behavior: HitTestBehavior.opaque,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 10.h),
                      child: Text(
                        tabs[index],
                        textAlign: TextAlign.center,
                        style: getTextStyle(
                          fontSize: 14.sp,
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w400,
                          color: isSelected
                              ? AppColors.primary
                              : const Color(0xFF9CA3AF),
                        ),
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      height: 3,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(2.w),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    UserBookingsController controller,
  ) {
    final tabs = _tabs(context);
    final tabLabel = tabs[controller.selectedTabIndex.value].toLowerCase();
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_month_outlined,
            size: 64.w,
            color: const Color(0xFFD1D5DB),
          ),
          SizedBox(height: 16.h),
          Text(
            '${AppLocalizations.of(context)!.noBookingText} $tabLabel',
            style: getTextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF9CA3AF),
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            AppLocalizations.of(context)!.yourBookingWillAppear(tabLabel),
            style: getTextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFFD1D5DB),
            ),
          ),
        ],
      ),
    );
  }

  void _showCancelDialog(
    BuildContext context,
    UserBookingsController controller,
    String bookingId,
    String bookingTitle,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.w),
        ),
        backgroundColor: Colors.white,
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 20.w, 20.w, 30.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () => Navigator.pop(ctx),
                  child: Icon(
                    Icons.close_rounded,
                    size: 36.w,
                    color: const Color(0xFF1F2937),
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: getTextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF374151),
                    height: 1.3,
                  ),
                  children: [
                    TextSpan(
                      text: AppLocalizations.of(
                        context,
                      )!.cancelBookingConfirmationText,
                    ),
                    TextSpan(
                      text: '$bookingTitle?',
                      style: getTextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0F172A),
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 36.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: CustomSubmitButton(
                  text: AppLocalizations.of(context)!.yesCancelText,
                  color: const Color(0xFFE93B3B),
                  textColor: Colors.white,
                  borderRadius: BorderRadius.circular(32.w),
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                  onTap: () {
                    Get.back();
                    controller.cancelBooking(id: bookingId);
                  },
                ),
              ),
              SizedBox(height: 24.h),
              GestureDetector(
                onTap: () => Navigator.pop(ctx),
                child: Text(
                  AppLocalizations.of(context)!.keepBookingText,
                  textAlign: TextAlign.center,
                  style: getTextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFFFF5252),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showRefundBottomSheet(
    BuildContext context,
    UserBookingsController controller,
    String bookingId,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.w)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 32.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 44.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(2.w),
                ),
              ),
              SizedBox(height: 24.h),
              Text(
                AppLocalizations.of(context)!.wantToRefundTitle,
                textAlign: TextAlign.center,
                style: getTextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF0F172A),
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                AppLocalizations.of(context)!.refundConfirmationSubtitle,
                textAlign: TextAlign.center,
                style: getTextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF6B7280),
                  height: 1.5,
                ),
              ),
              SizedBox(height: 32.h),
              Row(
                children: [
                  Expanded(
                    child: Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(32.w),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(32.w),
                        onTap: () => Navigator.pop(ctx),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(32.w),
                            border: Border.all(
                              color: const Color(0xFF0F172A),
                              width: 1.w,
                            ),
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.goBackText,
                            textAlign: TextAlign.center,
                            style: getTextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF0F172A),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: CustomSubmitButton(
                      text: AppLocalizations.of(context)!.refundRequest,
                      color: const Color(0xFF0F172A),
                      textColor: Colors.white,
                      borderRadius: BorderRadius.circular(32.w),
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      onTap: () {
                        Navigator.pop(ctx);
                        Get.toNamed(
                          AppRoute.refundRequestScreen,
                          arguments: bookingId,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
