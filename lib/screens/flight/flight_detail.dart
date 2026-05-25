import 'package:flight_app/app/app_link.dart';
import 'package:flight_app/app/controller/flight_search_controller.dart';
import 'package:flight_app/app/controller/fligth_detail_controller.dart';
import 'package:flight_app/app/controller/user_controller.dart';
import 'package:flight_app/l10n/app_localizations.dart';
import 'package:flight_app/models/ggModel/flight_route.dart';
import 'package:flight_app/models/ggModel/plane.dart';
import 'package:flight_app/screens/flight/flights.dart';
import 'package:flight_app/ui/themes/theme_breakpoints.dart';
import 'package:flight_app/ui/themes/theme_palette.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/ui/themes/theme_text.dart';
import 'package:flight_app/widgets/alert_info/alert_info.dart';
import 'package:flight_app/widgets/app_button/back_icon_button.dart';
import 'package:flight_app/widgets/decorations/oval_shape.dart';
import 'package:flight_app/widgets/flight/flight_routes.dart';
import 'package:flight_app/widgets/flight/flight_routes_horizontal.dart';
import 'package:flight_app/widgets/flight/flight_summary.dart';
import 'package:flutter/material.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/route_manager.dart';

// import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
// import 'package:flight_app/widgets/flight/flight_summary_wide.dart';
// import 'package:flight_app/widgets/flight/package_options.dart';
// get model from flight_list.dart
// import 'package:flight_app/models/city.dart';
// import 'package:flight_app/models/realModel/flight_detail.dart';
// import 'package:flight_app/ui/themes/theme_button.dart';
// import 'package:flight_app/widgets/flight/facilities_slider.dart';
// import 'package:flight_app/screens/flight/package_not_found.dart';

class FlightDetail extends StatefulWidget {
  const FlightDetail({super.key});

  @override
  State<FlightDetail> createState() => _FlightDetailState();
}

class _FlightDetailState extends State<FlightDetail> {
  final detailController = Get.find<FlightDetailController>();
  final searchController = Get.find<FlightSearchController>();
  double? get flightPrice => detailController.ext?.price.toDouble();
  String? get ifHas2Segment => detailController.ext?.flightType;
  bool get isRoundTrip => searchController.roundTrip.value;
  final userController = Get.find<UserController>();

  @override
  void initState() {
    super.initState();
    getUser();
  }

  Future<void> getUser() async {
    await userController.getUserFromDb();
  }

  List<FlightDetail> allData = [];

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    bool wideScreen = ThemeBreakpoints.smUp(context);
    print(" user is available:${userController.userIsAvailable}");

    return Scaffold(
        appBar: AppBar(
          backgroundColor: colorScheme(context).primaryContainer,
          leading: BackIconButton(onTap: () {
            Get.back();
          }),
          title: Text(localization.flightDetail, style: ThemeText.subtitle),
          actions: [
            IconButton(
                onPressed: () {
                  Get.toNamed(AppLink.faq);
                },
                icon: Icon(Icons.help_outline_rounded,
                    color: colorScheme(context).onSurface))
          ],
        ),
        body: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Stack(alignment: Alignment.topCenter, children: [
            /// DECORATION BG
            Container(
              alignment: Alignment.bottomCenter,
              width: double.infinity,
              height: 100,
              color: colorScheme(context).primaryContainer,
            ),

            /// DECORATION ROUNDED
            Positioned(
              top: 80,
              left: -10,
              child: CustomPaint(
                painter: OvalShape(
                    color: colorScheme(context).surfaceContainerLowest,
                    width: MediaQuery.of(context).size.width + 20),
              ),
            ),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // wideScreen
              //     ?
              //     FlightSummaryWide(
              //         from: controller.firstSeg!.dptCity,
              //         to: controller.firstSeg!.arrCity,
              //         price: price,
              //         plane: planeList[0],
              //       )
              //     :
              FlightSummary(
                plane: planeList[0],
              ),

              ifHas2Segment == null
                  ? Padding(
                      padding: EdgeInsets.symmetric(horizontal: spacingUnit(2)),
                      child: AlertInfo(
                        type: AlertType.warning,
                        text: localization.flightWarning,
                      ))
                  : Container(),
              wideScreen
                  ? FlightRoutesHorizontal(
                      title: localization.departure, routes: departRoute)
                  : Column(
                      children: [
                        FlightRoutes(
                          flightSegment: detailController.firstSeg,
                          title: localization.departure,
                        ),
                        if (isRoundTrip)
                          FlightRoutes(
                            flightSegment: detailController.lastSeg,
                            title: localization.returnword,
                          ),
                      ],
                    ),
              const VSpace(),
              Flights(),
              // const FacilitiesSlider(),
              // const VSpace(),
              // PackageOptions(
              //   getVal: (type, val) {
              //     updatePrice(type, val);
              //   },
              // ),
              // const VSpace(),
              // Padding(
              //   padding: EdgeInsets.symmetric(horizontal: spacingUnit(2)),
              //   child: const AlertInfo(
              //       type: AlertType.warning,
              //       text:
              //           'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis congue euismod elit'),
              // ),
              // const VSpace(),
            ]),
          ]),
        )

        // end bga tovchiig scroolloor garj=ch ireh nisleg bolgond torhiruulah
        // bottomNavigationBar: BottomAppBar(
        //   elevation: 20,
        //   shadowColor: Colors.black,
        //   height: 80,
        //   color: colorScheme(context).surface,
        //   padding: EdgeInsets.symmetric(
        //       horizontal: spacingUnit(2), vertical: spacingUnit(1)),
        //   child: Row(
        //       crossAxisAlignment: CrossAxisAlignment.center,
        //       mainAxisAlignment: MainAxisAlignment.start,
        //       children: [
        //         wideScreen
        //             ? SizedBox(width: MediaQuery.of(context).size.width * 0.5)
        //             : Container(),
        //         Column(
        //           crossAxisAlignment: CrossAxisAlignment.end,
        //           mainAxisAlignment: MainAxisAlignment.center,
        //           children: [
        //             Text(
        //               "${_finalPrice.toStringAsFixed(0)}¥",
        //               style: ThemeText.title.copyWith(
        //                 color: colorScheme(context).primary,
        //                 fontWeight: FontWeight.bold,
        //               ),
        //             )

        //             // Text(flightPrice.toStringAsFixed(0) + "¥",
        //             //     textAlign: TextAlign.end,
        //             //     style: ThemeText.title.copyWith(
        //             //         color: colorScheme(context).primary,
        //             //         height: 1,
        //             //         fontWeight: FontWeight.bold)),
        //           ],
        //         ),
        //         SizedBox(width: spacingUnit(3)),
        //         Expanded(
        //           child: SizedBox(
        //             height: 50,
        //             child: FilledButton(
        //                 onPressed: () {
        //                   Get.toNamed(AppLink.bookingStep1);
        //                 },
        //                 style: ThemeButton.btnBig.merge(ThemeButton.primary),
        //                 child:
        //                     const Text('CHOOSE NOW', style: ThemeText.subtitle2)),
        //           ),
        //         )
        //       ]),
        // ),
        );
  }
}
