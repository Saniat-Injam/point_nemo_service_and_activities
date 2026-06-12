import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:point_nemo_service_and_activities/core/custom/more_widgets/custom_text_style.dart';
import 'package:point_nemo_service_and_activities/core/custom/more_widgets/custom_loading_indicator.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_sizer.dart';
import 'package:point_nemo_service_and_activities/features/_user_flow/service_bokings/views/screens/service_booking_details_screen.dart';
import 'package:point_nemo_service_and_activities/features/_user_flow/service_bokings/controllers/service_details_controller.dart';
import 'package:point_nemo_service_and_activities/features/_user_flow/service_bokings/models/service_model.dart';
import 'package:point_nemo_service_and_activities/features/_user_flow/service_bokings/views/widgets/service_review_section.dart';
import 'package:point_nemo_service_and_activities/features/.common/nav_bar/controllers/nav_bar_controller.dart';
import 'package:point_nemo_service_and_activities/features/authentication/views/widgets/create_account_dialogue.dart';
import 'package:point_nemo_service_and_activities/core/localization/app_localizations.dart';

class ServiceDetailsScreen extends StatelessWidget {
  const ServiceDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ServiceDetailsController>();
    return Obx(() {
      if (controller.isLoading.value) {
        return const Scaffold(body: CustomLoadingIndicator());
      }
      final service = controller.serviceDetail.value;
      if (service == null) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xFFF9FAFB),
            elevation: 0,
            leading: GestureDetector(
              onTap: () => Get.back(),
              child: const Icon(Icons.arrow_back, color: Color(0xFF1D1B20)),
            ),
          ),
          backgroundColor: const Color(0xFFF9FAFB),
          body: Center(
            child: Text(
              AppLocalizations.of(context)!.serviceNotFound,
              style: getTextStyle(
                fontSize: 16.sp,
                color: const Color(0xFF6B7280),
              ),
            ),
          ),
        );
      }

      return Scaffold(
        backgroundColor: const Color(0xFFF9FAFB),
        appBar: AppBar(
          backgroundColor: const Color(0xFFF9FAFB),
          elevation: 0,
          leading: Padding(
            padding: EdgeInsets.only(left: 20.w),
            child: Center(
              child: GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: const BoxDecoration(
                    color: Color(0xFFEEEEEE),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Color(0xFF1D1B20),
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
          leadingWidth: 60.w,
          title: Text(
            AppLocalizations.of(context)!.serviceDetails,
            style: getTextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1D1B20),
            ),
          ),
          centerTitle: true,
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 20.w),
              child: GestureDetector(
                onTap: () {
                  controller.toggleFavorite();
                },
                child: Icon(
                  service.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: service.isFavorite
                      ? const Color(0xFF040A18)
                      : const Color(0xFF1D1B20),
                  size: 24,
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: _BottomBar(
          price: service.price,
          type: service.type,
          serviceId: service.id,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Cover Image ──────────────────────────────────────────
              ClipRRect(
                borderRadius: BorderRadius.circular(20.w),
                child: service.coverImage.isNotEmpty
                    ? Image.network(
                        service.coverImage,
                        width: double.infinity,
                        height: 220.h,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _CoverPlaceholder(
                          height: 220.h,
                          type: service.type,
                        ),
                        loadingBuilder: (_, child, progress) {
                          if (progress == null) return child;
                          return _CoverShimmer(height: 220.h);
                        },
                      )
                    : _CoverPlaceholder(height: 220.h, type: service.type),
              ),

              // ── Photo gallery strip ───────────────────────────────────
              if (service.photos.isNotEmpty) ...[
                SizedBox(height: 12.h),
                SizedBox(
                  height: 72.h,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: service.photos.length,
                    separatorBuilder: (_, __) => SizedBox(width: 8.w),
                    itemBuilder: (_, i) => ClipRRect(
                      borderRadius: BorderRadius.circular(10.w),
                      child: Image.network(
                        service.photos[i],
                        width: 80.w,
                        height: 72.h,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 80.w,
                          height: 72.h,
                          color: const Color(0xFFE5E7EB),
                          child: const Icon(
                            Icons.broken_image,
                            color: Color(0xFF9CA3AF),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],

              SizedBox(height: 20.h),

              // ── Title + Price ─────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      service.name,
                      style: getTextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1D1B20),
                      ),
                    ),
                  ),
                  Text(
                    '\$${service.price.toStringAsFixed(2)}',
                    style: getTextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),

              // ── Location ──────────────────────────────────────────────
              if (service.address.isNotEmpty)
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      color: const Color(0xFF6B7280),
                      size: 16.w,
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Text(
                        service.address,
                        style: getTextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF6B7280),
                        ),
                      ),
                    ),
                  ],
                ),
              SizedBox(height: 20.h),

              // ── Highlights / Quick Info ────────────────────────────────
              if ((service.dailyStartTime.isNotEmpty &&
                      service.dailyEndTime.isNotEmpty) ||
                  (service.type == 'BOAT_RENTAL' &&
                      service.boatRentalDetails != null)) ...[
                Wrap(
                  spacing: 12.w,
                  runSpacing: 12.h,
                  children: [
                    if (service.dailyStartTime.isNotEmpty &&
                        service.dailyEndTime.isNotEmpty)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 8.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF6FF),
                          borderRadius: BorderRadius.circular(12.w),
                          border: Border.all(color: const Color(0xFFBFDBFE)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.access_time_rounded,
                              color: const Color(0xFF1E3A8A),
                              size: 16.w,
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              '${service.dailyStartTime} – ${service.dailyEndTime}',
                              style: getTextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF1E3A8A),
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (service.type == 'BOAT_RENTAL' &&
                        service.boatRentalDetails != null)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 8.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0FDF4),
                          borderRadius: BorderRadius.circular(12.w),
                          border: Border.all(color: const Color(0xFFBBF7D0)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.people_outline_rounded,
                              color: const Color(0xFF166534),
                              size: 16.w,
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              '${AppLocalizations.of(context)!.capacityText}: ${service.boatRentalDetails!.capacity}',
                              style: getTextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF166534),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 20.h),
              ],

              // ── Owner ─────────────────────────────────────────────────
              if (service.owner != null) ...[
                Row(
                  children: [
                    Container(
                      width: 48.w,
                      height: 48.w,
                      decoration: const BoxDecoration(
                        color: Color(0xFF040A18),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          service.owner!.fullName.isNotEmpty
                              ? service.owner!.fullName[0].toUpperCase()
                              : '?',
                          style: getTextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            service.owner!.fullName,
                            style: getTextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF1D1B20),
                            ),
                          ),
                          Text(
                            AppLocalizations.of(context)!.ownerText,
                            style: getTextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10.w),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.chat_bubble_outline,
                        color: const Color(0xFF1D1B20),
                        size: 20.w,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
              ],

              // ── Description ───────────────────────────────────────────
              Text(
                AppLocalizations.of(context)!.descriptionsText,
                style: getTextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1D1B20),
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                service.description.isNotEmpty
                    ? service.description
                    : AppLocalizations.of(context)!.noDescriptionAvailableText,
                style: getTextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF6B7280),
                  height: 1.5,
                ),
              ),
              SizedBox(height: 24.h),

              // ── Whats Included ────────────────────────────────────────
              Text(
                AppLocalizations.of(context)!.whatsIncluded,
                style: getTextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1D1B20),
                ),
              ),
              SizedBox(height: 16.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _IncludedItem(
                          title: AppLocalizations.of(
                            context,
                          )!.airConditioningText,
                        ),
                        SizedBox(height: 12.h),
                        _IncludedItem(
                          title: AppLocalizations.of(context)!.bathroomText,
                        ),
                        SizedBox(height: 12.h),
                        _IncludedItem(
                          title: AppLocalizations.of(context)!.sunDeckText,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _IncludedItem(
                          title: AppLocalizations.of(context)!.kitchenText,
                        ),
                        SizedBox(height: 12.h),
                        _IncludedItem(
                          title: AppLocalizations.of(context)!.soundSystemText,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),

              // ── Boat Details (only for BOAT_RENTAL) ───────────────────
              if (service.boatRentalDetails != null) ...[
                Text(
                  AppLocalizations.of(context)!.boatDetails,
                  style: getTextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1D1B20),
                  ),
                ),
                SizedBox(height: 12.h),
                _DetailRow(
                  label: AppLocalizations.of(context)!.boatType,
                  value: service.boatRentalDetails!.boatType,
                ),
                SizedBox(height: 8.h),
                _DetailRow(
                  label: AppLocalizations.of(context)!.modelText,
                  value: service.boatRentalDetails!.model,
                ),
                SizedBox(height: 8.h),
                _DetailRow(
                  label: AppLocalizations.of(context)!.capacityText,
                  value: AppLocalizations.of(context)!.personsText(
                    service.boatRentalDetails!.capacity.toString(),
                  ),
                ),
                SizedBox(height: 8.h),
                _DetailRow(
                  label: AppLocalizations.of(context)!.lengthText,
                  value:
                      '${service.boatRentalDetails!.length.toStringAsFixed(0)} ft',
                ),
                SizedBox(height: 24.h),
              ],

              // ── Additional Services ───────────────────────────────────
              if (service.additionalServices.isNotEmpty) ...[
                Text(
                  AppLocalizations.of(context)!.additionalService,
                  style: getTextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1D1B20),
                  ),
                ),
                SizedBox(height: 16.h),
                ...service.additionalServices.asMap().entries.map(
                  (entry) => Padding(
                    padding: EdgeInsets.only(bottom: 12.h),
                    child: _AdditionalServiceRow(
                      addon: entry.value,
                      initialSolid:
                          entry.key >=
                          2, // First two are hollow, rest solid (based on mock)
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
              ],

              // ── Availability ──────────────────────────────────────────
              if (service.availabilities.isNotEmpty) ...[
                Text(
                  AppLocalizations.of(context)!.availableSlots,
                  style: getTextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1D1B20),
                  ),
                ),
                SizedBox(height: 12.h),
                ...service.availabilities.map(
                  (slot) => Padding(
                    padding: EdgeInsets.only(bottom: 10.h),
                    child: _AvailabilitySlot(slot: slot),
                  ),
                ),
                SizedBox(height: 24.h),
              ],

              const ServiceReviewSection(),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      );
    });
  }
}

