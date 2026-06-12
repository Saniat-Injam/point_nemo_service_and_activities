import 'package:flutter/material.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:point_nemo_service_and_activities/core/utils/constants/app_sizer.dart';
import 'package:point_nemo_service_and_activities/core/custom/more_widgets/custom_text_style.dart';
import 'package:point_nemo_service_and_activities/core/custom/more_widgets/custom_loading_indicator.dart';
import 'package:get/get.dart';
import 'package:point_nemo_service_and_activities/features/_user_flow/search_and_filter/controllers/boat_filter_controller.dart';
import 'package:point_nemo_service_and_activities/features/_user_flow/explore/models/boat_rental_model.dart';
import 'package:point_nemo_service_and_activities/core/localization/app_localizations.dart';

class BoatFilterDrawer extends StatelessWidget {
  const BoatFilterDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BoatFilterController>();

    return Drawer(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Container(
            padding: EdgeInsets.all(8.w),
            decoration: const BoxDecoration(
              color: Color(0xFFF3F4F6),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.arrow_back, color: Colors.black, size: 20.w),
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          AppLocalizations.of(context)!.filterText,
          style: getTextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    controller.resetFilters();
                  },
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    side: const BorderSide(color: Color(0xFFE5E7EB)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.w),
                    ),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.resetText,
                    style: getTextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Obx(
                  () => ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : () => controller.applyFilters(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF040A18),
                      disabledBackgroundColor: const Color(0xFF040A18).withValues(alpha: 0.5),
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.w),
                      ),
                      elevation: 0,
                    ),
                    child: controller.isLoading.value
                        ? SizedBox(
                            height: 24.w,
                            width: 24.w,
                            child: const FittedBox(
                              child: CustomLoadingIndicator(),
                            ),
                          )
                        : Text(
                            AppLocalizations.of(context)!.submitText,
                            style: getTextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: ListView(
        controller: controller.scrollController,
        padding: EdgeInsets.fromLTRB(
          24.w,
          24.w,
          24.w,
          // Extra bottom padding: nav bar (~90.h) + safe area bottom inset
          90.h + MediaQuery.of(context).padding.bottom + 32.h,
        ),
        children: [
          // Top Boat Rental Container
          Container(
            padding: EdgeInsets.symmetric(vertical: 20.h),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(12.w),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Column(
              children: [
                Text(
                  AppLocalizations.of(context)!.boatRentalText,
                  style: getTextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  AppLocalizations.of(context)!.allBoatRentalsText,
                  style: getTextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),

          // Location and Date Row
          Row(
            children: [
              // Location field
              Expanded(
                child: GestureDetector(
                  onTap: () => _showAddressDialog(context, controller),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 12.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.w),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 20.w,
                          color: Colors.black54,
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Obx(
                            () => Text(
                              controller.address.value.isEmpty
                                  ? AppLocalizations.of(context)!.whereText
                                  : controller.address.value,
                              style: getTextStyle(
                                fontSize: 14.sp,
                                color: controller.address.value.isEmpty
                                    ? Colors.black45
                                    : Colors.black,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              // Date field
              Expanded(
                child: GestureDetector(
                  onTap: () => _pickDateRange(context, controller),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 12.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.w),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 20.w,
                          color: Colors.black54,
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Obx(
                            () => Text(
                              _formatDateRange(
                                context,
                                controller.startDate.value,
                                controller.endDate.value,
                              ),
                              style: getTextStyle(
                                fontSize: 13.sp,
                                color: (controller.startDate.value == null &&
                                        controller.endDate.value == null)
                                    ? Colors.black45
                                    : Colors.black,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.chevron_right,
                          size: 20.w,
                          color: const Color(0xFF9CA3AF),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 32.h),

          // Boat Type
          Text(
            AppLocalizations.of(context)!.boatType,
            style: getTextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 16.h),
          Divider(color: const Color(0xFFF3F4F6), height: 1),
          SizedBox(height: 16.h),
          ...BoatFilterController.boatTypeLabels
              .map((label) => _buildRadioButton(context, label, controller)),
          SizedBox(height: 16.h),

          // Price per day
          Text(
            AppLocalizations.of(context)!.pricePerDayText,
            style: getTextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 24.h),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              rangeThumbShape: CustomRangeThumbShape(thumbRadius: 14.w),
              trackHeight: 4.h,
              activeTrackColor: const Color(0xFF040A18),
              inactiveTrackColor: const Color(0xFFE5E7EB),
            ),
            child: Obx(
              () => RangeSlider(
                values: controller.priceRange.value,
                min: 0,
                max: 10000,
                onChanged: controller.updatePriceRange,
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: const Color(0xFFF3F4F6)),
                    borderRadius: BorderRadius.circular(8.w),
                  ),
                  child: Column(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.minimumText,
                        style: getTextStyle(
                          fontSize: 14.sp,
                          color: const Color(0xFF4B5563),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Obx(
                        () => Text(
                          '\$${controller.priceRange.value.start.toInt()}',
                          style: getTextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: const Color(0xFFF3F4F6)),
                    borderRadius: BorderRadius.circular(8.w),
                  ),
                  child: Column(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.maximumText,
                        style: getTextStyle(
                          fontSize: 14.sp,
                          color: const Color(0xFF4B5563),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Obx(
                        () => Text(
                          '\$${controller.priceRange.value.end.toInt()}${controller.priceRange.value.end >= 10000 ? '+' : ''}',
                          style: getTextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 32.h),

          // Counters
          Obx(
            () => _buildCounterRow(
              AppLocalizations.of(context)!.numberOfPeopleText,
              controller.numPeople.value,
              controller.decrementPeople,
              controller.incrementPeople,
            ),
          ),

          SizedBox(height: 32.h),

          // Boat length
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  AppLocalizations.of(context)!.boatLengthText,
                  style: getTextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Obx(
                () => Text(
                  '${controller.lengthRange.value.start.toInt()} - ${controller.lengthRange.value.end.toInt()}${controller.lengthRange.value.end >= 100 ? '+' : ''} m',
                  style: getTextStyle(
                    fontSize: 14.sp,
                    color: const Color(0xFF6B7280),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              rangeThumbShape: CustomRangeThumbShape(thumbRadius: 14.w),
              trackHeight: 4.h,
              activeTrackColor: const Color(0xFF040A18),
              inactiveTrackColor: const Color(0xFFE5E7EB),
            ),
            child: Obx(
              () => RangeSlider(
                values: controller.lengthRange.value,
                min: 0,
                max: 100,
                onChanged: controller.updateLengthRange,
              ),
            ),
          ),
          SizedBox(height: 32.h),

          // Results Section (shown while loading OR after results arrive)
          Obx(() {
            // Show spinner during API call
            if (controller.isLoading.value) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 24.h),
                child: const CustomLoadingIndicator(),
              );
            }
            // Nothing to show yet
            if (!controller.hasResults.value) {
              return const SizedBox.shrink();
            }
            // Empty results
            if (controller.boatRentals.isEmpty) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 24.h),
                  child: Text(
                    AppLocalizations.of(context)!.noBoatRentalsFound,
                    style: getTextStyle(
                      fontSize: 14.sp,
                      color: const Color(0xFF6B7280),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }
            // Results list
            return Column(
              key: controller.resultsKey,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(color: const Color(0xFFE5E7EB), height: 1),
                SizedBox(height: 24.h),
                Text(
                  '${AppLocalizations.of(context)!.resultsText} (${controller.boatRentals.length})',
                  style: getTextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 16.h),
                ...controller.boatRentals.map(
                  (boat) => _buildBoatRentalCard(context, boat),
                ),
              ],
            );
          }),
        ],
      ),
    ));
  }

  // ── Helpers ──────────────────────────────────────────────────────────────

  String _formatDateRange(BuildContext context, DateTime? start, DateTime? end) {
    if (start == null && end == null) return AppLocalizations.of(context)!.selectDatesText;
    final fmt = DateFormat('MMM dd');
    if (start != null && end != null) {
      return '${fmt.format(start)} – ${fmt.format(end)}';
    }
    if (start != null) return '${fmt.format(start)} – ?';
    return '? – ${fmt.format(end!)}';
  }

  Future<void> _pickDateRange(
    BuildContext context,
    BoatFilterController controller,
  ) async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365 * 2)),
      initialDateRange: controller.startDate.value != null &&
              controller.endDate.value != null
          ? DateTimeRange(
              start: controller.startDate.value!,
              end: controller.endDate.value!,
            )
          : null,
      builder: (ctx, child) => Theme(
        data: ThemeData.light().copyWith(
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF040A18),
            onPrimary: Colors.white,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      controller.setStartDate(picked.start);
      controller.setEndDate(picked.end);
    }
  }

  void _showAddressDialog(
    BuildContext context,
    BoatFilterController controller,
  ) {
    final textController = TextEditingController(text: controller.address.value);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          AppLocalizations.of(context)!.enterLocationText,
          style: getTextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
        ),
        content: TextField(
          controller: textController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'e.g. Dubai Marina',
            hintStyle: getTextStyle(
              fontSize: 14.sp,
              color: const Color(0xFF9CA3AF),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.w),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.w),
              borderSide: const BorderSide(color: Color(0xFF040A18)),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              AppLocalizations.of(context)!.cancelText,
              style: getTextStyle(color: const Color(0xFF6B7280)),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF040A18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.w),
              ),
            ),
            onPressed: () {
              controller.updateAddress(textController.text);
              Get.back();
            },
            child: Text(
              'OK',
              style: getTextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBoatRentalCard(BuildContext context, BoatRentalModel boat) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cover image
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.w)),
            child: boat.coverImage.isNotEmpty
                ? Image.network(
                    boat.coverImage,
                    height: 160.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 160.h,
                      color: const Color(0xFFF3F4F6),
                      child: const Icon(
                        Icons.directions_boat_outlined,
                        size: 48,
                        color: Color(0xFF9CA3AF),
                      ),
                    ),
                  )
                : Container(
                    height: 160.h,
                    color: const Color(0xFFF3F4F6),
                    child: const Icon(
                      Icons.directions_boat_outlined,
                      size: 48,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
          ),
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        boat.name,
                        style: getTextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1D1B20),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          size: 14.w,
                          color: const Color(0xFFF59E0B),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          '${boat.averageRating.toStringAsFixed(1)} (${boat.totalRating})',
                          style: getTextStyle(
                            fontSize: 12.sp,
                            color: const Color(0xFF4B5563),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 6.h),
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
                        boat.address,
                        style: getTextStyle(
                          fontSize: 13.sp,
                          color: const Color(0xFF6B7280),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                if (boat.boatRentalDetails != null) ...[
                  SizedBox(height: 6.h),
                  Wrap(
                    spacing: 8.w,
                    children: [
                      _infoChip(
                        Icons.directions_boat,
                        boat.boatRentalDetails!.boatType,
                      ),
                      _infoChip(
                        Icons.people_outline,
                        '${boat.boatRentalDetails!.capacity} pax',
                      ),
                      _infoChip(
                        Icons.straighten,
                        '${boat.boatRentalDetails!.length.toInt()} m',
                      ),
                    ],
                  ),
                ],
                SizedBox(height: 12.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.fromText,
                          style: getTextStyle(
                            fontSize: 11.sp,
                            color: const Color(0xFF6B7280),
                          ),
                        ),
                        Text(
                          '\$${boat.price.toStringAsFixed(0)}',
                          style: getTextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1D1B20),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '${boat.dailyStartTime} – ${boat.dailyEndTime}',
                      style: getTextStyle(
                        fontSize: 12.sp,
                        color: const Color(0xFF6B7280),
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

  Widget _infoChip(IconData icon, String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(20.w),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12.w, color: const Color(0xFF6B7280)),
          SizedBox(width: 4.w),
          Text(
            label,
            style: getTextStyle(
              fontSize: 11.sp,
              color: const Color(0xFF4B5563),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRadioButton(BuildContext context, String title, BoatFilterController controller) {
    return Obx(() {
      bool isSelected = controller.boatType.value == title;
      return GestureDetector(
        onTap: () => controller.updateBoatType(title),
        child: Padding(
          padding: EdgeInsets.only(bottom: 16.h),
          child: Row(
            children: [
              Container(
                width: 22.w,
                height: 22.w,
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF040A18),
                    width: 2.w,
                  ),
                ),
                child: isSelected
                    ? Container(
                        decoration: const BoxDecoration(
                          color: Color(0xFF040A18),
                          shape: BoxShape.circle,
                        ),
                      )
                    : null,
              ),
              SizedBox(width: 12.w),
              Text(
                _getLocalizedBoatType(context, title),
                style: getTextStyle(fontSize: 14.sp, color: Colors.black),
              ),
            ],
          ),
        ),
      );
    });
  }

  String _getLocalizedBoatType(BuildContext context, String boatType) {
    final t = AppLocalizations.of(context)!;
    switch (boatType) {
      case 'Motorboat': return t.motorboatText;
      case 'Catamaran': return t.catamaranText;
      case 'RIB': return t.ribText;
      case 'Jet Ski': return t.jetSkiText;
      case 'Gulet': return t.guletText;
      case 'Houseboat': return t.houseboatText;
      default: return boatType;
    }
  }

  Widget _buildCounterRow(
    String title,
    int value,
    VoidCallback onDecrement,
    VoidCallback onIncrement,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
            style: getTextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        SizedBox(width: 8.w),
        Row(
          children: [
            GestureDetector(
              onTap: onDecrement,
              child: Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Icon(Icons.remove, size: 20.w, color: Colors.black),
              ),
            ),
            SizedBox(width: 16.w),
            SizedBox(
              width: 16.w,
              child: Center(
                child: Text(
                  value.toString(),
                  style: getTextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(width: 16.w),
            GestureDetector(
              onTap: onIncrement,
              child: Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Icon(Icons.add, size: 20.w, color: Colors.black),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class CustomRangeThumbShape extends RangeSliderThumbShape {
  final double thumbRadius;

  CustomRangeThumbShape({this.thumbRadius = 12.0});

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    bool isDiscrete = false,
    bool isEnabled = false,
    bool isOnTop = false,
    bool isPressed = false,
    required SliderThemeData sliderTheme,
    TextDirection? textDirection,
    Thumb thumb = Thumb.start,
  }) {
    final Canvas canvas = context.canvas;

    final Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final Paint shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.1)
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

    canvas.drawCircle(Offset(center.dx, center.dy + 2), thumbRadius, shadowPaint);

    final Paint borderPaint = Paint()
      ..color = const Color(0xFFE5E7EB)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, thumbRadius, paint);
    canvas.drawCircle(center, thumbRadius, borderPaint);

    final TextPainter textPainter = TextPainter(
      textDirection: textDirection ?? TextDirection.ltr,
    );
    textPainter.text = TextSpan(
      text: thumb == Thumb.start ? '<' : '>',
      style: TextStyle(
        fontSize: thumbRadius * 1.2,
        color: const Color(0xFF4B5563),
        fontWeight: FontWeight.w400,
      ),
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        center.dx - textPainter.width / 2,
        center.dy - textPainter.height / 2,
      ),
    );
  }
}
