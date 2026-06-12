import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:point_nemo_service_and_activities/core/custom/more_widgets/custom_text_style.dart';
import 'package:point_nemo_service_and_activities/core/custom/widgets/custom_appbar.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_colors.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_sizer.dart';
import 'package:point_nemo_service_and_activities/features/.common/profile/controllers/common_profile_controller.dart';
import 'package:point_nemo_service_and_activities/features/.common/profile/views/widgets/help_support_chat_dialog.dart';
import 'package:point_nemo_service_and_activities/core/localization/app_localizations.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  final List<Map<String, String>> _faqs = const [
    {
      'question': 'How can I book a boat or activity?',
      'answer':
          'You can book a boat or activity by browsing our listings on the home screen, selecting your preferred date and time, and proceeding to checkout. You will receive a booking confirmation once completed.',
    },
    {
      'question': 'How do I cancel or reschedule my booking?',
      'answer':
          'To cancel or reschedule, go to your Bookings section, select the booking you wish to modify, and choose either Cancel or Reschedule. Please note that cancellations may be subject to our refund policy.',
    },
    {
      'question': 'Can I register my own boat for rent?',
      'answer':
          'Yes! If you are a Business Owner, you can switch to the Business Owner flow, go to "Register Boat", and submit your boat details along with required documents for approval.',
    },
    {
      'question': 'How do I contact my captain?',
      'answer':
          'Once your booking is confirmed, you will be able to message your captain directly through the in-app chat feature accessible from your booking details.',
    },
    {
      'question': 'What payment methods do you accept?',
      'answer':
          'We accept major credit and debit cards, as well as select digital wallets. All transactions are securely processed.',
    },
    {
      'question': 'What happens if the weather is bad on my booking date?',
      'answer':
          'Safety is our priority. If the captain cancels due to unsafe weather conditions, you will be offered a full refund or the option to reschedule your trip.',
    },
    {
      'question': 'Is there a minimum age limit for booking an activity?',
      'answer':
          'The minimum age to create an account and book a boat is 18. However, minors are allowed as passengers provided they are accompanied by an adult.',
    },
    {
      'question': 'Are life jackets provided on all boat trips?',
      'answer':
          'Yes, all registered boats are required to provide coast guard-approved life jackets for every passenger on board.',
    },
    {
      'question': 'Can I bring my own food and drinks on board?',
      'answer':
          'Most captains allow you to bring your own food and drinks, but it is best to check the specific boat\'s rules on the listing page before booking.',
    },
    {
      'question': 'Do I need to pay a deposit when booking?',
      'answer':
          'Some high-value boat rentals may require a security deposit. This will be clearly stated on the checkout page before you complete your booking.',
    },
    {
      'question': 'How do I leave a review for my trip or captain?',
      'answer':
          'After your trip concludes, you will be prompted to leave a rating and written review. You can also do this from your "Past Bookings" tab.',
    },
    {
      'question': 'What should I do if I am running late?',
      'answer':
          'Please contact your captain immediately using the in-app chat. Captains have the discretion to wait, but your trip time may be shortened.',
    },
    {
      'question': 'Is parking available near the docking area?',
      'answer':
          'Parking availability depends on the marina or departure location. Details regarding parking are usually provided in the booking confirmation instructions.',
    },
    {
      'question': 'Can I request a specific captain?',
      'answer':
          'When booking a specific boat, you are booking with the captain associated with that listing. You can browse listings by captain if you have a preference.',
    },
    {
      'question': 'How do I update my profile information?',
      'answer':
          'Go to the Profile tab, select "Edit Profile", and you can update your name, photo, and other personal details.',
    },
    {
      'question': 'Are there any hidden fees or extra charges?',
      'answer':
          'The total price shown at checkout includes the booking fee. However, fuel costs and gratuity may be separate depending on the boat listing\'s terms.',
    },
    {
      'question': 'What happens if the boat breaks down during my trip?',
      'answer':
          'In the rare event of a mechanical failure, captains have protocols for safely returning to shore. You will also be offered a partial or full refund through customer support.',
    },
    {
      'question': 'Can I book a trip for a large group or corporate event?',
      'answer':
          'Yes! You can filter listings by passenger capacity to find boats suitable for large groups or corporate outings.',
    },
    {
      'question': 'Does the app support multiple languages?',
      'answer':
          'Yes, Point Nemo supports multiple languages. You can change your preferred language by going to "Settings" then selecting "Language".',
    },
    {
      'question': 'How can I contact customer support if I have an issue?',
      'answer':
          'You can reach out to our support team 24/7 by tapping the floating chat bubble icon in the bottom right corner of this Help & Support screen.',
    },
    {
      'question': 'Are pets allowed on the boat?',
      'answer':
          'Some captains allow pets on board for an additional fee or specific conditions. Be sure to check the boat\'s listing details or message the captain directly.',
    },
    {
      'question': 'Can I be the driver of the boat if I have a license?',
      'answer':
          'Currently, all our rentals include an experienced, licensed captain to ensure your safety and enjoyment. Therefore, renting a boat without a provided captain is not allowed.',
    },
    {
      'question': 'How do I become a captain on Point Nemo?',
      'answer':
          'If you have the appropriate boating licenses and experience, you can apply using the Captain flow. We will verify your credentials before you can start accepting trips.',
    },
    {
      'question': 'What happens if I damage the boat during my activity?',
      'answer':
          'While you are not driving, any deliberate damage caused by passengers may result in charges to your account. Please review our liability policy for more details.',
    },
    {
      'question': 'Can I extend my trip while on the water?',
      'answer':
          'Extensions are subject to the captain\'s availability and schedule. You can ask your captain during the trip, and they can process an extension fee through the app.',
    },
    {
      'question': 'How long does it take to process a refund?',
      'answer':
          'If your refund request is approved, it usually takes 5-7 business days for the funds to appear in your original payment method depending on your bank.',
    },
    {
      'question': 'Do you offer gift cards or promo codes?',
      'answer':
          'Yes! We occasionally provide promo codes for seasonal discounts, and gift cards can be purchased from your account dashboard.',
    },
    {
      'question': 'Can I change my registered phone number or email?',
      'answer':
          'For security reasons, phone numbers and emails can only be changed by contacting our support team directly. Other profile details can be edited directly in the app.',
    },
    {
      'question': 'What should I wear or bring for my trip?',
      'answer':
          'We recommend bringing sunscreen, a hat, sunglasses, proper footwear (often non-marking soles), and a light jacket. Towels may also be needed for certain activities.',
    },
    {
      'question': 'Is my payment information secure?',
      'answer':
          'Yes, all transactions are processed securely using an encrypted payment gateway. We do not store your full credit card details on our servers.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final CommonProfileController controller =
        Get.find<CommonProfileController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.helpSupport,
        titleSize: 20.sp,
        titleColor: AppColors.textPrimary,
        backgroundColor: Colors.white,
        showBackIcon: true,
        borderRadius: 0,
        enableShadow: false,
      ),
      body: SafeArea(
        child: ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          itemCount: _faqs.length,
          itemBuilder: (context, index) {
            return _FAQTile(
              index: index,
              controller: controller,
              question: _faqs[index]['question']!,
              answer: _faqs[index]['answer']!,
            );
          },
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Get.dialog(const HelpSupportChatDialog());
      //   },
      //   backgroundColor: const Color(0xFF0B1426),
      //   shape: const CircleBorder(),
      //   child: Stack(
      //     alignment: Alignment.center,
      //     children: [
      //       Icon(Icons.chat_bubble, color: Colors.white, size: 32.w),
      //       Padding(
      //         padding: EdgeInsets.only(bottom: 4.w),
      //         child: Text(
      //           '?',
      //           style: getTextStyle(
      //             color: const Color(0xFF0B1426),
      //             fontSize: 18.sp,
      //             fontWeight: FontWeight.bold,
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}

class _FAQTile extends StatelessWidget {
  final int index;
  final CommonProfileController controller;
  final String question;
  final String answer;

  const _FAQTile({
    required this.index,
    required this.controller,
    required this.question,
    required this.answer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(12.w),
      ),
      child: Obx(() {
        final isExpanded = controller.expandedFaqIndices.contains(index);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                controller.toggleFaq(index);
              },
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      question,
                      textAlign: TextAlign.left,
                      style: getTextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  Icon(
                    isExpanded
                        ? Icons.remove_circle_outline
                        : Icons.add_circle_outline,
                    color: AppColors.textPrimary,
                    size: 24.w,
                  ),
                ],
              ),
            ),
            if (isExpanded) ...[
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                child: Divider(
                  color: Colors.grey.shade300,
                  height: 1,
                  thickness: 1,
                ),
              ),
              Text(
                answer,
                textAlign: TextAlign.left,
                maxLines: 10, // allows multiple lines
                style: getTextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ],
        );
      }),
    );
  }
}
