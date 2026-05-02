import 'package:flight_app/app/app_link.dart';
import 'package:flight_app/app/controller/flight_booking_controller.dart';
import 'package:flight_app/app/controller/flight_search_controller.dart';
import 'package:flight_app/app/controller/fligth_detail_controller.dart';
import 'package:flight_app/app/controller/passenger_controller.dart';
import 'package:flight_app/app/controller/payment_controller.dart';
import 'package:flight_app/l10n/app_localizations.dart';
import 'package:flight_app/models/booking.dart';
import 'package:flight_app/models/plane.dart';
import 'package:flight_app/models/realModel/flight_detail.dart';
import 'package:flight_app/ui/themes/theme_breakpoints.dart';
import 'package:flight_app/ui/themes/theme_button.dart';
import 'package:flight_app/ui/themes/theme_palette.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/ui/themes/theme_text.dart';
import 'package:flight_app/widgets/booking/passenger_form.dart';
import 'package:flight_app/widgets/booking/plane_info.dart';
// import 'package:flight_app/widgets/booking/baggage_info.dart';
// import 'package:flight_app/widgets/booking/price_info.dart';
// import 'package:flight_app/widgets/booking/tqn_info.dart';
import 'package:flight_app/widgets/stepper/step_progress.dart';
import 'package:flight_app/widgets/flight/info_header.dart';
import 'package:flutter/material.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/route_manager.dart';

class BookingPassengers extends StatefulWidget {
  const BookingPassengers({super.key});

  @override
  State<BookingPassengers> createState() => _BookingPassengersState();
}

class _BookingPassengersState extends State<BookingPassengers> {
  final searchController = Get.find<FlightSearchController>();
  final detailController = Get.find<FlightDetailController>();
  final passengerController = Get.find<PassengerController>();
  final bookingController = Get.find<BookingController>();

  final Vendor flight = Get.arguments as Vendor;
  // bookingController.flight = flight;

  @override
  void initState() {
    super.initState();

    bookingController.flight.value = flight;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchBooking();
    });
  }

  Future<void> fetchBooking() async {
    await bookingController.bookFromVendor(
      vendor: flight,
      nctype: searchController.domestic.value ? 'd' : 'int',
    );
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final paymentController = Get.find<PaymentController>();

    print("uldsen time:${paymentController.remainingSeconds.value}");

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: InfoHeader(
          date: searchController.dateTo.value.isNotEmpty
              ? '${searchController.dateFrom.value} - ${searchController.dateTo.value}'
              : searchController.dateFrom.value,
          from: searchController.fromCode.value,
          to: searchController.toCode.value,
          passengers: searchController.totalPassenger(),
        ),
      ),
      body: Obx(() {
        if (bookingController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final booking = bookingController.bookingResult.value;

        if (booking == null) {
          return Center(child: Text(localization.flightIsNotAvailable));
        }

        return Column(
          children: [
            StepProgress(activeIndex: 0, items: bookingSteps),
            const Divider(),

            /// Plane info
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: ThemeSize.sm),
              child: PlaneInfo(
                info: detailController.flightInfo.value,
                plane: planeList[1],
              ),
            ),

            /// Passenger form
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: ThemeSize.sm),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: spacingUnit(2)),
                    child: PassengerForm(
                      totalPassengers: searchController.totalPassenger(),
                    ),
                  ),
                ),
              ),
            ),

            /// Continue button
            Padding(
              padding: EdgeInsets.only(
                left: spacingUnit(2),
                right: spacingUnit(2),
                top: spacingUnit(1),
                bottom: spacingUnit(4),
              ),
              child: SizedBox(
                height: 50,
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    if (passengerController.passengersSelected.value) {
                      Get.toNamed(AppLink.bookingStep2);
                      passengerController.selectedPassenger.value = null;
                      passengerController.passengersSelected.value = true;
                    } else {
                      passengerController.passengersSelected.value = false;
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        ScaffoldMessenger.of(Get.context!).showSnackBar(
                          SnackBar(
                            content: Text(localization.enterPassengerInfo),
                            duration: Duration(seconds: 2),
                            backgroundColor:
                                colorScheme(context).onPrimaryContainer,
                          ),
                        );
                      });
                    }
                  },
                  style: ThemeButton.btnBig.merge(ThemeButton.primary),
                  child: Text(
                    localization.continueText,
                    style: ThemeText.subtitle2,
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
