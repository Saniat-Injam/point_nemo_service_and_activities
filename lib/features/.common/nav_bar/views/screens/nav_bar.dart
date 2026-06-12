import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_sizer.dart';
import 'package:point_nemo_service_and_activities/features/.common/nav_bar/controllers/nav_bar_controller.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NavBarController>();

    return Scaffold(
      body: Obx(() => controller.screens[controller.currentIndex]),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(
          top: 8.h,
          bottom: MediaQuery.paddingOf(context).bottom > 0
              ? MediaQuery.paddingOf(context).bottom + 10.h
              : 24.h,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFF3F4F6))),
        ),
        child: Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(controller.navItems.length, (index) {
              final item = controller.navItems[index];
              if (item.isFab) {
                return _buildFloatingActionItem(
                  onTap: () => controller.changeIndex(index),
                );
              }
              return _buildNavItem(
                icon: item.icon,
                label: item.label,
                isActive: controller.currentIndex == index,
                onTap: () => controller.changeIndex(index),
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required String icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            icon,
            colorFilter: ColorFilter.mode(
              isActive ? const Color(0xFF040A18) : const Color(0xFF9CA3AF),
              BlendMode.srcIn,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 10.sp,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              color: isActive
                  ? const Color(0xFF040A18)
                  : const Color(0xFF9CA3AF),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionItem({required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 15.h),
        width: 56.w,
        height: 56.w,
        decoration: BoxDecoration(
          color: const Color(0xFF040A18),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 4),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Icon(
            Icons.calendar_month_outlined,
            color: Colors.white,
            size: 24.w,
          ),
        ),
      ),
    );
  }
}


