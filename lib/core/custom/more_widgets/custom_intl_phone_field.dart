import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_sizer.dart';
import 'package:point_nemo_service_and_activities/core/custom/more_widgets/custom_text_style.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomIntlPhoneField extends StatelessWidget {
  final TextEditingController? controller;
  final String? initialValue;
  final bool readOnly;
  final bool showCursor;
  final String hintText;
  final Color fillColor;
  final String? counterText;
  final void Function(PhoneNumber)? onChanged;
  final String? initialCountryCode;
  final Widget? suffixIcon;
  final double? borderRadius;
  final String? Function(PhoneNumber?)? validator;

  const CustomIntlPhoneField({
    super.key,
    this.controller,
    this.initialValue,
    this.readOnly = false,
    this.showCursor = true,
    this.hintText = 'Enter your phone number',
    this.fillColor = Colors.white,
    this.counterText,
    this.onChanged,
    this.initialCountryCode,
    this.suffixIcon,
    this.borderRadius,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      initialValue: controller?.text ?? initialValue ?? '',
      validator: (val) {
        final text = controller?.text ?? val ?? '';
        if (text.trim().isEmpty) {
          return 'Phone number is required';
        }
        return null;
      },
      builder: (formFieldState) {
        return Theme(
          data: Theme.of(context).copyWith(
            // Force the font family in this theme scope so the dialog's search field picks it up
            textTheme: Theme.of(context).textTheme.apply(
                  fontFamily: GoogleFonts.outfit().fontFamily,
                ),
          ),
          child: IntlPhoneField(
            controller: controller,
            initialValue: initialValue,
            readOnly: readOnly,
            showCursor: showCursor,
            onChanged: (phone) {
              formFieldState.didChange(phone.number);
              if (onChanged != null) onChanged!(phone);
            },
            validator: validator != null
                ? (phone) => validator!(phone)
                : null,
            initialCountryCode: initialValue != null ? null : (initialCountryCode ?? 'US'),
            dropdownTextStyle: getTextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF1D1B20),
            ),
            pickerDialogStyle: PickerDialogStyle(
              backgroundColor: Colors.white,
              countryCodeStyle: getTextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF1D1B20),
              ),
              countryNameStyle: getTextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF1D1B20),
              ),
              searchFieldInputDecoration: InputDecoration(
                hintText: 'Search country',
                hintStyle: getTextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF9CA3AF),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 16.h,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(28.w),
                  borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(28.w),
                  borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(28.w),
                  borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                ),
              ),
            ),
            style: getTextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF1D1B20),
            ),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: InputDecoration(
              hintText: hintText,
              counterText: counterText,
              errorText: formFieldState.hasError ? formFieldState.errorText : null,
              hintStyle: getTextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF9CA3AF),
              ),
              filled: true,
              fillColor: fillColor,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 16.h,
              ),
              suffixIcon: suffixIcon,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius ?? 28.w),
                borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius ?? 28.w),
                borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius ?? 28.w),
                borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius ?? 28.w),
                borderSide: const BorderSide(color: Color(0xFFEF4444)),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius ?? 28.w),
                borderSide: const BorderSide(color: Color(0xFFEF4444)),
              ),
              errorStyle: getTextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xFFEF4444),
              ),
            ),
          ),
        );
      },
    );
  }
}
