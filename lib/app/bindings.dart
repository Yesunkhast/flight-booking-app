import 'package:get/get.dart';
import 'package:flight_app/app/controllers.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(FlightSearchController());
    Get.put(UserController());
    Get.put(LocationController());
  }
}
