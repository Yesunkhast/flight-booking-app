import 'package:flight_app/app/controller/passenger_controller.dart';
import 'package:flight_app/app/controller/payment_controller.dart';
import 'package:flight_app/l10n/app_localizations.dart';
import 'package:flight_app/models/ggModel/booking.dart';
import 'package:flight_app/models/ggModel/city.dart';
import 'package:flight_app/models/ggModel/plane.dart';
import 'package:flight_app/models/ggModel/user.dart';
import 'package:flight_app/widgets/decorations/cut_deco.dart';
import 'package:flight_app/widgets/decorations/dashed_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flight_app/ui/themes/theme_palette.dart';
import 'package:flight_app/ui/themes/theme_radius.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';

import 'package:flight_app/ui/themes/theme_text.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ETicketCard extends StatelessWidget {
  const ETicketCard({
    super.key,
    required this.date,
  });

  final String date;

  final double _radius = 30;
  final double _maxWidth = 400;
  final double _height = 640;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final paymentController = Get.find<PaymentController>();
    final passengerController = Get.find<PassengerController>();
    final Plane plane = planeList[0];
    // final City from = cityList[0];
    // final City to = cityList[1];
    print(
        paymentController.orderResponse.value?.result.flightInfo.first.dptDate);

    DateTime depart = DateTime.parse(
        '${paymentController.orderResponse.value?.result.flightInfo.first.dptDate} ${paymentController.orderResponse.value?.result.flightInfo.first.dptTime}:00');
    DateTime arrival = DateTime.parse(
        '${paymentController.orderResponse.value?.result.flightInfo.first.arrDate} ${paymentController.orderResponse.value?.result.flightInfo.first.arrTime}:00');
    final Duration tripDuration = depart.difference(arrival);

    // final User passengger = passengerList[2];

    final TextStyle textBold = ThemeText.paragraph
        .copyWith(fontWeight: FontWeight.bold, color: Colors.black);
    final TextStyle caption = ThemeText.caption.copyWith(color: Colors.black);
    final TextStyle paragraph =
        ThemeText.paragraph.copyWith(color: Colors.black);
    final TextStyle captionGrey =
        ThemeText.caption.copyWith(color: Colors.grey.shade700);
    final Color grey = Colors.grey.shade700;

    return SizedBox(
      height: _height,
      child: Stack(alignment: Alignment.center, children: [
        Column(children: [
          /// BARCODE AND PROMO CODE
          Container(
              height: _height * 0.5,
              width: double.infinity,
              constraints: BoxConstraints(maxWidth: _maxWidth),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(_radius),
                  topRight: Radius.circular(_radius),
                ),
              ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: spacingUnit(1), vertical: spacingUnit(1)),
                      child: Row(children: [
                        Image.network(
                          plane.logo ?? "...",
                          width: 40,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${paymentController.orderResponse.value?.result.flightInfo.first.airline}',
                          style: paragraph,
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                              borderRadius: ThemeRadius.small,
                              color: colorScheme(context).surfaceDim),
                          child: Text(
                              '${paymentController.orderResponse.value?.result.flightInfo.first.flightNum}',
                              style: ThemeText.paragraph),
                        ),
                      ]),
                    ),
                    SizedBox(height: spacingUnit(1)),
                    Text("",
                        style:
                            ThemeText.subtitle.copyWith(color: Colors.black)),
                    Container(
                        padding: EdgeInsets.symmetric(
                            vertical: spacingUnit(1),
                            horizontal: spacingUnit(2)),
                        decoration: BoxDecoration(
                          color: Colors.lightBlue[50],
                          borderRadius: ThemeRadius.medium,
                        ),
                        child: Text(paymentController.orderNo.value,
                            style: ThemeText.title.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ))),
                    const VSpace(),
                    SizedBox(
                        width: double.infinity * 0.8,
                        child: Image.asset('assets/images/barcode.gif',
                            fit: BoxFit.contain)),
                  ])),

          /// THUMBNAIL AND DESCRIPTIONS
          Container(
            height: _height * 0.5,
            padding: EdgeInsets.all(spacingUnit(2)),
            constraints: BoxConstraints(maxWidth: _maxWidth),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(_radius),
                  bottomRight: Radius.circular(_radius),
                )),
            child: Column(children: [
              /// TRIP DETAIL
              const VSpaceShort(),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text("${localization.lastName} ${localization.firstName}",
                      style: caption),
                  Text(
                      "${passengerController.passengers.first.lastname} ${passengerController.passengers.first.firstname}", //'${passengger.title} ${passengger.name}'
                      style: textBold)
                ]),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Passport No.', style: caption),
                  Text(passengerController.passengers.first.idcard,
                      style: textBold)
                ]),
              ]),
              const VSpace(),
              Container(
                padding: EdgeInsets.all(spacingUnit(1)),
                decoration: BoxDecoration(
                    color: Colors.lightBlue[50],
                    borderRadius: ThemeRadius.medium),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    /// FLIGHT DECORATION
                    SizedBox(
                        width: 150,
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: colorScheme(context)
                                            .primaryContainer,
                                        width: 1),
                                    shape: BoxShape.circle),
                              ),
                              const Expanded(child: DashedBorder()),
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: colorScheme(context)
                                            .primaryContainer,
                                        width: 1),
                                    shape: BoxShape.circle),
                              ),
                            ])),

                    /// FLIGHT DETAILS
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: spacingUnit(2)),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 80,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                        paymentController
                                            .orderResponse
                                            .value!
                                            .result
                                            .flightInfo
                                            .first
                                            .dptCityNameEng,
                                        overflow: TextOverflow.ellipsis,
                                        style: ThemeText.headline
                                            .copyWith(color: grey)),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 1),
                                      child: Text(
                                        paymentController.orderResponse.value!
                                            .result.flightInfo.first.dpt,
                                        style: ThemeText.subtitle.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ),
                                    Text(DateFormat.yMMMMd().format(depart),
                                        style: captionGrey),
                                    Text(DateFormat.jm().format(depart),
                                        style: captionGrey),
                                  ]),
                            ),
                            Expanded(
                              child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      paymentController.orderResponse.value!
                                          .result.flightInfo.first.flightNum,
                                      overflow: TextOverflow.ellipsis,
                                      style: ThemeText.paragraph.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: grey),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 2, right: 2, bottom: 4),
                                      child: Icon(CupertinoIcons.airplane,
                                          size: 24, color: grey),
                                    ),
                                    Text(
                                        '${tripDuration.inHours * -1}h ${tripDuration.inMinutes.remainder(60) * -1}m',
                                        style: caption)
                                  ]),
                            ),
                            SizedBox(
                              width: 80,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                        paymentController
                                            .orderResponse
                                            .value!
                                            .result
                                            .flightInfo
                                            .first
                                            .arrCityNameEng,
                                        style: ThemeText.headline
                                            .copyWith(color: grey)),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 1),
                                      child: Text(
                                        paymentController.orderResponse.value!
                                            .result.flightInfo.first.arr,
                                        style: ThemeText.subtitle.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ),
                                    Text(DateFormat.yMMMMd().format(arrival),
                                        style: captionGrey),
                                    Text(DateFormat.jm().format(arrival),
                                        style: captionGrey),
                                  ]),
                            )
                          ]),
                    ),
                  ],
                ),
              ),
              const VSpaceShort(),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Terminal', style: caption),
                      paymentController.orderResponse.value!.result.flightInfo
                              .first.dptTerminal.isNotEmpty
                          ? Text(
                              paymentController.orderResponse.value!.result
                                  .flightInfo.first.dptTerminal,
                              style: textBold)
                          : Text("7", style: textBold)
                    ]),
                Column(children: [
                  Text('GATE', style: caption),
                  Text('H22', style: textBold.copyWith(color: Colors.red))
                ]),
                // Column(children: [
                //   Text('SEAT', style: caption),
                //   Text('${passengerList[0].seat}', style: textBold)
                // ]),
              ]),
              const VSpaceShort(),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                Column(children: [
                  Text(localization.departureDate.toUpperCase(),
                      style: caption),
                  Text(DateFormat.MMMEd().format(depart), style: textBold)
                ]),
                Column(children: [
                  Text(localization.boardingTime.toUpperCase(), style: caption),
                  Text(DateFormat.jm().format(depart),
                      style: textBold.copyWith(color: Colors.red))
                ]),
              ]),
            ]),
          )
        ]),
        Center(
            child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: _maxWidth),
                child: CutDeco(color: ThemePalette.primaryDark, radius: 20))),
      ]),
    );
  }
}
