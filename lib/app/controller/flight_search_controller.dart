import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class FlightSearchController extends GetxController {
  RxString from = ''.obs;
  RxString to = ''.obs;
  RxString departureDate = ''.obs;
  RxString returnDate = ''.obs;

  RxInt adults = 0.obs;
  RxInt children = 0.obs;
  RxInt infants = 0.obs;

  RxString classType = 'Economy'.obs;

  void setFrom(String city) {
    from.value = city;
  }

  void setTo(String city) {
    to.value = city;
  }

  void setAdults(int count) {
    adults.value = count;
  }

  void setChildren(int count) {
    children.value = count;
  }

  void setInfants(int count) {
    infants.value = count;
  }

  void setClassType(String type) {
    classType.value = type;
  }
}
