import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:point_nemo_service_and_activities/core/custom/widgets/custom_appbar.dart';
import 'package:point_nemo_service_and_activities/core/custom/more_widgets/custom_text_style.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_sizer.dart';
import 'package:point_nemo_service_and_activities/features/_user_flow/service_bokings/controllers/refund_request_controller.dart';
import 'package:point_nemo_service_and_activities/core/localization/app_localizations.dart';
import 'package:point_nemo_service_and_activities/core/custom/widgets/custom_submit_button.dart';

class RefundRequestScreen extends StatelessWidget {
  const RefundRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RefundRequestController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.refundRequest,
        backgroundColor: Colors.white,
        titleColor: Color(0xFF0F172A),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.selectReasonForRefund,
                style: getTextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF374151),
                ),
              ),
              SizedBox(height: 16.h),
              const Divider(color: Color(0xFFE5E7EB), height: 1),
              SizedBox(height: 16.h),

              ...controller.availableReasons.map((reason) {
                return Obx(() {
                  final isSelected = controller.selectedReasons.contains(
                    reason,
                  );
                  return GestureDetector(
                    onTap: () => controller.toggleReason(reason),
                    behavior: HitTestBehavior.opaque,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 20.h),
                      child: Row(
                        children: [
                          Container(
                            width: 22.w,
                            height: 22.w,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFF0F172A)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(4.w),
                              border: isSelected
                                  ? null
                                  : Border.all(
                                      color: const Color(0xFF0F172A),
                                      width: 1.5.w,
                                    ),
                            ),
                            child: isSelected
                                ? Icon(
                                    Icons.check,
                                    size: 16.w,
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Text(
                              reason,
                              style: getTextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w500,
                                color: const Color(
                                  0xFF000000,
                                ), // Very black text as per design
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                });
              }),

              SizedBox(height: 12.h),
              Text(
                AppLocalizations.of(context)!.otherReasons,
                style: getTextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF000000),
                ),
              ),
              SizedBox(height: 12.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(12.w),
                ),
                child: TextField(
                  controller: controller.otherReasonController,
                  maxLines: 5,
                  style: getTextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF111827),
                    height: 1.5,
                  ),
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.addReasonHere,
                    hintStyle: getTextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF6B7280),
                    ),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 32.h),
        decoration: const BoxDecoration(color: Colors.white),
        child: CustomSubmitButton(
          text: AppLocalizations.of(context)!.submitText,
          color: const Color(0xFF0F172A),
          textColor: Colors.white,
          borderRadius: BorderRadius.circular(32.w),
          padding: EdgeInsets.symmetric(vertical: 16.h),
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          onTap: controller.submitRefundRequest,
        ),
      ),
    );
  }
}
