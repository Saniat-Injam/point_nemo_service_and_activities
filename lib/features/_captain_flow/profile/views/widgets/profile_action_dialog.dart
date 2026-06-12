// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:point_nemo_service_and_activities/core/custom/more_widgets/global_text_style.dart';
// import 'package:point_nemo_service_and_activities/core/custom/widgets/custom_submit_button.dart';
// import 'package:point_nemo_service_and_activities/core/utils/constants/app_colors.dart';
// import 'package:point_nemo_service_and_activities/core/utils/constants/app_sizer.dart';

// class ProfileActionDialog extends StatelessWidget {
//   final String title;
//   final String actionText;
//   final VoidCallback onCancel;
//   final VoidCallback onAction;

//   const ProfileActionDialog({
//     super.key,
//     required this.title,
//     required this.actionText,
//     required this.onCancel,
//     required this.onAction,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       backgroundColor: Colors.white,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.w)),
//       insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
//       child: Padding(
//         padding: EdgeInsets.all(24.w),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             // Close Button
//             Align(
//               alignment: Alignment.topRight,
//               child: GestureDetector(
//                 onTap: () => Get.back(),
//                 child: Icon(
//                   Icons.close,
//                   size: 24.w,
//                   color: AppColors.textPrimary,
//                 ),
//               ),
//             ),
//             SizedBox(height: 16.h),
//             // Title
//             Text(
//               title,
//               textAlign: TextAlign.center,
//               style: getTextStyle(
//                 fontSize: 20.sp,
//                 fontWeight: FontWeight.w500,
//                 color: AppColors.textPrimary,
//                 height: 1.4,
//               ),
//             ),
//             SizedBox(height: 32.h),
//             // Cancel Button
//             CustomSubmitButton(text: 'Cancel', onTap: onCancel),
//             SizedBox(height: 24.h),
//             // Action Text Button
//             GestureDetector(
//               onTap: onAction,
//               child: Padding(
//                 padding: EdgeInsets.symmetric(vertical: 8.h),
//                 child: Text(
//                   actionText,
//                   style: getTextStyle(
//                     fontSize: 16.sp,
//                     fontWeight: FontWeight.w500,
//                     color: const Color(0xFFFF5454), // Red color for action
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(height: 8.h),
//           ],
//         ),
//       ),
//     );
//   }
// }
