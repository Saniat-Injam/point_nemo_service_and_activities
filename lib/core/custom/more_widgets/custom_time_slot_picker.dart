import 'package:flutter/material.dart';
import 'package:point_nemo_service_and_activities/core/custom/more_widgets/custom_text_style.dart';
import 'package:point_nemo_service_and_activities/core/custom/widgets/custom_textformfield.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_sizer.dart';

class CustomTimeSlotPicker extends StatelessWidget {
  final TextEditingController startTimeController;
  final TextEditingController endTimeController;

  const CustomTimeSlotPicker({
    super.key,
    required this.startTimeController,
    required this.endTimeController,
  });

  Future<void> _selectTime(
    BuildContext context,
    TextEditingController txtController, {
    TimeOfDay? initialTime,
  }) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime ?? const TimeOfDay(hour: 9, minute: 0),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFF1D1B20)),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      final formattedTime =
          '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
      txtController.text = formattedTime;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Start time',
                style: getTextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1D1B20),
                ),
              ),
              SizedBox(height: 8.h),
              CustomTextFormField(
                controller: startTimeController,
                hintText: 'Enter time',
                containerColor: Colors.white,
                containerBorderColor: const Color(0xFFE5E7EB),
                borderRedius: 28.w,
                readonly: true,
                onClick: () => _selectTime(
                  context,
                  startTimeController,
                  initialTime: const TimeOfDay(hour: 9, minute: 0),
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'End time',
                style: getTextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1D1B20),
                ),
              ),
              SizedBox(height: 8.h),
              CustomTextFormField(
                controller: endTimeController,
                hintText: 'Enter time',
                containerColor: Colors.white,
                containerBorderColor: const Color(0xFFE5E7EB),
                borderRedius: 28.w,
                readonly: true,
                onClick: () => _selectTime(
                  context,
                  endTimeController,
                  initialTime: const TimeOfDay(hour: 12, minute: 0),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
