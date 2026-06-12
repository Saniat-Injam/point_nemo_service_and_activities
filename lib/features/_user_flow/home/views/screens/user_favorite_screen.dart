import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:point_nemo_service_and_activities/core/custom/more_widgets/custom_text_style.dart';
import 'package:point_nemo_service_and_activities/core/custom/more_widgets/custom_loading_indicator.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_sizer.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/image_path.dart';
import 'package:point_nemo_service_and_activities/core/localization/app_localizations.dart';
import 'package:point_nemo_service_and_activities/features/_user_flow/home/controllers/user_favorite_controller.dart';
import 'package:point_nemo_service_and_activities/features/_user_flow/explore/models/service_model.dart';

class UserFavoriteScreen extends StatelessWidget {
  const UserFavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final UserFavoriteController controller = Get.find<UserFavoriteController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          AppLocalizations.of(context)!.favoriteText,
          style: getTextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1D1B20),
          ),
        ),
        centerTitle: true,
        leading: Padding(
          padding: EdgeInsets.only(left: 20.w),
          child: Center(
            child: InkWell(
              onTap: () => Get.back(),
              borderRadius: BorderRadius.circular(20.w),
              child: Container(
                width: 40.w,
                height: 40.w,
                decoration: const BoxDecoration(
                  color: Color(0xFFF3F4F6),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.arrow_back,
                    color: const Color(0xFF1D1B20),
                    size: 20.w,
                  ),
                ),
              ),
            ),
          ),
        ),
        leadingWidth: 70.w,
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.favoriteItems.isEmpty) {
          return const Center(child: CustomLoadingIndicator());
        }

        if (controller.favoriteItems.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.favorite_border, size: 64.w, color: Colors.grey),
                SizedBox(height: 16.h),
                Text(
                  'No favorites yet',
                  style: getTextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.fetchFavorites,
          child: ListView.separated(
            controller: controller.scrollController,
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
            itemCount: controller.favoriteItems.length +
                (controller.hasMore.value ? 1 : 0),
            separatorBuilder: (context, index) => SizedBox(height: 16.h),
            itemBuilder: (context, index) {
              if (index == controller.favoriteItems.length) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CustomLoadingIndicator(),
                  ),
                );
              }

              final favoriteItem = controller.favoriteItems[index];
              final service = favoriteItem.service;

              if (service == null) {
                return const SizedBox.shrink();
              }

              return _buildFavoriteItem(
                service: service,
                favoriteId: favoriteItem.id,
                controller: controller,
              );
            },
          ),
        );
      }),
    );
  }

  Widget _buildFavoriteItem({
    required ServiceModel service,
    required String favoriteId,
    required UserFavoriteController controller,
  }) {
    final title = service.name.isNotEmpty ? service.name : 'Unknown';
    final location = service.address.isNotEmpty ? service.address : 'Unknown Location';
    final rating = service.averageRating.toStringAsFixed(1);
    final price = '\$${service.price.toStringAsFixed(2)}';
    
    String imagePath = '';
    if (service.coverImage.isNotEmpty) {
      imagePath = service.coverImage;
    } else if (service.photos.isNotEmpty) {
      imagePath = service.photos.first;
    }

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.w),
            child: imagePath.startsWith('http')
                ? Image.network(
                    imagePath,
                    width: 80.w,
                    height: 80.w,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 80.w,
                      height: 80.w,
                      color: Colors.grey[200],
                      child: Icon(Icons.image_not_supported, color: Colors.grey, size: 30.w),
                    ),
                  )
                : Image.asset(
                    ImagePath.sunsetYachtCruise,
                    width: 80.w,
                    height: 80.w,
                    fit: BoxFit.cover,
                  ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: getTextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1D1B20),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 14.w,
                      color: const Color(0xFF6B7280),
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Text(
                        location,
                        style: getTextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF6B7280),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      '  |  ',
                      style: getTextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFFD1D5DB),
                      ),
                    ),
                    Icon(
                      Icons.star,
                      size: 14.w,
                      color: const Color(0xFFF59E0B),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      rating,
                      style: getTextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF4B5563),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      price,
                      style: getTextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1D1B20),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        controller.removeFavorite(service.id);
                      },
                      child: Icon(
                        Icons.favorite,
                        size: 20.w,
                        color: const Color(0xFF040A18),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
