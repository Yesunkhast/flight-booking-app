import 'package:flight_app/models/ggModel/plane.dart';
import 'package:flight_app/models/realModel/flight.dart';
import 'package:flight_app/ui/themes/theme_palette.dart';
import 'package:flight_app/ui/themes/theme_radius.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/ui/themes/theme_text.dart';
import 'package:flutter/material.dart';

class PlaneInfo extends StatelessWidget {
  const PlaneInfo({super.key, this.info, required this.plane});

  final FlightInfo? info;
  final Plane plane;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: spacingUnit(2)),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        ClipRRect(
          borderRadius: ThemeRadius.xsmall,
          child: plane.logo.isNotEmpty
              ? Image.network(
                  plane.logo,
                  width: 20,
                )
              : Text("image..."),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(info!.flightSegment.first.airline, style: ThemeText.paragraph),
        const Spacer(),
        Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
              borderRadius: ThemeRadius.xsmall,
              color: colorScheme(context).primaryContainer),
          child: Text(info!.flightSegment.first.flightNum,
              style: ThemeText.paragraph),
        )
      ]),
    );
  }
}
