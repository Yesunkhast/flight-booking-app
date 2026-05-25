import 'package:flight_app/l10n/app_localizations.dart';
import 'package:flight_app/models/ggModel/booking.dart';
import 'package:flight_app/models/ggModel/list_item.dart';
import 'package:flight_app/models/realModel/order.dart';
import 'package:flight_app/ui/themes/theme_palette.dart';
import 'package:flight_app/ui/themes/theme_radius.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/ui/themes/theme_text.dart';
import 'package:flight_app/utils/grabber_icon.dart';
import 'package:flutter/material.dart';

// final List<ListItem> selectedPackageList = [
//   ListItem(
//       value: '20',
//       label: 'Beverages',
//       icon: Icons.coffee,
//       text: 'Beverages depending on airline and class'),
//   ListItem(
//       value: '10',
//       label: 'Snack Services',
//       icon: Icons.card_giftcard,
//       text: 'Light snacks and refreshments'),
//   ListItem(
//       value: '25',
//       label: 'Extra Baggage',
//       icon: Icons.home_repair_service,
//       text: 'Additional luggage for an extra fee'),
// ];

class PassengerDetail extends StatelessWidget {
  const PassengerDetail({super.key, required this.passenger});
  final OrderPassenger passenger;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return Padding(
      padding: EdgeInsets.all(spacingUnit(2)),
      child: Wrap(children: [
        Column(children: [
          const GrabberIcon(),
          const VSpaceShort(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.person, size: 22),
              SizedBox(
                width: 8,
              ),
              Text(localization.passengerDetail, style: ThemeText.subtitle)
            ],
          ),
          const VSpace(),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(localization.name,
                style: ThemeText.paragraph
                    .copyWith(color: colorScheme(context).onSurfaceVariant)),
            Text(passenger.name, style: ThemeText.paragraphBold),
          ]),
          SizedBox(height: spacingUnit(1)),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(localization.passportID,
                style: ThemeText.paragraph
                    .copyWith(color: colorScheme(context).onSurfaceVariant)),
            Text(passenger.passport, style: ThemeText.paragraphBold),
          ]),
          const VSpace(),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Column(children: [
              Text(localization.baggage,
                  style: ThemeText.caption
                      .copyWith(color: colorScheme(context).onSurfaceVariant)),
              Text(
                '20 kg',
                style: ThemeText.subtitle2,
              )
            ]),
            // Column(children: [
            //   Text('SEAT',
            //       style: ThemeText.caption
            //           .copyWith(color: colorScheme(context).onSurfaceVariant)),
            //   Text(
            //     '${passengerList[0].seat}',
            //     style: ThemeText.subtitle2,
            //   )
            // ]),
            // Column(children: [
            //   Text(localization.type,
            //       style: ThemeText.caption
            //           .copyWith(color: colorScheme(context).onSurfaceVariant)),
            //   Text(
            //     passengerList[0].type!.toUpperCase(),
            //     style: ThemeText.subtitle2,
            //   )
            // ]),
          ]),
          // const VSpace(),
          // Container(
          //   padding: EdgeInsets.symmetric(
          //       vertical: spacingUnit(1), horizontal: spacingUnit(2)),
          //   decoration: BoxDecoration(
          //       color: colorScheme(context).surfaceDim,
          //       borderRadius: ThemeRadius.medium),
          //   child: ListView.builder(
          //     padding: const EdgeInsets.all(0),
          //     shrinkWrap: true,
          //     itemCount: selectedPackageList.length,
          //     itemBuilder: (context, index) {
          //       final item = selectedPackageList[index];
          //       return ListTile(
          //         leading: Icon(item.icon,
          //             size: 16,
          //             color: colorScheme(context).onSecondaryContainer),
          //         title: Text(item.label, style: ThemeText.paragraph),
          //         trailing: Text('\$${item.value}',
          //             style: ThemeText.paragraph
          //                 .copyWith(color: colorScheme(context).onSurface)),
          //         contentPadding: const EdgeInsets.all(0),
          //         minTileHeight: 0,
          //       );
          //     },
          //   ),
          // ),
          // const VSpace(),
        ])
      ]),
    );
  }
}
