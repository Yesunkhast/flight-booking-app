import 'package:flight_app/app/app_link.dart';
import 'package:flight_app/models/city.dart';
import 'package:flight_app/models/flight_route.dart';
import 'package:flight_app/constants/img_api.dart';
import 'package:flight_app/models/plane.dart';
import 'package:flight_app/ui/themes/theme_breakpoints.dart';
import 'package:flight_app/ui/themes/theme_button.dart';
import 'package:flight_app/ui/themes/theme_palette.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/ui/themes/theme_text.dart';
import 'package:flight_app/widgets/alert_info/alert_info.dart';
import 'package:flight_app/widgets/app_button/back_icon_button.dart';
import 'package:flight_app/widgets/decorations/oval_shape.dart';
import 'package:flight_app/widgets/flight/facilities_slider.dart';
import 'package:flight_app/widgets/flight/flight_routes.dart';
import 'package:flight_app/widgets/flight/flight_routes_horizontal.dart';
import 'package:flight_app/widgets/flight/flight_summary.dart';
import 'package:flight_app/widgets/flight/flight_summary_wide.dart';
import 'package:flight_app/widgets/flight/package_options.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class FlightDetailPackage extends StatefulWidget {
  const FlightDetailPackage({super.key});

  @override
  State<FlightDetailPackage> createState() => _FlightDetailPackageState();
}

class _FlightDetailPackageState extends State<FlightDetailPackage> {
  static const double price = 1000;
  static const double discount = 5;
  double _finalPrice = price - price * discount / 100;

  void updatePrice(String type, double val) {
    setState(() {
      if (type == 'add') {
        _finalPrice += val;
      } else {
        _finalPrice -= val;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool wideScreen = ThemeBreakpoints.smUp(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        shadowColor: colorScheme(context).surface,
        scrolledUnderElevation: 1,
        backgroundColor: Colors.transparent,
        leading: BackIconButton(
          onTap: () {
            Get.back();
          }
        ),
        actions: [
          SizedBox(
            width: 32,
            height: 32,
            child: IconButton(
              onPressed: () {
                Get.toNamed(AppLink.faq);
              },
              style: ThemeButton.iconBtn(context),
              icon: Icon(Icons.help_outline_rounded, color: colorScheme(context).onSurface, size: 18)
            ),
          ),
          SizedBox(width: spacingUnit(2),)
        ],
      ),
      body: SingleChildScrollView(
        child: Stack(alignment: Alignment.topCenter, children: [
          /// DECORATION BG
          Container(
            alignment: Alignment.bottomCenter,
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(ImgApi.photo[53]),
                fit: BoxFit.cover,
              ),
            ),
          ),

          /// DECORATION ROUNDED
          Positioned(
            top: 120,
            left: -10,
            child: CustomPaint(
              painter: OvalShape(color: colorScheme(context).surfaceContainerLowest, width: MediaQuery.of(context).size.width + 20),
            ),
          ),

          /// CONTENTS
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(height: 50 + MediaQuery.of(context).padding.top),
            wideScreen ? FlightSummaryWide(
              from: cityList[0],
              to: cityList[6],
              price: price,
              discount: discount,
              label: 'Discount $discount%',
              plane: planeList[0],
            ) : FlightSummary(
              from: cityList[0],
              to: cityList[6],
              price: price,
              discount: discount,
              label: 'Discount $discount%',
              plane: planeList[0],
            ),
            wideScreen ?
              FlightRoutesHorizontal(title: 'Departure', routes: returnRoute)
              : FlightRoutes(title: 'Departure', routes: returnRoute),
            wideScreen ?
              FlightRoutesHorizontal(title: 'Departure', routes: departRoute)
              : FlightRoutes(title: 'Departure', routes: departRoute),
            const VSpaceBig(),
            const FacilitiesSlider(),
            const VSpaceBig(),
            PackageOptions(
              getVal: (type, val) {
                updatePrice(type, val);
              },
            ),
            const VSpace(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: spacingUnit(2)),
              child: const AlertInfo(type: AlertType.warning, text: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis congue euismod elit'),
            ),
            const VSpace(),
          ])
        ]),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 20,
        shadowColor: Colors.black,
        height: 80,
        color: colorScheme(context).surface,
        padding: EdgeInsets.symmetric(horizontal: spacingUnit(2), vertical: spacingUnit(1)),
        child: Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.start, children: [
          wideScreen ? SizedBox(width: MediaQuery.of(context).size.width * 0.5) : Container(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
              '\$$price',
                textAlign: TextAlign.end,
                style: ThemeText.headline.copyWith(color: colorScheme(context).onSurfaceVariant, decoration: TextDecoration.lineThrough, height: 1)
              ),
              Text('\$$_finalPrice', textAlign: TextAlign.end, style: ThemeText.title.copyWith(color: colorScheme(context).primary, height: 1, fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(width: spacingUnit(3)),
          Expanded(
            child: SizedBox(
              height: 50,
              child: FilledButton(
                onPressed: () {
                  Get.toNamed(AppLink.bookingStep1);
                },
                style: ThemeButton.btnBig.merge(ThemeButton.primary),
                child: const Text('BOOK NOW', style: ThemeText.subtitle2)
              ),
            ),
          )
        ]),
      ),
    );
  }
}