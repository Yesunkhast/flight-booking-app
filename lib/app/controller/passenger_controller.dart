import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class PassengerController extends GetxController {
  RxString name = ''.obs;
  RxString parentName = ''.obs;
  RxString passportNumber = ''.obs;
  RxString date = ''.obs;
  RxString passwordExpireDate = ''.obs;
  RxString sex = ''.obs;
}