// ─── Bottom Navigation Bar ────────────────────────────────────────────────────

class _BottomBar extends StatelessWidget {
  final double price;
  final String type;
  final String serviceId;
  const _BottomBar({
    required this.price,
    required this.type,
    required this.serviceId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.perDay,
                  style: getTextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF6B7280),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '\$${price.toStringAsFixed(2)}',
                  style: getTextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1D1B20),
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                final isGuest =
                    Get.isRegistered<NavBarController>() &&
                    Get.find<NavBarController>().isGuest.value;
                if (isGuest) {
                  Get.dialog(const CreateAccountDialog());
                } else {
                  Get.to(
                    () => const ServiceBookingDetailsScreen(),
                    arguments: {
                      'type': type,
                      'serviceId': serviceId,
                      'price': price,
                    },
                  );
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF040A18),
                  borderRadius: BorderRadius.circular(24.w),
                ),
                child: Text(
                  AppLocalizations.of(context)!.bookNow,
                  style: getTextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Availability Slot ────────────────────────────────────────────────────────

class _AvailabilitySlot extends StatelessWidget {
  final ServiceAvailabilityModel slot;
  const _AvailabilitySlot({required this.slot});

  String _formatDateTime(String iso) {
    try {
      final dt = DateTime.parse(iso).toLocal();
      return DateFormat('MMM d, yyyy  •  h:mm a').format(dt);
    } catch (_) {
      return iso;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.w),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: const Color(0xFF040A18).withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(10.w),
            ),
            child: Icon(
              Icons.event_available,
              color: const Color(0xFF040A18),
              size: 20.w,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${AppLocalizations.of(context)!.startText} ${_formatDateTime(slot.startTime)}',
                  style: getTextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF1D1B20),
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  '${AppLocalizations.of(context)!.endText} ${_formatDateTime(slot.endTime)}',
                  style: getTextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Helper Widgets ───────────────────────────────────────────────────────────

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: getTextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF6B7280),
          ),
        ),
        Text(
          value.isNotEmpty ? value : '—',
          style: getTextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1D1B20),
          ),
        ),
      ],
    );
  }
}

