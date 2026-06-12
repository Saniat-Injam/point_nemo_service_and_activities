import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:point_nemo_service_and_activities/core/custom/more_widgets/custom_text_style.dart';
import 'package:point_nemo_service_and_activities/core/localization/app_localizations.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_sizer.dart';

import 'package:point_nemo_service_and_activities/features/_user_flow/search_and_filter/controllers/search_and_filter_controller.dart';

class SearchAndFilterHeader extends StatelessWidget {
  final SearchAndFilterController controller;
  final EdgeInsetsGeometry? padding;

  const SearchAndFilterHeader({
    super.key,
    required this.controller,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.only(left: 24.w, right: 24.w, top: 16.h),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 48.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24.h),
                border: Border.all(color: const Color(0xFFE5E7EB), width: 1.0),
              ),
              child: Row(
                children: [
                  SizedBox(width: 16.w),
                  Icon(
                    Icons.search,
                    color: const Color(0xFFC0C0C0),
                    size: 20.w,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: TextField(
                      controller: controller.searchController,
                      onChanged: controller.onSearchChanged,
                      style: getTextStyle(
                        color: const Color(0xFF1D1B20),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!.searchText,
                        hintStyle: getTextStyle(
                          color: const Color(0xFFC0C0C0),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                      textInputAction: TextInputAction.search,
                    ),
                  ),
                  Obx(() {
                    if (controller.searchQuery.value.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    return GestureDetector(
                      onTap: controller.clearSearch,
                      child: Padding(
                        padding: EdgeInsets.only(right: 16.w),
                        child: Icon(
                          Icons.close,
                          color: const Color(0xFFC0C0C0),
                          size: 18.w,
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
          SizedBox(width: 12.w),
          GestureDetector(
            onTap: () {
              Scaffold.of(context).openEndDrawer();
            },
            child: Container(
              width: 56.w,
              height: 48.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24.h),
                border: Border.all(color: const Color(0xFFE5E7EB), width: 1.0),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 4.w,
                          height: 4.w,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF4B5563),
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Container(
                          width: 10.w,
                          height: 2.h,
                          decoration: BoxDecoration(
                            color: const Color(0xFF4B5563),
                            borderRadius: BorderRadius.circular(1.w),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 10.w,
                          height: 2.h,
                          decoration: BoxDecoration(
                            color: const Color(0xFF4B5563),
                            borderRadius: BorderRadius.circular(1.w),
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Container(
                          width: 4.w,
                          height: 4.w,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF4B5563),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
