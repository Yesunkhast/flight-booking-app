import 'package:flight_app/app/app_link.dart';
import 'package:flight_app/models/trip.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/widgets/app_button/tag_button.dart';
import 'package:flight_app/widgets/cards/flight_portrait_card.dart';
import 'package:flight_app/widgets/title/title_action.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class FlightListDouble extends StatefulWidget {
  const FlightListDouble({super.key});

  @override
  State<FlightListDouble> createState() => _FlightListDoubleState();
}

class _FlightListDoubleState extends State<FlightListDouble> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    const double cardWidth = 220;
    const double cardHeight = 300;
    final topFlightListDouble = tripList.sublist(0, 12);
    final List<String> tags = ['South East Asia', 'Middle East', 'Europe', 'America', 'Africa'];

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: EdgeInsets.symmetric(horizontal: spacingUnit(2)),
        child: TitleAction(
          title: 'Top Destinations',
          textAction: 'Find More',
          onTap: () {
            Get.toNamed(AppLink.flightList);
          }
        ),
      ),
      SizedBox(height: spacingUnit(2)),
      
      /// TAGS
      SizedBox(
        height: 25,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: tags.length,
          physics: const ClampingScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(left: index == 0 ? spacingUnit(1) : 0, right: spacingUnit(1)),
              child: TagButton(text: tags[index], size: BtnSize.small, selected: index == _selected, onPressed: () {
                setState(() {
                  _selected = index;
                });
              },)
            );
          },
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
          itemCount: topFlightListDouble.length ~/ 2,
          itemBuilder: ((context, index) {
            Trip itemTop = topFlightListDouble[index];
            Trip itemBottom = topFlightListDouble[index + 1];
        
            return Column(
              children: [
                SizedBox(
                  width: cardWidth,
                  child: Padding(
                    padding: EdgeInsets.only(right: spacingUnit(1), left: index == 0 ? spacingUnit(1) : 0),
                    child: GestureDetector(
                      onTap: () {
                        Get.toNamed(AppLink.flightDetail);
                      },
                      child: FlightPortraitCard(
                        from: itemTop.from.name,
                        to: itemTop.to.name,
                        label: itemTop.label,
                        date: DateFormat('dd MMM yyyy').format(itemTop.arrival),
                        price: itemTop.price,
                        plane: itemTop.plane
                      ),
                    ),
                  )
                ),
                SizedBox(height: spacingUnit(1)),
                SizedBox(
                  width: cardWidth,
                  child: Padding(
                    padding: EdgeInsets.only(right: spacingUnit(1), left: index == 0 ? spacingUnit(1) : 0),
                    child: GestureDetector(
                      onTap: () {
                        Get.toNamed(AppLink.flightDetail);
                      },
                      child: FlightPortraitCard(
                        from: itemBottom.from.name,
                        to: itemBottom.to.name,
                        label: itemBottom.label,
                        date: DateFormat('dd MMM yyyy').format(itemBottom.arrival),
                        price: itemBottom.price,
                        plane: itemBottom.plane
                      ),
                    ),
                  )
                ),
              ],
            );
          })
        ),
      )
    ]);
  }
}