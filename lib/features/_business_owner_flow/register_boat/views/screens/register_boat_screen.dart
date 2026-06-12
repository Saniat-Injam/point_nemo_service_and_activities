import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_sizer.dart';
import 'package:point_nemo_service_and_activities/features/_business_owner_flow/register_boat/views/widgets/additional_service_dialog.dart';
import 'package:point_nemo_service_and_activities/core/custom/widgets/custom_appbar.dart';
import 'package:point_nemo_service_and_activities/core/custom/widgets/custom_textformfield.dart';
import 'package:point_nemo_service_and_activities/core/custom/widgets/custom_submit_button.dart';
import 'package:point_nemo_service_and_activities/core/custom/more_widgets/custom_text_style.dart';
import 'package:point_nemo_service_and_activities/core/custom/more_widgets/custom_loading_indicator.dart';
import 'package:point_nemo_service_and_activities/features/_business_owner_flow/register_boat/controllers/register_boat_controller.dart';
import 'package:point_nemo_service_and_activities/features/authentication/views/widgets/upload_area_widget.dart';
import 'package:point_nemo_service_and_activities/core/custom/more_widgets/custom_time_slot_picker.dart';
import 'package:point_nemo_service_and_activities/core/localization/app_localizations.dart';
import 'package:point_nemo_service_and_activities/core/utils/validators/app_validator.dart';

class RegisterBoatScreen extends StatelessWidget {
  const RegisterBoatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RegisterBoatController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.registerYourBoat,
        backgroundColor: Colors.white,
        showBackIcon: true,
        centerTitle: false,
        titleColor: const Color(0xFF1D1B20),
        titleSize: 20.sp,
        titleWeight: FontWeight.w600,
        enableShadow: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Boat Type Header
                _buildRequiredLabel(AppLocalizations.of(context)!.boatType),
                SizedBox(height: 12.h),

