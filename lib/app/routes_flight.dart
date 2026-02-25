import 'package:flight_app/screens/flight/flight_not_found.dart';
import 'package:flight_app/screens/flight/package_not_found.dart';
import 'package:get/route_manager.dart';
import 'package:flight_app/ui/layouts/general_layout.dart';
import 'package:flight_app/screens/flight/flight_detail.dart';
import 'package:flight_app/screens/flight/flight_detail_package.dart';
import 'package:flight_app/screens/flight/flight_list.dart';
import 'package:flight_app/screens/flight/flight_list_roundtrip.dart';
import 'package:flight_app/app/app_link.dart';

const int pageTransitionDuration = 200;

final List<GetPage> routesFlight = [
  GetPage(
    name: AppLink.flightList,
    page: () => const GeneralLayout(content: FlightList()),
  ),
  GetPage(
    name: AppLink.flightListRoundTrip,
    page: () => const GeneralLayout(content: FlightListRoundtrip()),
  ),
  GetPage(
    name: AppLink.flightDetail,
    page: () => const GeneralLayout(content: FlightDetail()),
  ),
  GetPage(
    name: AppLink.flightDetailPackage,
    page: () => const GeneralLayout(content: FlightDetailPackage()),
  ),
  GetPage(
    name: AppLink.flightNotFound,
    page: () => const GeneralLayout(content: FlightNotFound()),
  ),
  GetPage(
    name: AppLink.packageNotFound,
    page: () => const GeneralLayout(content: PackageNotFound()),
  ),
];
