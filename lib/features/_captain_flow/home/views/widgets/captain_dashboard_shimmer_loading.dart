import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_sizer.dart';

class CaptainDashboardShimmerLoading extends StatelessWidget {
  const CaptainDashboardShimmerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFEBEBF4),
      highlightColor: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: _buildShimmerBox(130.h, 12.r)),
              SizedBox(width: 12.w),
              Expanded(child: _buildShimmerBox(130.h, 12.r)),
              SizedBox(width: 12.w),
              Expanded(child: _buildShimmerBox(130.h, 12.r)),
            ],
          ),
          SizedBox(height: 24.h),
          _buildShimmerBox(250.h, 24.w),
          SizedBox(height: 24.h),
          _buildShimmerBox(150.h, 24.w),
        ],
      ),
    );
  }

  Widget _buildShimmerBox(double height, double radius) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
