import 'dart:io';
import 'package:flutter/material.dart';
import 'package:point_nemo_service_and_activities/core/custom/more_widgets/custom_text_style.dart';
import 'package:get/get.dart';
import 'package:point_nemo_service_and_activities/core/custom/widgets/custom_submit_button.dart';
import 'package:point_nemo_service_and_activities/core/custom/widgets/custom_text.dart';
import 'package:point_nemo_service_and_activities/core/custom/widgets/custom_textformfield.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_colors.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_sizer.dart';
import 'package:point_nemo_service_and_activities/features/_business_owner_flow/service/controllers/create_or_edit_service_controller.dart';
import 'package:point_nemo_service_and_activities/features/_business_owner_flow/register_boat/views/widgets/additional_service_dialog.dart';
import 'package:point_nemo_service_and_activities/features/_business_owner_flow/service/views/widgets/service_form_widgets.dart';
import 'package:point_nemo_service_and_activities/core/custom/more_widgets/custom_loading_indicator.dart';
import 'package:point_nemo_service_and_activities/core/custom/widgets/custom_dropdown.dart';
import 'package:point_nemo_service_and_activities/core/custom/more_widgets/custom_time_slot_picker.dart';
import 'package:point_nemo_service_and_activities/features/authentication/views/widgets/upload_area_widget.dart';
import 'package:point_nemo_service_and_activities/core/localization/app_localizations.dart';

class CreateServiceScreen extends StatelessWidget {
  final String title;

