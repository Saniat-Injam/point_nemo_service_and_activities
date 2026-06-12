// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl_phone_field/intl_phone_field.dart';
// import 'package:point_nemo_service_and_activities/core/custom/widgets/custom_appbar.dart';
// import 'package:point_nemo_service_and_activities/core/custom/more_widgets/global_text_style.dart';
// import 'package:point_nemo_service_and_activities/core/custom/widgets/custom_textformfield.dart';
// import 'package:point_nemo_service_and_activities/core/custom/widgets/custom_dropdown.dart';
// import 'package:point_nemo_service_and_activities/core/custom/widgets/custom_submit_button.dart';
// import 'package:point_nemo_service_and_activities/core/utils/constants/app_colors.dart';
// import 'package:point_nemo_service_and_activities/core/utils/constants/app_sizer.dart';
// import 'package:point_nemo_service_and_activities/core/utils/constants/image_path.dart';
// import 'package:point_nemo_service_and_activities/features/_captain_flow/profile/controllers/profile_controller.dart';

// class EditProfileScreen extends StatelessWidget {
//   const EditProfileScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // Lazily instantiate or retrieve the ProfileController
//     final ProfileController controller = Get.find<ProfileController>();

//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: CustomAppBar(
//         title: 'Edit Profile',
//         borderRadius: 0,
//         backgroundColor: Colors.white,
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Center(
//                 child: Stack(
//                   children: [
//                     CircleAvatar(
//                       radius: 55.w,
//                       backgroundImage: const AssetImage(ImagePath.jennyWilson),
//                     ),
//                     Positioned(
//                       bottom: 0,
//                       right: 0,
//                       child: Container(
//                         padding: EdgeInsets.all(6.w),
//                         decoration: BoxDecoration(
//                           color: const Color(0xFF040A18),
//                           shape: BoxShape.circle,
//                           border: Border.all(color: Colors.white, width: 2.w),
//                         ),
//                         child: Icon(
//                           Icons.edit,
//                           color: Colors.white,
//                           size: 16.w,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 30.h),
//               _buildLabel('Full Name'),
//               CustomTextFormField(
//                 controller: controller.nameController,
//                 hintText: 'Enter full name',
//                 containerColor: Colors.white,
//                 borderRedius: 12.w,
//               ),
//               SizedBox(height: 16.h),
//               _buildLabel('Email'),
//               CustomTextFormField(
//                 controller: controller.emailController,
//                 hintText: 'Enter email',
//                 containerColor: Colors.white,
//                 borderRedius: 12.w,
//               ),
//               SizedBox(height: 16.h),
//               _buildLabel('Phone Number'),
//               IntlPhoneField(
//                 controller: controller.phoneController,
//                 decoration: InputDecoration(
//                   hintText: 'Enter phone number',
//                   hintStyle: getTextStyle(
//                     fontSize: 14.sp,
//                     fontWeight: FontWeight.w400,
//                     color: const Color(0xFF9CA3AF),
//                   ),
//                   filled: true,
//                   fillColor: Colors.white,
//                   contentPadding: EdgeInsets.symmetric(
//                     horizontal: 16.w,
//                     vertical: 16.h,
//                   ),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(
//                       12.w,
//                     ), // 12.w in edit profile
//                     borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12.w),
//                     borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12.w),
//                     borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
//                   ),
//                 ),
//                 initialCountryCode: 'US',
//               ),
//               SizedBox(height: 16.h),
//               _buildLabel('Date of Birth'),
//               CustomTextFormField(
//                 controller: controller.dobController,
//                 hintText: 'Enter date of birth',
//                 containerColor: Colors.white,
//                 borderRedius: 12.w,
//                 suffixIcon: Icon(
//                   Icons.calendar_today_outlined,
//                   color: AppColors.textSecondary,
//                   size: 20.w,
//                 ),
//               ),
//               SizedBox(height: 16.h),
//               _buildLabel('Location'),
//               CustomTextFormField(
//                 controller: controller.locationController,
//                 hintText: 'Enter your location',
//                 containerColor: Colors.white,
//                 borderRedius: 12.w,
//               ),
//               SizedBox(height: 16.h),
//               _buildLabel('Gender'),
//               Obx(() {
//                 return CustomDropdownField(
//                   hintText: 'Select gender',
//                   items: const ['Male', 'Female', 'Other'],
//                   selectedValue: controller.selectedGender.value,
//                   onChanged: (val) {
//                     controller.setGender(val);
//                   },
//                   radius: 12.w,
//                 );
//               }),
//               SizedBox(height: 40.h),
//               CustomSubmitButton(
//                 text: 'Save Changes',
//                 textColor: Colors.white,
//                 color: const Color(0xFF040A18),
//                 borderRadius: BorderRadius.circular(30.w),
//                 onTap: () {
//                   Get.back();
//                 },
//               ),
//               SizedBox(height: 20.h),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildLabel(String text) {
//     return Padding(
//       padding: EdgeInsets.only(bottom: 8.h),
//       child: Text(
//         text,
//         style: getTextStyle(
//           fontSize: 14.sp,
//           fontWeight: FontWeight.w500,
//           color: AppColors.textPrimary,
//         ),
//       ),
//     );
//   }
// }
