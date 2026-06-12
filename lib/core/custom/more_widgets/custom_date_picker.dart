import 'package:flutter/material.dart';
import 'package:point_nemo_service_and_activities/core/custom/more_widgets/custom_text_style.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_sizer.dart';

Future<DateTime?> showCustomDatePicker({
  required BuildContext context,
  required DateTime initialDate,
  required DateTime firstDate,
  required DateTime lastDate,
}) async {
  return showDatePicker(
    context: context,
    initialDate: initialDate,
    firstDate: firstDate,
    lastDate: lastDate,
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF040A18), // header background color / selected date
            onPrimary: Colors.white, // header text color / selected text
            onSurface: Color(0xFF1D1B20), // body text color
            surface: Colors.white, // background color
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF040A18), // button text color
              textStyle: getTextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          textTheme: TextTheme(
            headlineMedium: getTextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
            titleSmall: getTextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
            bodyLarge: getTextStyle(fontSize: 16.sp, fontWeight: FontWeight.w400),
            bodyMedium: getTextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400),
            bodySmall: getTextStyle(fontSize: 12.sp, fontWeight: FontWeight.w400),
            labelSmall: getTextStyle(fontSize: 10.sp, fontWeight: FontWeight.w500),
          ), dialogTheme: DialogThemeData(backgroundColor: Colors.white),
        ),
        child: child!,
      );
    },
  );
}
