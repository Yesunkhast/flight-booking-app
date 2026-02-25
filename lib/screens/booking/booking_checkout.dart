import 'package:flight_app/app/app_link.dart';
import 'package:flight_app/models/booking.dart';
import 'package:flight_app/ui/themes/theme_breakpoints.dart';
import 'package:flight_app/ui/themes/theme_button.dart';
import 'package:flight_app/ui/themes/theme_palette.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/ui/themes/theme_text.dart';
import 'package:flight_app/widgets/booking/review_order.dart';
import 'package:flight_app/widgets/stepper/step_progress.dart';
import 'package:flight_app/models/city.dart';
import 'package:flight_app/widgets/flight/info_header.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class BookingCheckout extends StatelessWidget {
  const BookingCheckout({super.key});

  static const double price = 700;
  static const double discount = 10;

  @override
  Widget build(BuildContext context) {
    const int passengers = 3;
    double finalPrice = price - price * discount / 100;
    bool wideScreen = ThemeBreakpoints.smUp(context);

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
        StepProgress(activeIndex: 2, items: bookingSteps),
        const Divider(),
        Expanded(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: ThemeSize.sm),
            child: const ReviewOrder()
          )
        ),
        Padding(
          padding: EdgeInsets.only(
            left: spacingUnit(2),
            right: spacingUnit(2),
            top: spacingUnit(1),
            bottom: spacingUnit(4)
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: ThemeSize.sm),
            child: Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.start, children: [
              wideScreen ? SizedBox(width: MediaQuery.of(context).size.width * 0.25) : Container(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                  '\$$price',
                    textAlign: TextAlign.end,
                    style: ThemeText.headline.copyWith(color: colorScheme(context).onSurfaceVariant, decoration: TextDecoration.lineThrough, height: 1)
                  ),
                  Text('\$$finalPrice', textAlign: TextAlign.end, style: ThemeText.title.copyWith(color: colorScheme(context).primary, height: 1, fontWeight: FontWeight.bold)),
                ],
              ),
              SizedBox(width: spacingUnit(4)),
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: FilledButton(
                    onPressed: () {
                      Get.toNamed(AppLink.payment);
                    },
                    style: ThemeButton.btnBig.merge(ThemeButton.primary),
                    child: const Text('SECURE PAY', style: ThemeText.subtitle2)
                  ),
                ),
              )
            ]),
          ),
        )
      ]),
    );
  }
}