  const CreateServiceScreen({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CreateServiceController>();
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Container(
            padding: EdgeInsets.all(8.w),
            decoration: const BoxDecoration(
              color: Color(0xFFF3F4F6),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.arrow_back,
              size: 20.sp,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        title: CustomText(
          text: title,
          fontSize: 20.sp,
          fontWeight: FontWeight.w700,
          textColor: AppColors.textPrimary,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ServiceFormWidgets.buildLabel(AppLocalizations.of(context)!.nameText),
                CustomTextFormField(
                  controller: controller.nameController,
                  hintText: AppLocalizations.of(context)!.writeHereHint,
                  containerColor: AppColors.textWhite,
                  containerBorderColor: const Color(0xFFE5E7EB),
                ),
                SizedBox(height: 16.h),
                ServiceFormWidgets.buildLabel(AppLocalizations.of(context)!.location),
                CustomTextFormField(
                  controller: controller.locationController,
                  hintText: AppLocalizations.of(context)!.writeHereHint,
                  containerColor: AppColors.textWhite,
                  containerBorderColor: const Color(0xFFE5E7EB),
                ),
                SizedBox(height: 16.h),
                ServiceFormWidgets.buildLabel(AppLocalizations.of(context)!.priceText),
                CustomTextFormField(
                  controller: controller.priceController,
                  hintText: AppLocalizations.of(context)!.writeHereHint,
                  containerColor: AppColors.textWhite,
                  containerBorderColor: const Color(0xFFE5E7EB),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 16.h),

                // Boat Type dropdown – only for Boat Rental
                if (title == 'Boat Rental') ...[
                  ServiceFormWidgets.buildLabel(AppLocalizations.of(context)!.boatType),
                  Obx(
                    () => CustomDropdownField(
                      hintText: AppLocalizations.of(context)!.selectBoatType,
                      items: CreateServiceController.boatTypeLabels,
                      selectedValue: controller.selectedBoatType.value,
                      onChanged: (value) {
                        controller.selectedBoatType.value = value;
                      },
                      dropdownColor: AppColors.textWhite,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  ServiceFormWidgets.buildLabel(AppLocalizations.of(context)!.modelText),
                  CustomTextFormField(
                    controller: controller.modelController,
                    hintText: AppLocalizations.of(context)!.enterBoatModel,
                    containerColor: AppColors.textWhite,
                    containerBorderColor: const Color(0xFFE5E7EB),
                  ),
                  SizedBox(height: 16.h),
                  ServiceFormWidgets.buildLabel(AppLocalizations.of(context)!.capacityText),
                  CustomTextFormField(
                    controller: controller.capacityController,
                    hintText: AppLocalizations.of(context)!.enterCapacityText,
                    containerColor: AppColors.textWhite,
                    containerBorderColor: const Color(0xFFE5E7EB),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 16.h),
                  ServiceFormWidgets.buildLabel(AppLocalizations.of(context)!.lengthText),
                  CustomTextFormField(
                    controller: controller.lengthController,
                    hintText: AppLocalizations.of(context)!.enterLengthText,
                    containerColor: AppColors.textWhite,
                    containerBorderColor: const Color(0xFFE5E7EB),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 4.h),
                ],

                // Included service section
                SizedBox(height: 16.h),
                ServiceFormWidgets.buildLabel(AppLocalizations.of(context)!.includedServiceText),
                  CustomTextFormField(
                    controller: controller.includedServiceController,
                    hintText: AppLocalizations.of(context)!.writeHereHint,
                    containerColor: AppColors.textWhite,
                    containerBorderColor: const Color(0xFFE5E7EB),
                    suffixIcon: IconButton(
                      onPressed: () => controller.addIncludedService(),
                      icon: Icon(
                        Icons.add_box_outlined,
                        color: AppColors.primary,
                        size: 24.sp,
                      ),
                    ),
                  ),
                  Obx(
                    () => Wrap(
                      spacing: 8.w,
                      children: controller.includedServices
                          .map(
                            (service) => Chip(
                              label: Text(service),
                              onDeleted: () =>
                                  controller.includedServices.remove(service),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                SizedBox(height: 16.h),
                ServiceFormWidgets.buildLabel(AppLocalizations.of(context)!.descriptionsText),
                CustomTextFormField(
                  controller: controller.descriptionController,
                  hintText: AppLocalizations.of(context)!.writeHereHint,
                  containerColor: AppColors.textWhite,
                  containerBorderColor: const Color(0xFFE5E7EB),
                  maxLines: 4,
                  borderRedius: 16,
                ),
                SizedBox(height: 16.h),
                ServiceFormWidgets.buildLabel(AppLocalizations.of(context)!.timeSlotText),
                CustomTimeSlotPicker(
                  startTimeController: controller.startTimeController,
                  endTimeController: controller.endTimeController,
                ),
                SizedBox(height: 16.h),
                ServiceFormWidgets.buildLabel(AppLocalizations.of(context)!.uploadServiceImage(title)),
                Obx(
                  () => UploadAreaWidget(
                    title: AppLocalizations.of(context)!.uploadYourServiceImage(title),
                    subtitle: AppLocalizations.of(context)!.uploadDocumentSubtitle,
                    onTakePhoto: controller.takeServicePhoto,
                    onChooseFile: controller.pickServicePhotos,
                    selectedFileName: controller.servicePhotos.isNotEmpty
                        ? '${controller.servicePhotos.length} ${AppLocalizations.of(context)!.filesSelected}'
                        : null,
                    onRemove: controller.servicePhotos.isNotEmpty
                        ? () {
                            controller.servicePhotos.clear();
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
                        label: controller.servicePhotos.isNotEmpty
                            ? AppLocalizations.of(context)!.photoText('1')
                            : AppLocalizations.of(context)!.addPhoto,
                        file: controller.servicePhotos.isNotEmpty
                            ? controller.servicePhotos[0]
                            : null,
                        onTap: controller.pickServicePhotos,
                        onRemove: () => controller.servicePhotos.removeAt(0),
                      ),
                      SizedBox(width: 12.w),
                      _buildPhotoThumbnail(
                        label: controller.servicePhotos.length > 1
                            ? AppLocalizations.of(context)!.photoText('2')
                            : AppLocalizations.of(context)!.addPhoto,
                        file: controller.servicePhotos.length > 1
                            ? controller.servicePhotos[1]
                            : null,
                        onTap: controller.pickServicePhotos,
                        onRemove: () => controller.servicePhotos.removeAt(1),
                      ),
                      SizedBox(width: 12.w),
                      _buildPhotoThumbnail(
                        label: controller.servicePhotos.length > 2
                            ? AppLocalizations.of(context)!.photoText('3')
                            : AppLocalizations.of(context)!.addPhoto,
                        file: controller.servicePhotos.length > 2
                            ? controller.servicePhotos[2]
                            : null,
                        onTap: controller.pickServicePhotos,
                        onRemove: () => controller.servicePhotos.removeAt(2),
                      ),
                    ],
                  ),
                ),

                // Additional service section
                SizedBox(height: 16.h),
                ServiceFormWidgets.buildLabel(AppLocalizations.of(context)!.additionalService),
                  GestureDetector(
                    onTap: () => AdditionalServiceDialog.show(
                      nameController: controller.additionalServiceNameController,
                      priceController: controller.additionalServicePriceController,
                      onAdd: () => controller.addAdditionalService(),
                      context: context,
                    ),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: AppColors.primary, width: 1),
                      ),
                      child: Icon(
                        Icons.add,
                        color: AppColors.primary,
                        size: 24.sp,
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
                                  controller.additionalServices.remove(service),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                SizedBox(height: 32.h),
                Obx(() => CustomSubmitButton(
                  text: controller.editId != null ? AppLocalizations.of(context)!.updateServiceText : AppLocalizations.of(context)!.continueText,
                  onTap: () {
                    String type = 'WATER_SPORTS';
                    if (title == 'Boat Rental') {
                      type = 'BOAT_RENTAL';
                    } else if (title == 'Diving Course') {
                      type = 'DIVING_COURSE';
                    } else if (title == 'Fishing Trip') {
                      type = 'FISHING_TRIP';
                    }
                    controller.submitService(serviceType: type);
                  },
                  borderRadius: BorderRadius.circular(32),
                  child: controller.isLoading.value 
                      ? const CustomLoadingIndicator()
                      : null,
                )),
                SizedBox(height: 20.h),
              ],
            ),
          ),
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
}
