import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:point_nemo_service_and_activities/features/_user_flow/service_bokings/models/user_booking_model.dart';

class BookingReviewController extends GetxController {
  late final UserBookingModel booking;

  final rating = 4.obs;
  final reviewController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    // Pre-populate with dummy data as shown in the image to make it look identical
    reviewController.text =
        "Our group had the best time! The guides helped everyone, even beginners, and made the trip safe and enjoyable. 😍😍";

    // Safety check for arguments
    if (Get.arguments is UserBookingModel) {
      booking = Get.arguments as UserBookingModel;
    } else {
      // Fallback placeholder if navigated without arguments
      booking = UserBookingModel.fromJson({
        'id': '',
        'userId': '',
        'serviceId': '',
        'startDate': '',
        'endDate': '',
        'startTime': '',
        'endTime': '',
        'numberOfDays': 1,
        'capacityRequest': 1,
        'totalAmount': 0,
        'status': 'COMPLETED',
        'createdAt': '',
        'service': {
          'id': '',
          'type': '',
          'name': 'Service',
          'description': '',
          'address': '',
          'price': 0,
          'coverImage': '',
          'averageRating': 0,
          'totalRating': 0,
          'owner': {'id': '', 'fullName': '', 'email': ''},
        },
      });
    }
  }

  void updateRating(int newRating) {
    rating.value = newRating;
  }

  void submitReview() {
    // In a real app, send review to backend here
    Get.back();
  }

  @override
  void onClose() {
    reviewController.dispose();
    super.onClose();
  }
}
