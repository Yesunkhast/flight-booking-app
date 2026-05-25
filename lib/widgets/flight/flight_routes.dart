// import 'package:flight_app/app/controller/flight_search_controller.dart';
// import 'package:flight_app/app/controller/fligth_detail_controller.dart';
import 'package:flight_app/models/ggModel/flight_route.dart';
import 'package:flight_app/models/realModel/flight.dart';
import 'package:flight_app/ui/themes/theme_palette.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/ui/themes/theme_text.dart';
import 'package:flight_app/widgets/cards/flight_route_card.dart';
import 'package:flutter/material.dart';
// import 'package:get/get_instance/src/extension_instance.dart';
// import 'package:get/utils.dart';
// import 'package:intl/intl.dart';

class FlightRoutes extends StatelessWidget {
  const FlightRoutes(
      {super.key, this.title, this.flightSegment, this.routes, this.rountTrip});

  final List<FlightRoute>? routes;
  final String? title;
  final FlightSegment? flightSegment;
  final bool? rountTrip;

  int get stops => flightSegment?.stopsNum ?? 0;

  @override
  Widget build(BuildContext context) {
    print(flightSegment?.arrDate ?? flightSegment?.dptDate ?? 'No date');
    if (flightSegment == null) return const SizedBox();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: spacingUnit(2)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) Text(title!, style: ThemeText.subtitle2),
          SizedBox(height: spacingUnit(1)),
          Stack(
            alignment: Alignment.centerLeft,
            children: [
              Positioned(
                left: 24,
                child: Container(
                  width: 3,
                  height: 52 * (stops + 2).toDouble(),
                  decoration: BoxDecoration(
                    color: colorScheme(context).outline,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
              ListView.builder(
                itemCount: stops + 2,
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.all(0),
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return FlightRouteCard(
                      location: flightSegment!.dptCityNameEng,
                      name: flightSegment!.dptAirportEng,
                      code: flightSegment!.dpt,
                      time: flightSegment!.dptDate,
                      type: RouteType.depart,
                    );
                  } else if (index == stops + 1) {
                    final date = (flightSegment?.arrDate.isNotEmpty ?? false)
                        ? flightSegment!.arrDate
                        : (flightSegment?.dptDate ?? 'No date');

                    return flightSegment != null
                        ? FlightRouteCard(
                            location: flightSegment!.arrCityNameEng,
                            name: flightSegment!.arrAirportEng,
                            code: flightSegment!.arr,
                            time: date,
                            type: RouteType.arrival,
                          )
                        : SizedBox.shrink();
                  } else {
                    if (flightSegment!.stopInfoList.isEmpty) {
                      return const SizedBox();
                    }
                    final stopIndex = index - 1;
                    if (stopIndex >= flightSegment!.stopInfoList.length) {
                      return const SizedBox();
                    }
                    final stop = flightSegment!.stopInfoList[stopIndex];
                    return FlightRouteCard(
                      location: stop.stopCityNameEng,
                      name: stop.stopAirportNameEng,
                      code: stop.stopAirportCode,
                      time: stop.arrDate,
                      type: RouteType.transit,
                    );
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
