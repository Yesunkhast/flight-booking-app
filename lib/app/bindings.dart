import 'package:flight_app/app/controller/auth_controller.dart';
import 'package:flight_app/app/controller/flight_search_controller.dart';
import 'package:flight_app/app/controller/location_controller.dart';
import 'package:flight_app/app/controller/user_controller.dart';
import 'package:get/get.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(FlightSearchController());
    Get.put(UserController());
    Get.put(LocationController());
    Get.put(AuthController());
  }
}
