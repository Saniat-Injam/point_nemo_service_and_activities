import 'package:get/get.dart';

class BusinessOwnerRejectBookingController extends GetxController {
  final List<String> reasons = [
    'User asked me to cancel',
    'Taking too long to prepare service',
    "User's contact number was unreachable",
    'Service unavailable at the moment',
    'User decided to travel later',
  ];

  final selectedReasons = <String>{}.obs;

  void toggleReason(String reason) {
    if (selectedReasons.contains(reason)) {
      selectedReasons.remove(reason);
    } else {
      selectedReasons.add(reason);
    }
  }
}
