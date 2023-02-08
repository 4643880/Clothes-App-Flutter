import 'package:get/get.dart';

class OrderNowController extends GetxController{
  // Initial Value
  RxString _deliverySystem = "TCS".obs;
  RxString _paymentSystem = "Apple Pay".obs;


  String get deliverySystem => _deliverySystem.value;
  String get paymentSystem => _paymentSystem.value;


  setDeliverySystem(String newDeliverySys){
    _deliverySystem.value = newDeliverySys;
  }
  setPaymentSystem(String newPaymentSys){
    _paymentSystem.value = newPaymentSys;
  }

}