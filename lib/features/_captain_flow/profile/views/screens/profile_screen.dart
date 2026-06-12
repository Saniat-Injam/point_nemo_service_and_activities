// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import 'package:point_nemo_service_and_activities/core/custom/more_widgets/global_text_style.dart';
// import 'package:point_nemo_service_and_activities/core/utils/constants/app_colors.dart';
// import 'package:point_nemo_service_and_activities/core/utils/constants/app_sizer.dart';
// import 'package:point_nemo_service_and_activities/core/utils/constants/icon_path.dart';
// import 'package:point_nemo_service_and_activities/core/utils/constants/image_path.dart';
// import 'package:point_nemo_service_and_activities/routes/app_routes.dart';
// import 'package:point_nemo_service_and_activities/features/_captain_flow/profile/controllers/logout_controller.dart';
// import 'package:point_nemo_service_and_activities/features/_captain_flow/profile/views/widgets/profile_action_dialog.dart';

// class ProfileScreen extends StatelessWidget {
//   const ProfileScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final logoutController = Get.find<LogoutController>();
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildProfileHeader(),
//               SizedBox(height: 30.h),
//               Text(
//                 'General',
//                 style: getTextStyle(
//                   fontSize: 18.sp,
//                   fontWeight: FontWeight.w600,
//                   color: AppColors.textPrimary,
//                 ),
//               ),
//               SizedBox(height: 16.h),
//               _buildListTile(
//                 icon: Icons.person_outline,
//                 title: 'Edit Profile',
//                 onTap: () {
//                   Get.toNamed(AppRoute.editProfileScreen);
//                 },
//               ),
//               SizedBox(height: 16.h),
//               _buildListTile(
//                 icon: Icons.lock_outline,
//                 title: 'Change Password',
//                 onTap: () {
//                   Get.toNamed(AppRoute.changePasswordScreen);
//                 },
//               ),
//               SizedBox(height: 16.h),
//               _buildListTile(
//                 iconWidget: SvgPicture.asset(
//                   IconPath.world,
//                   width: 24.w,
//                   height: 24.w,
//                   colorFilter: const ColorFilter.mode(
//                     AppColors.textPrimary,
//                     BlendMode.srcIn,
//                   ),
//                   fit: BoxFit.contain,
//                 ),
//                 title: 'Language',
//                 onTap: () {
//                   Get.toNamed(AppRoute.languageScreen);
//                 },
//               ),
//               SizedBox(height: 30.h),
//               Text(
//                 'Preferencess',
//                 style: getTextStyle(
//                   fontSize: 18.sp,
//                   fontWeight: FontWeight.w600,
//                   color: AppColors.textPrimary,
//                 ),
//               ),
//               SizedBox(height: 16.h),
//               _buildListTile(
//                 iconWidget: Icon(
//                   Icons.live_help_outlined,
//                   color: AppColors.textPrimary,
//                   size: 24.w,
//                 ),
//                 title: 'Help & Support',
//                 onTap: () {
//                   Get.toNamed(AppRoute.helpSupportScreen);
//                 },
//               ),
//               SizedBox(height: 16.h),
//               Obx(
//                 () => _buildListTile(
//                   iconWidget: logoutController.isLoading.value
//                       ? SizedBox(
//                           width: 24.w,
//                           height: 24.w,
//                           child: const CircularProgressIndicator(
//                             strokeWidth: 2,
//                             color: Colors.red,
//                           ),
//                         )
//                       : Icon(Icons.logout, color: Colors.red, size: 24.w),
//                   title: 'Logout',
//                   textColor: AppColors.textPrimary,
//                   onTap: logoutController.isLoading.value
//                       ? () {}
//                       : () {
//                           Get.dialog(
//                             ProfileActionDialog(
//                               title: 'Are you sure you want\nto logout?',
//                               actionText: 'Log Out',
//                               onCancel: () => Get.back(),
//                               onAction: () {
//                                 Get.back();
//                                 logoutController.logout();
//                               },
//                             ),
//                           );
//                         },
//                 ),
//               ),
//               SizedBox(height: 30.h),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildProfileHeader() {
//     return Row(
//       children: [
//         CircleAvatar(
//           radius: 35.w,
//           backgroundImage: const AssetImage(ImagePath.jennyWilson),
//         ),
//         SizedBox(width: 16.w),
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Jenny Wilson',
//               style: getTextStyle(
//                 fontSize: 20.sp,
//                 fontWeight: FontWeight.w600,
//                 color: AppColors.textPrimary,
//               ),
//             ),
//             SizedBox(height: 4.h),
//             Text(
//               'wilson@09gail.com',
//               style: getTextStyle(
//                 fontSize: 14.sp,
//                 fontWeight: FontWeight.w400,
//                 color: AppColors.textSecondary,
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildListTile({
//     IconData? icon,
//     Widget? iconWidget,
//     required String title,
//     Color? textColor,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12.w),
//           border: Border.all(color: AppColors.textFormFieldBorder),
//         ),
//         child: Row(
//           children: [
//             if (iconWidget != null)
//               iconWidget
//             else if (icon != null)
//               Icon(icon, color: AppColors.textPrimary, size: 24.w),
//             SizedBox(width: 16.w),
//             Expanded(
//               child: Text(
//                 title,
//                 textAlign: TextAlign.left,
//                 style: getTextStyle(
//                   fontSize: 16.sp,
//                   fontWeight: FontWeight.w500,
//                   color: textColor ?? AppColors.textPrimary,
//                 ),
//               ),
//             ),
//             Icon(
//               Icons.chevron_right,
//               color: const Color(0xFF9CA3AF),
//               size: 24.w,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
