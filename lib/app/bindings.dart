import 'package:flight_app/app/controller/auth_controller.dart';
import 'package:flight_app/app/controller/flight_booking_controller.dart';
import 'package:flight_app/app/controller/flight_search_controller.dart';
import 'package:flight_app/app/controller/fligth_detail_controller.dart';
import 'package:flight_app/app/controller/location_controller.dart';
import 'package:flight_app/app/controller/passenger_controller.dart';
import 'package:flight_app/app/controller/payment_controller.dart';
import 'package:flight_app/app/controller/user_controller.dart';
import 'package:get/get.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(FlightSearchController());
    Get.put(UserController());
    Get.put(LocationController());
    Get.put(AuthController());
    Get.put(FlightDetailController());
    Get.put(PassengerController());
    Get.put(BookingController());
    Get.put(PaymentController());
  }
}
