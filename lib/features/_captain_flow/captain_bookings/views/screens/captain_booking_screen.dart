import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:point_nemo_service_and_activities/core/custom/more_widgets/custom_text_style.dart';
import 'package:point_nemo_service_and_activities/core/custom/more_widgets/custom_loading_indicator.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_sizer.dart';
import 'package:point_nemo_service_and_activities/features/_captain_flow/captain_bookings/controllers/booking_controller.dart';
import 'package:point_nemo_service_and_activities/features/_captain_flow/captain_bookings/models/booking_model.dart';
import 'package:point_nemo_service_and_activities/features/_captain_flow/captain_bookings/views/widgets/captain_booking_reject_bottom_sheet.dart';
import 'package:point_nemo_service_and_activities/core/localization/app_localizations.dart';

class CaptainBookingScreen extends StatelessWidget {
  const CaptainBookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BookingController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10.h),
            // Title
            Center(
              child: Text(
                AppLocalizations.of(context)!.bookings,
                style: getTextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF040A18),
                ),
              ),
            ),
            SizedBox(height: 20.h),

            // Filter chips
            _buildFilterChips(context, controller),
            SizedBox(height: 20.h),
            // Section title
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Text(
                AppLocalizations.of(context)!.bookingRequests,
                style: getTextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF040A18),
                ),
              ),
            ),
            SizedBox(height: 12.h),
            // Booking list
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const CustomLoadingIndicator();
                }
                final items = controller.filteredBookings;
                if (items.isEmpty) {
                  return Center(
                    child: Text(
                      AppLocalizations.of(context)!.noBookingsFound,
                      style: getTextStyle(color: const Color(0xFF6B7280)),
                    ),
                  );
                }
                return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return _buildBookingCard(context, items[index]);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  /// Maps internal filter key → display label
  String _filterLabel(BuildContext context, String filter) {
    final l = AppLocalizations.of(context)!;
    switch (filter) {
      case 'Pending':
        return l.pendingText;
      case 'Accepted':
        return l.acceptedText;
      case 'Completed':
        return l.completedText;
      case 'Rejected':
        return l.rejectText;
      default:
        return l.allText;
    }
  }

  /// Maps internal status key → display label
  String _statusLabel(BuildContext context, String status) {
    final l = AppLocalizations.of(context)!;
    switch (status) {
      case 'Pending':
        return l.pendingText;
      case 'Accept':
        return l.acceptText;
      case 'Completed':
        return l.completedText;
      case 'Rejected':
        return l.rejectedBooking;
      default:
        return status.isNotEmpty ? status : l.unknownUser;
    }
  }

  Widget _buildFilterChips(BuildContext context, BookingController controller) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Obx(
        () => Row(
          children: controller.filters.map((filter) {
            final isSelected = controller.selectedFilter.value == filter;
            return GestureDetector(
              onTap: () => controller.changeFilter(filter),
              child: Container(
                margin: EdgeInsets.only(right: 10.w),
                padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF0D1B3E) : Colors.white,
                  borderRadius: BorderRadius.circular(20.w),
                  border: Border.all(
                    color: isSelected
                        ? Colors.transparent
                        : const Color(0xFFD1D5DB),
                    width: 1,
                  ),
                ),
                child: Text(
                  _filterLabel(context, filter),
                  style: getTextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? Colors.white : const Color(0xFF040A18),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildBookingCard(BuildContext context, CaptainBookingModel booking) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(20.w),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        children: [
          // Top row: image + info
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User image (rounded rectangle)
              ClipRRect(
                borderRadius: BorderRadius.circular(14.w),
                child: booking.userImage.isNotEmpty
                    ? Image.network(
                        booking.userImage,
                        width: 80.w,
                        height: 80.w,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _buildAvatarFallback(),
                      )
                    : _buildAvatarFallback(),
              ),
              SizedBox(width: 12.w),
              // Info column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booking.userName.isNotEmpty
                          ? booking.userName
                          : AppLocalizations.of(context)!.unknownUser,
                      style: getTextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF040A18),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      booking.serviceName.isNotEmpty
                          ? booking.serviceName
                          : AppLocalizations.of(context)!.unknownService,
                      style: getTextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                    SizedBox(height: 6.h),
                    // Date & Time row
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 13.w,
                          color: const Color(0xFF9CA3AF),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          booking.date.isNotEmpty ? booking.date : 'N/A',
                          style: getTextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF6B7280),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Icon(
                          Icons.access_time,
                          size: 13.w,
                          color: const Color(0xFF9CA3AF),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          booking.time.isNotEmpty ? booking.time : 'N/A',
                          style: getTextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    // Location row
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 13.w,
                          color: const Color(0xFF9CA3AF),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          booking.location.isNotEmpty
                              ? booking.location
                              : 'N/A',
                          style: getTextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6.h),
                    // Price + Status
                    Row(
                      children: [
                        Text(
                          booking.price.isNotEmpty ? booking.price : 'N/A',
                          style: getTextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF040A18),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        _buildStatusBadge(context, booking.status),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          // Bottom action buttons
          _buildActionButtons(context, booking),
        ],
      ),
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    CaptainBookingModel booking,
  ) {
    switch (booking.status) {
      case 'Pending':
        return Row(
          children: [
            Expanded(
              child: _buildOutlineActionButton(
                icon: Icons.cancel_outlined,
                label: AppLocalizations.of(context)!.rejectText,
                iconColor: const Color(0xFFEF4444),
                textColor: const Color(0xFFEF4444),
                borderColor: const Color(0xFFEF4444),
                onTap: () {
                  Get.bottomSheet(
                    BookingRejectBottomSheet(id: booking.id),
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                  );
                },
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildFilledActionButton(
                onTap: () {
                  final controller = Get.find<BookingController>();
                  controller.acceptOrReBooking(id: booking.id, isAccept: true);
                },
                icon: Icons.check_circle_outline,
                label: AppLocalizations.of(context)!.acceptText,
              ),
            ),
          ],
        );
      case 'Accept':
        return Row(
          children: [
            Expanded(
              child: _buildFilledActionButton(
                icon: Icons.check_circle_outline,
                label: AppLocalizations.of(context)!.completedText,
              ),
            ),
          ],
        );
      case 'Rejected':
        return Column(
          children: [
            const Divider(color: Color(0xFFE5E7EB), height: 1, thickness: 1),
            SizedBox(height: 14.h),
            Center(
              child: Text(
                AppLocalizations.of(context)!.rejectedBooking,
                style: getTextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFEF4444),
                ),
              ),
            ),
            SizedBox(height: 4.h),
          ],
        );
      case 'Completed':
        return Row(
          children: [
            // Star rating
            Expanded(
              child: Row(
                children: [
                  Icon(Icons.star, size: 18.w, color: const Color(0xFFFBBF24)),
                  SizedBox(width: 6.w),
                  Text(
                    'rated  stars',
                    style: getTextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFFFBBF24),
                    ),
                  ),
                ],
              ),
            ),
            _buildFilledActionButton(
              icon: null,
              label: AppLocalizations.of(context)!.viewText,
              width: 100.w,
            ),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildOutlineActionButton({
    required IconData icon,
    required String label,
    required Color iconColor,
    required Color textColor,
    required Color borderColor,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap ?? () {},
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.w),
          border: Border.all(color: borderColor, width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18.w, color: iconColor),
            SizedBox(width: 6.w),
            Text(
              label,
              style: getTextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilledActionButton({
    IconData? icon,
    required String label,
    double? width,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap ?? () {},
      child: Container(
        width: width,
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
          color: const Color(0xFF0D1B3E),
          borderRadius: BorderRadius.circular(24.w),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 18.w, color: Colors.white),
              SizedBox(width: 6.w),
            ],
            Text(
              label,
              style: getTextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context, String status) {
    Color textColor;
    Color bgColor;

    switch (status) {
      case 'Pending':
        textColor = const Color(0xFFA65F00);
        bgColor = const Color(0xFFFFF7E6);
        break;
      case 'Accept':
        textColor = const Color(0xFFA65F00);
        bgColor = const Color(0xFFFFF7E6);
        break;
      case 'Completed':
        textColor = const Color(0xFF22C55E);
        bgColor = const Color(0xFFE6F7ED);
        break;
      case 'Rejected':
        textColor = const Color(0xFFEF4444);
        bgColor = const Color(0xFFFEF2F2);
        break;
      default:
        textColor = Colors.grey;
        bgColor = Colors.grey.shade100;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12.w),
      ),
      child: Text(
        _statusLabel(context, status),
        style: getTextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildAvatarFallback() {
    return Container(
      width: 80.w,
      height: 80.w,
      color: const Color(0xFFE5E7EB),
      child: Icon(Icons.person, size: 40.w, color: const Color(0xFF9CA3AF)),
    );
  }
}
