// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import 'package:point_nemo_service_and_activities/core/custom/more_widgets/global_text_style.dart';
// import 'package:point_nemo_service_and_activities/core/custom/widgets/custom_appbar.dart';
// import 'package:point_nemo_service_and_activities/core/custom/widgets/custom_submit_button.dart';
// import 'package:point_nemo_service_and_activities/core/utils/constants/app_colors.dart';
// import 'package:point_nemo_service_and_activities/core/utils/constants/app_sizer.dart';
// import 'package:point_nemo_service_and_activities/features/_captain_flow/profile/controllers/profile_controller.dart';

// class LanguageScreen extends StatelessWidget {
//   const LanguageScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // Lazily instantiate or retrieve the ProfileController
//     final ProfileController controller = Get.find<ProfileController>();

//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: CustomAppBar(
//         title: 'Language',
//         titleSize: 20.sp,
//         titleColor: AppColors.textPrimary,
//         backgroundColor: Colors.white,
//         showBackIcon: true,
//         borderRadius: 0,
//         enableShadow: false,
//       ),
//       body: SafeArea(
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
//           child: Column(
//             children: [
//               _buildLanguageOption(
//                 controller,
//                 'English',
//                 'assets/images/usa_flag.png',
//               ),
//               SizedBox(height: 16.h),
//               _buildLanguageOption(
//                 controller,
//                 'Arabic',
//                 'assets/images/arabic_flag.png',
//               ),
//               const Spacer(),
//               CustomSubmitButton(
//                 text: 'Confirm',
//                 onTap: () {
//                   // Handle language change
//                   Get.back();
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildLanguageOption(
//     ProfileController controller,
//     String language,
//     String flagPath,
//   ) {
//     return Obx(() {
//       bool isSelected = controller.selectedLanguage.value == language;
//       return GestureDetector(
//         onTap: () {
//           controller.setLanguage(language);
//         },
//         child: Container(
//           padding: EdgeInsets.symmetric(vertical: 12.h),
//           color: Colors.transparent, // Ensures the whole row is clickable
//           child: Row(
//             children: [
//               Image.asset(
//                 flagPath,
//                 width: 24.w,
//                 height: 24.w,
//                 fit: BoxFit.cover,
//               ),
//               SizedBox(width: 12.w),
//               Expanded(
//                 child: Text(
//                   language,
//                   textAlign: TextAlign.left,
//                   style: getTextStyle(
//                     fontSize: 16.sp,
//                     fontWeight: FontWeight.w500,
//                     color: AppColors.textPrimary,
//                   ),
//                 ),
//               ),
//               Container(
//                 width: 24.w,
//                 height: 24.w,
//                 padding: EdgeInsets.all(4.w),
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   border: Border.all(
//                     color: isSelected
//                         ? const Color(0xFF0B1426)
//                         : AppColors.textFormFieldBorder,
//                     width: 2.w,
//                   ),
//                 ),
//                 child: isSelected
//                     ? Container(
//                         decoration: const BoxDecoration(
//                           shape: BoxShape.circle,
//                           color: Color(0xFF0B1426),
//                         ),
//                       )
//                     : null,
//               ),
//             ],
//           ),
//         ),
//       );
//     });
//   }
// }
