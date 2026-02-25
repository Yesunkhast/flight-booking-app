import 'package:flight_app/models/airport.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/widgets/cards/airport_card.dart';
import 'package:flight_app/widgets/title/title_basic.dart';
import 'package:flutter/material.dart';

class AirportListSlider extends StatelessWidget {
  const AirportListSlider({super.key});

  @override
  Widget build(BuildContext context) {
    const double cardHeight = 120;
    final List<Airport> airports = [
      airportList[0],
      airportList[1],
      airportList[2],
      airportList[3],
      airportList[4],
      airportList[5],
      airportList[6],
      airportList[7],
      airportList[8],
      airportList[9],
    ];
  
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: EdgeInsets.symmetric(horizontal: spacingUnit(2)),
        child: const TitleBasic(
          title: 'Top 10 Airports',
          desc: 'Voted by customers from across the world',
        ),
      ),
      const VSpaceShort(),
      SizedBox(
        height: cardHeight,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: airports.length,
          itemBuilder: ((context, index) {
            Airport item = airports[index];
            return Padding(
              padding: EdgeInsets.only(left: index == 0 ? 4 : 0),
              child: Column(children: [
                SizedBox(width: 280, height: cardHeight,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: AirportCard(
                      thumb: item.photo,
                      name: item.name,
                      code: item.code,
                      location: item.location
                    ),
                  )
                ),
              ]),
            );
          }),
        ),
      )
    ]);
  }
}