import 'package:get/get.dart';

class RejectBookingController extends GetxController {
  final List<String> reasons = [
    'Driver asked me to cancel',
    'Driver taking too long to arrive',
    "Driver's contact number was unreachable",
    'The fare was higher than expected',
    'Rider decided to travel later',
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
