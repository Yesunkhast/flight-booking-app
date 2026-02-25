import 'package:flight_app/models/plane.dart';
import 'package:flight_app/ui/themes/theme_palette.dart';
import 'package:flight_app/ui/themes/theme_radius.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/ui/themes/theme_text.dart';
import 'package:flight_app/widgets/decorations/cut_deco.dart';
import 'package:flutter/material.dart';

class FlightPortraitCard extends StatelessWidget {
  const FlightPortraitCard({
    super.key,
    required this.from,
    required this.to,
    this.label,
    this.roundTrip = false,
    required this.date,
    required this.price,
    this.plane
  });

  final String from;
  final String to;
  final String? label;
  final bool roundTrip;
  final String date;
  final double price;
  final Plane? plane;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// TOP PROPERTIES
        Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: colorScheme(context).primaryContainer, width: 1),
              left: BorderSide(color: colorScheme(context).primaryContainer, width: 1),
              right: BorderSide(color: colorScheme(context).primaryContainer, width: 1),
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(14),
              topRight: Radius.circular(14),
            )
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            /// DESTINATION
            Row(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Padding(
                  padding: EdgeInsets.only(left: spacingUnit(1), right: spacingUnit(1), top: spacingUnit(1)),
                  child: RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text: from,
                        style: ThemeText.paragraph.copyWith(fontWeight: FontWeight.bold, color: colorScheme(context).onSurface)
                      ),
                      TextSpan(
                        text: ' to',
                        style: ThemeText.paragraph.copyWith(color: colorScheme(context).onSurface)
                      ),
                    ])
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: spacingUnit(1)),
                  child: Text(to, textAlign: TextAlign.start, style: ThemeText.subtitle.copyWith(fontWeight: FontWeight.bold)),
                ),
              ]),
              label != null ? Container(
                width: 45,
                height: 45,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: colorScheme(context).secondary,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(60),
                    topRight: Radius.circular(14)
                  )
                ),
                child: Text(label!, textAlign: TextAlign.end, style: ThemeText.caption.copyWith(color: ThemePalette.primaryMain, fontWeight: FontWeight.bold))
              ) : Container()
            ]),
            
            /// DATE AND PRICE
            Padding(
              padding: EdgeInsets.symmetric(horizontal: spacingUnit(1), vertical: 4),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.end, children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  roundTrip ?
                    Text('Round-trip', style: ThemeText.caption.copyWith(color: colorScheme(context).onSurfaceVariant),)
                    : Text('One-way', style: ThemeText.caption.copyWith(color: colorScheme(context).onSurfaceVariant),),
                  Text(date, style: ThemeText.caption.copyWith(color: colorScheme(context).onSurfaceVariant),)
                ]),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Text('Start from', style: ThemeText.caption.copyWith(color: colorScheme(context).onSurfaceVariant)),
                  Text('\$${price.toStringAsFixed(0)}', style: ThemeText.subtitle.copyWith(color: colorScheme(context).primary, fontWeight: FontWeight.bold, height: 1.1))
                ],)
              ]),
            )
          ]),
        ),

        /// CUT DECO
        const CutDeco(),

        /// BOTTOM PROPERTIES
        plane != null ? Container(
          padding: EdgeInsets.all(spacingUnit(1)),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: colorScheme(context).primaryContainer, width: 1),
              left: BorderSide(color: colorScheme(context).primaryContainer, width: 1),
              right: BorderSide(color: colorScheme(context).primaryContainer, width: 1),
            ),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            )
          ),
          child: Row(children: [
            ClipRRect(
              borderRadius: ThemeRadius.xsmall,
              child: Image.network(
                plane!.logo,
                width: 14,
                height: 14,
              ),
            ),
            const SizedBox(width: 2),
            Text('${plane!.name} • Economy', style: ThemeText.caption,),
          ]),
        ) : Container(),
      ],
    );
  }
}