import 'package:flight_app/app/app_link.dart';
import 'package:flight_app/models/trip.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/widgets/cards/flight_portrait_card.dart';
import 'package:flight_app/widgets/title/title_action.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class FlightListSlider extends StatefulWidget {
  const FlightListSlider({super.key});

  @override
  State<FlightListSlider> createState() => _FlightListSliderState();
}

class _FlightListSliderState extends State<FlightListSlider> {

  @override
  Widget build(BuildContext context) {
    const double cardWidth = 220;
    const double cardHeight = 160;
    final topFlightList = tripList.sublist(0, 12);

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: EdgeInsets.symmetric(horizontal: spacingUnit(2)),
        child: TitleAction(
          title: 'Top Destinations',
          textAction: 'Find More',
          onTap: () {
            Get.toNamed('/flight-list');
          }
        ),
      ),
      SizedBox(height: spacingUnit(2)),
      
      /// FLIGHT ITEMS
      SizedBox(
        height: cardHeight,
        child: ListView.builder(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: 10,
          itemBuilder: ((context, index) {
            Trip item = topFlightList[index];
        
            return SizedBox(
              width: cardWidth,
              child: Padding(
                padding: EdgeInsets.only(right: spacingUnit(1), left: index == 0 ? spacingUnit(1) : 0),
                child: GestureDetector(
                  onTap: () {
                    Get.toNamed(AppLink.flightDetail);
                  },
                  child: FlightPortraitCard(
                    from: item.from.name,
                    to: item.to.name,
                    label: item.label,
                    date: DateFormat('dd MMM yyyy').format(item.arrival),
                    price: item.price,
                    plane: item.plane
                  ),
                ),
              )
            );
          })
        ),
      )
    ]);
  }
}