                // Boat Types Grid
                Wrap(
                  spacing: 12.w,
                  runSpacing: 12.h,
                  children: controller.boatTypes.map((boatType) {
                    return Obx(() {
                      final isSelected =
                          controller.selectedBoatType.value == boatType.name;
                      return GestureDetector(
                        onTap: () => controller.selectBoatType(boatType.name),
                        child: Container(
                          width: 106.w,
                          height: 90.h,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F4F6),
                            borderRadius: BorderRadius.circular(12.w),
                            border: isSelected
                                ? Border.all(
                                    color: const Color(0xFF1D1B20),
                                    width: 1.5,
                                  )
                                : Border.all(
                                    color: Colors.transparent,
                                    width: 1.5,
                                  ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                boatType.imagePath,
                                height: 40.h,
                                fit: BoxFit.contain,
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                boatType.name,
                                style: getTextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF1D1B20),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    });
                  }).toList(),
                ),
                Obx(() {
                  if (controller.boatTypeError.value.isNotEmpty) {
                    return Padding(
                      padding: EdgeInsets.only(top: 8.h, left: 4.w),
                      child: Text(
                        controller.boatTypeError.value,
                        style: getTextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFFF44336), 
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                }),
                SizedBox(height: 24.h),

                // Location
                _buildRequiredLabel(AppLocalizations.of(context)!.location),
                SizedBox(height: 8.h),
                CustomTextFormField(
                  controller: controller.locationController,
                  hintText: AppLocalizations.of(context)!.enterLocation,
                  validation: (value) => AppValidator.validateNotEmptyWithAll(
                    value,
                    AppLocalizations.of(context)!.location,
                  ),
                  containerColor: Colors.white,
                  containerBorderColor: const Color(0xFFE5E7EB),
                  borderRedius: 28.w,
                ),
                SizedBox(height: 16.h),

                // Name
                _buildRequiredLabel(AppLocalizations.of(context)!.nameText),
                SizedBox(height: 8.h),
                CustomTextFormField(
                  controller: controller.nameController,
                  hintText: AppLocalizations.of(context)!.enterBoatName,
                  validation: (value) => AppValidator.validateNotEmptyWithAll(
                    value,
                    AppLocalizations.of(context)!.nameText,
                  ),
                  containerColor: Colors.white,
                  containerBorderColor: const Color(0xFFE5E7EB),
                  borderRedius: 28.w,
                ),
                SizedBox(height: 16.h),

                // Model
                _buildRequiredLabel(AppLocalizations.of(context)!.modelText),
                SizedBox(height: 8.h),
                CustomTextFormField(
                  controller: controller.modelController,
                  hintText: AppLocalizations.of(context)!.enterBoatModel,
                  validation: (value) => AppValidator.validateNotEmptyWithAll(
                    value,
                    AppLocalizations.of(context)!.modelText,
                  ),
                  containerColor: Colors.white,
                  containerBorderColor: const Color(0xFFE5E7EB),
                  borderRedius: 28.w,
                ),
                SizedBox(height: 16.h),

                // Capacity
                _buildRequiredLabel(AppLocalizations.of(context)!.capacityText),
                SizedBox(height: 8.h),
                CustomTextFormField(
                  controller: controller.capacityController,
                  hintText: AppLocalizations.of(context)!.enterBoatCapacity,
                  keyboardType: TextInputType.number,
                  validation: (value) => AppValidator.validateNumberOnly(
                    value,
                    AppLocalizations.of(context)!.capacityText,
                  ),
                  containerColor: Colors.white,
                  containerBorderColor: const Color(0xFFE5E7EB),
                  borderRedius: 28.w,
                ),
                SizedBox(height: 16.h),

                // Boat length
                _buildRequiredLabel(
                  AppLocalizations.of(context)!.boatLengthText,
                ),
                SizedBox(height: 8.h),
                CustomTextFormField(
                  controller: controller.lengthController,
                  hintText: AppLocalizations.of(context)!.enterBoatLength,
                  keyboardType: TextInputType.number,
                  validation: (value) => AppValidator.validateNumberOnly(
                    value,
                    AppLocalizations.of(context)!.boatLengthText,
                  ),
                  containerColor: Colors.white,
                  containerBorderColor: const Color(0xFFE5E7EB),
                  borderRedius: 28.w,
                ),
                SizedBox(height: 16.h),

                // Boat Price
                _buildRequiredLabel(
                  AppLocalizations.of(context)!.boatPriceText,
                ),
                SizedBox(height: 8.h),
                CustomTextFormField(
                  controller: controller.priceController,
                  hintText: AppLocalizations.of(context)!.enterPrice,
                  keyboardType: TextInputType.number,
                  validation: (value) => AppValidator.validateNumberOnly(
                    value,
                    AppLocalizations.of(context)!.boatPriceText,
                  ),
                  containerColor: Colors.white,
                  containerBorderColor: const Color(0xFFE5E7EB),
                  borderRedius: 28.w,
                ),
                SizedBox(height: 16.h),

                // Time slot
                Text(
                  AppLocalizations.of(context)!.timeSlotText,
                  style: getTextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF1D1B20),
                  ),
                ),
                SizedBox(height: 8.h),
                CustomTimeSlotPicker(
                  startTimeController: controller.startTimeController,
                  endTimeController: controller.endTimeController,
                ),
                SizedBox(height: 16.h),

                // Included Service
                Text(
                  AppLocalizations.of(context)!.includedServiceText,
                  style: getTextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF1D1B20),
                  ),
                ),
                SizedBox(height: 8.h),
                CustomTextFormField(
                  controller: controller.includedServiceController,
                  hintText: AppLocalizations.of(context)!.writeHereHint,
                  suffixIcon: Padding(
                    padding: EdgeInsets.all(12.w),
                    child: GestureDetector(
                      onTap: controller.addIncludedService,
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF1D1B20),
                          borderRadius: BorderRadius.circular(6.w),
                        ),
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 20.w,
                        ),
                      ),
                    ),
                  ),
                  containerColor: Colors.white,
                  containerBorderColor: const Color(0xFFE5E7EB),
                  borderRedius: 28.w,
                ),
                SizedBox(height: 12.h),
                Obx(
                  () => Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: controller.includedServices.map((service) {
                      return Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F4F6),
                          borderRadius: BorderRadius.circular(20.w),
                          border: Border.all(color: const Color(0xFFE5E7EB)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              service,
                              style: getTextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF1D1B20),
                              ),
                            ),
                            SizedBox(width: 8.w),
                            GestureDetector(
                              onTap: () => controller.removeIncludedService(service),
                              child: Icon(
                                Icons.close,
                                size: 16.w,
                                color: const Color(0xFF9CA3AF),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: 16.h),

                // Description
                Text(
                  AppLocalizations.of(context)!.descriptionsText,
                  style: getTextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF1D1B20),
                  ),
                ),
                SizedBox(height: 8.h),
                CustomTextFormField(
                  controller: controller.descriptionController,
                  hintText: AppLocalizations.of(context)!.writeHereHint,
                  containerColor: Colors.white,
                  containerBorderColor: const Color(0xFFE5E7EB),
                  borderRedius: 28.w,
                  maxLines: 4,
                ),
                SizedBox(height: 24.h),

                // Upload Boat Image
                Text(
                  AppLocalizations.of(context)!.uploadBoatImage,
                  style: getTextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF1D1B20),
                  ),
                ),
                SizedBox(height: 8.h),
                Obx(
                  () => UploadAreaWidget(
                    title: AppLocalizations.of(context)!.uploadBoatCoverImage,
                    subtitle: AppLocalizations.of(
                      context,
                    )!.uploadDocumentSubtitle,
                    onTakePhoto: controller.takeBoatPhoto,
                    onChooseFile: controller.pickBoatImage,
                    selectedFileName: controller.boatCoverImage.value != null
                        ? '${1 + controller.boatPhotos.length} ${AppLocalizations.of(context)!.filesSelected}'
                        : null,
                    onRemove: controller.boatCoverImage.value != null
                        ? () {
                            controller.boatCoverImage.value = null;
                            controller.boatPhotos.clear();
                          }
                        : null,
                  ),
                ),
                SizedBox(height: 16.h),

                // Photo thumbnails placeholder
                Obx(
                  () => Row(
                    children: [
                      _buildPhotoThumbnail(
                        label: controller.boatCoverImage.value != null
                            ? AppLocalizations.of(context)!.photoText('1')
                            : AppLocalizations.of(context)!.addPhoto,
                        file: controller.boatCoverImage.value,
                        onTap: controller.pickBoatImage,
                        onRemove: () => controller.removeBoatPhoto(0),
                      ),
                      SizedBox(width: 12.w),
                      _buildPhotoThumbnail(
                        label: controller.boatPhotos.isNotEmpty
                            ? AppLocalizations.of(context)!.photoText('2')
                            : AppLocalizations.of(context)!.addPhoto,
                        file: controller.boatPhotos.isNotEmpty
                            ? controller.boatPhotos[0]
                            : null,
                        onTap: controller.pickBoatImage,
                        onRemove: () => controller.removeBoatPhoto(1),
                      ),
                      SizedBox(width: 12.w),
                      _buildPhotoThumbnail(
                        label: controller.boatPhotos.length > 1
                            ? AppLocalizations.of(context)!.photoText('3')
                            : AppLocalizations.of(context)!.addPhoto,
                        file: controller.boatPhotos.length > 1
                            ? controller.boatPhotos[1]
                            : null,
                        onTap: controller.pickBoatImage,
                        onRemove: () => controller.removeBoatPhoto(2),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),

                // Upload NID
                Text(
                  AppLocalizations.of(context)!.uploadNid,
                  style: getTextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF1D1B20),
                  ),
                ),
                SizedBox(height: 8.h),
                Obx(
                  () => UploadAreaWidget(
                    title: AppLocalizations.of(context)!.uploadYourNid,
                    subtitle: AppLocalizations.of(
                      context,
                    )!.uploadDocumentSubtitle,
                    onTakePhoto: controller.takeNidPhoto,
                    onChooseFile: controller.pickNidImage,
                    selectedFileName: controller.nidImage.value?.path
                        .split('/')
                        .last,
                    onRemove: controller.nidImage.value != null
                        ? () => controller.nidImage.value = null
                        : null,
                  ),
                ),
                SizedBox(height: 24.h),

                // Upload Boat Documents
                Text(
                  AppLocalizations.of(context)!.uploadBoatDocuments,
                  style: getTextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF1D1B20),
                  ),
                ),
                SizedBox(height: 8.h),
                Obx(
                  () => UploadAreaWidget(
                    title: AppLocalizations.of(context)!.uploadBoatDocuments,
                    subtitle: AppLocalizations.of(
                      context,
                    )!.uploadDocumentSubtitle,
                    onTakePhoto: controller.takeDocsPhoto,
                    onChooseFile: controller.pickDocsImage,
                    selectedFileName: controller.docsFile.value?.path
                        .split('/')
                        .last,
                    onRemove: controller.docsFile.value != null
                        ? () => controller.docsFile.value = null
                        : null,
                  ),
                ),
                SizedBox(height: 24.h),

                // Additional Service
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.additionalService,
                      style: getTextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF1D1B20),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                GestureDetector(
                  onTap: () => AdditionalServiceDialog.show(
                    nameController: controller.additionalServiceNameController,
                    priceController:
                        controller.additionalServicePriceController,
                    onAdd: () => controller.addAdditionalService(),
                    context: context,
                  ),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28.w),
                      border: Border.all(
                        color: const Color(0xFF1D1B20),
                        width: 1.5,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '+',
                        style: getTextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF1D1B20),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                Obx(
                  () => Column(
                    children: controller.additionalServices
                        .map(
                          (service) => _buildAdditionalServiceCard(
                            name: service['name'] ?? '',
                            price: service['price'] ?? '0',
                            onDelete: () =>
                                controller.removeAdditionalService(service),
                          ),
                        )
                        .toList(),
                  ),
                ),
                SizedBox(height: 32.h),

                // Save Button
                Obx(
                  () => controller.isLoading.value
                      ? const CustomLoadingIndicator()
                      : CustomSubmitButton(
                          text: AppLocalizations.of(context)!.saveText,
                          onTap: controller.saveBoat,
                          color: const Color(0xFF040A18),
                          textColor: Colors.white,
                          borderRadius: BorderRadius.circular(28.w),
                          padding: EdgeInsets.symmetric(vertical: 18.h),
                        ),
                ),
                SizedBox(height: 32.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoThumbnail({
    required String label,
    File? file,
    VoidCallback? onTap,
    VoidCallback? onRemove,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: double.infinity,
              height: 80.h,
              decoration: BoxDecoration(
                color: const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(8.w),
                image: file != null
                    ? DecorationImage(image: FileImage(file), fit: BoxFit.cover)
                    : null,
              ),
              child: file == null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.camera_alt_outlined,
                          size: 24.w,
                          color: const Color(0xFF9CA3AF),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          label,
                          style: getTextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF9CA3AF),
                          ),
                        ),
                      ],
                    )
                  : null,
            ),
            if (file != null && onRemove != null)
              Positioned(
                top: -8.h,
                right: -8.w,
                child: GestureDetector(
                  onTap: onRemove,
                  child: Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.close, size: 14.w, color: Colors.white),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdditionalServiceCard({
    required String name,
    required String price,
    required VoidCallback onDelete,
  }) {
    // Format price as $XX.00
    final double parsedPrice = double.tryParse(price) ?? 0;
    final String formattedPrice = '\$${parsedPrice.toStringAsFixed(2)}';

    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Dismissible(
        key: UniqueKey(),
        direction: DismissDirection.endToStart,
        onDismissed: (_) => onDelete(),
        background: Container(
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(right: 16.w),
          decoration: BoxDecoration(
            color: Colors.red.shade400,
            borderRadius: BorderRadius.circular(16.w),
          ),
          child: Icon(Icons.delete, color: Colors.white, size: 24.sp),
        ),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(16.w),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  name,
                  style: getTextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF1A1A2E),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                formattedPrice,
                style: getTextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1A1A2E),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRequiredLabel(String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: getTextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF1D1B20),
          ),
        ),
        SizedBox(width: 4.w),
        Padding(
          padding: EdgeInsets.only(top: 2.h),
          child: Text(
            '*',
            style: getTextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFFE53935),
            ),
          ),
        ),
      ],
    );
  }
}
