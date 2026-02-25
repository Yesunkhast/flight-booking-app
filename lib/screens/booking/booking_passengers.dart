import 'package:flight_app/app/app_link.dart';
import 'package:flight_app/models/booking.dart';
import 'package:flight_app/models/plane.dart';
import 'package:flight_app/ui/themes/theme_breakpoints.dart';
import 'package:flight_app/ui/themes/theme_button.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/ui/themes/theme_text.dart';
import 'package:flight_app/widgets/booking/passenger_form.dart';
import 'package:flight_app/widgets/booking/plane_info.dart';
import 'package:flight_app/widgets/stepper/step_progress.dart';
import 'package:flight_app/models/city.dart';
import 'package:flight_app/widgets/flight/info_header.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class BookingPassengers extends StatelessWidget {
  const BookingPassengers({super.key});

  static const double price = 400;
  static const double discount = 10;

  @override
  Widget build(BuildContext context) {
    const int passengers = 3;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: InfoHeader(
          date: 'Fri, Oct 20',
          from: cityList[1].code,
          to: cityList[2].code,
          passengers: passengers,
        ),
      ),
      body: Column(children: [
        StepProgress(activeIndex: 0, items: bookingSteps),
        const Divider(),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: ThemeSize.sm),
          child: PlaneInfo(plane: planeList[1])
        ),
        Expanded(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: ThemeSize.sm),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: spacingUnit(2)),
              child: const PassengerForm(totalPassengers: passengers)
            ),
          )
        ),
        Padding(
          padding: EdgeInsets.only(
            left: spacingUnit(2),
            right: spacingUnit(2),
            top: spacingUnit(1),
            bottom: spacingUnit(4)
          ),
          child: Container(
            height: 50,
            width: double.infinity,
            constraints: BoxConstraints(maxWidth: ThemeSize.sm),
            child: FilledButton(
              onPressed: () {
                Get.toNamed(AppLink.bookingStep2);
              },
              style: ThemeButton.btnBig.merge(ThemeButton.primary),
              child: const Text('CONTINUE', style: ThemeText.subtitle2)
            ),
          ),
        )
      ]),
    );
  }
}