class _IncludedItem extends StatelessWidget {
  final String title;
  const _IncludedItem({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.check, color: const Color(0xFF10B981), size: 18.w),
        SizedBox(width: 8.w),
        Text(
          title,
          style: getTextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF6B7280),
          ),
        ),
      ],
    );
  }
}

class _AdditionalServiceRow extends StatelessWidget {
  final ServiceAdditionalModel addon;
  final bool initialSolid;

  const _AdditionalServiceRow({required this.addon, this.initialSolid = false});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ServiceDetailsController>();

    // For visual parity with the mock, if initialSolid was passed,
    // we could use it, but moving to dynamic GetX state is better.
    // If it's not in the set, we'll treat it as unselected.

    return GestureDetector(
      onTap: () {
        controller.toggleAddon(addon.id);
      },
      behavior: HitTestBehavior.opaque,
      child: Obx(() {
        final isSelected =
            controller.selectedAddons.contains(addon.id) || initialSolid;

        return Row(
          children: [
            Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF1D1B20)
                    : Colors.transparent,
                border: isSelected
                    ? null
                    : Border.all(color: const Color(0xFF1D1B20), width: 1.5),
                borderRadius: BorderRadius.circular(4.w),
              ),
              child: Icon(
                Icons.check,
                color: isSelected ? Colors.white : const Color(0xFF1D1B20),
                size: 14.w,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    addon.name,
                    style: getTextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF1D1B20),
                    ),
                  ),
                  if (addon.description.isNotEmpty)
                    Text(
                      addon.description,
                      style: getTextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF9CA3AF),
                      ),
                    ),
                ],
              ),
            ),
            Text(
              '\$${addon.price.toStringAsFixed(2)}',
              style: getTextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF6B7280),
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _CoverPlaceholder extends StatelessWidget {
  final double height;
  final String type;
  const _CoverPlaceholder({required this.height, required this.type});

  IconData get _icon {
    switch (type) {
      case 'BOAT_RENTAL':
        return Icons.directions_boat;
      case 'WATER_SPORTS':
        return Icons.surfing;
      case 'DIVING_COURSE':
        return Icons.scuba_diving;
      case 'FISHING_TRIP':
        return Icons.set_meal;
      default:
        return Icons.water;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0F2849), Color(0xFF1A4B8C)],
        ),
      ),
      child: Icon(_icon, color: Colors.white24, size: 80),
    );
  }
}

class _CoverShimmer extends StatelessWidget {
  final double height;
  const _CoverShimmer({required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      color: const Color(0xFFE5E7EB),
      child: const Center(child: CustomLoadingIndicator()),
    );
  }
}
