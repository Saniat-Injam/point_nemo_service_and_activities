import 'package:get/get.dart';

class PaymentMethodsController extends GetxController {
  final selectedPaymentMethod = 'Credit card'.obs;

  void selectPaymentMethod(String method) {
    selectedPaymentMethod.value = method;
  }
}


