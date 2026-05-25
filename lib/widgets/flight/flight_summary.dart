import 'package:flight_app/app/controller/fligth_detail_controller.dart';
import 'package:flight_app/l10n/app_localizations.dart';
import 'package:flight_app/models/ggModel/city.dart';
import 'package:flight_app/models/ggModel/plane.dart';
import 'package:flight_app/models/realModel/flight.dart';
import 'package:flight_app/ui/themes/theme_palette.dart';
import 'package:flight_app/ui/themes/theme_radius.dart';
import 'package:flight_app/ui/themes/theme_shadow.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/ui/themes/theme_text.dart';
import 'package:flight_app/widgets/decorations/dashed_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:intl/intl.dart';

class FlightSummary extends StatelessWidget {
  const FlightSummary({
    super.key,
    this.roundTrip = false,
    this.bordered = false,
    this.depart,
    this.arrival,
    this.plane,
    this.from,
    this.to,
    this.price,
  });
  final String? from;
  final String? to;
  final double? price;
  final bool roundTrip;
  final bool bordered;
  final DateTime? depart;
  final DateTime? arrival;
  final Plane? plane;

  @override
  Widget build(BuildContext context) {
    final locilization = AppLocalizations.of(context)!;
    final formatter = NumberFormat("#,###");
    final controller = Get.find<FlightDetailController>();
    final flightExtInfo = Get.find<FlightDetailController>().ext;
    final flightSegment1 = Get.find<FlightDetailController>().firstSeg;
    final flightSegment2 = Get.find<FlightDetailController>().lastSeg;
    // ignore: avoid_print
    print("${flightSegment1!.arr} ${flightSegment2!.arr}");

    final firstSeg = controller.firstSeg!;
    final lastSeg = controller.lastSeg!;
    String formatDuration1(String hourLabel, String minLabel) {
      final depart = DateTime.tryParse(
        '${firstSeg.dptDate} ${firstSeg.dptTime}',
      );

      final arrDate =
          firstSeg.arrDate.isEmpty ? firstSeg.dptDate : firstSeg.arrDate;

      var arrive = DateTime.tryParse(
        '$arrDate ${firstSeg.arrTime}',
      );

      if (depart == null || arrive == null) {
        return firstSeg.flightTimes;
      }

      if (arrive.isBefore(depart)) {
        arrive = arrive.add(const Duration(days: 1));
      }

      final diff = arrive.difference(depart);
      return '${diff.inHours} $hourLabel ${diff.inMinutes.remainder(60)} $minLabel';
    }

    String formatDuration2(String hourLabel, String minLabel) {
      final depart = DateTime.tryParse(
        '${lastSeg.dptDate} ${lastSeg.dptTime}',
      );

      final arrDate =
          lastSeg.arrDate.isEmpty ? lastSeg.dptDate : lastSeg.arrDate;

      var arrive = DateTime.tryParse(
        '$arrDate ${lastSeg.arrTime}',
      );

      if (depart == null || arrive == null) {
        return lastSeg.flightTimes;
      }

      if (arrive.isBefore(depart)) {
        arrive = arrive.add(const Duration(days: 1));
      }

      final diff = arrive.difference(depart);
      return '${diff.inHours} $hourLabel ${diff.inMinutes.remainder(60)} $minLabel';
    }

    return Container(
      margin: EdgeInsets.all(spacingUnit(2)),
      padding: EdgeInsets.symmetric(vertical: spacingUnit(1)),
      decoration: BoxDecoration(
          color: colorScheme(context).surface,
          borderRadius: ThemeRadius.medium,
          boxShadow: !bordered ? [ThemeShade.shadeSoft(context)] : null,
          border: bordered
              ? Border.all(
                  width: 1, color: colorScheme(context).primaryContainer)
              : null),
      child: Column(
        children: [
          /// AIRPLANE INFO
          flightSegment1.arr == flightSegment2.dpt
              ? Column(children: [
                  flightExtInfo?.nctype == "rt"
                      ? Text(locilization.departure,
                          style: ThemeText.paragraph
                              .copyWith(color: colorScheme(context).primary))
                      : Container(),
                  Padding(
                    padding: EdgeInsets.only(
                      left: spacingUnit(2),
                      right: spacingUnit(2),
                      bottom: spacingUnit(2),
                      top: spacingUnit(1),
                    ),
                    child: Row(children: [
                      ClipRRect(
                        borderRadius: ThemeRadius.xsmall,
                        child: Image.network(
                          plane!.logo,
                          width: 20,
                        ),
                      ),
                      const SizedBox(
                        width: 2,
                      ),
                      Text(
                        flightSegment1.airline,
                        style: ThemeText.subtitle2,
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            borderRadius: ThemeRadius.xsmall,
                            color: colorScheme(context).outline),
                        child: Text(flightSegment1.flightNum,
                            style: ThemeText.paragraph),
                      )
                    ]),
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      /// DECORATION
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
                                          color: colorScheme(context).primary,
                                          width: 1),
                                      shape: BoxShape.circle),
                                ),
                                const Expanded(
                                  child: DashedBorder(),
                                ),
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: colorScheme(context).primary,
                                          width: 1),
                                      shape: BoxShape.circle),
                                ),
                              ])),

                      /// DESTINATION
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: spacingUnit(2)),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 64,
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(flightSegment1.dptCityNameEng,
                                          style: ThemeText.paragraph.copyWith(
                                              color: colorScheme(context)
                                                  .onSurfaceVariant)),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 1),
                                        child: Text(
                                          flightSegment1.dpt,
                                          style: ThemeText.title2.copyWith(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      depart != null
                                          ? Text(
                                              DateFormat.MMMEd()
                                                  .format(depart!),
                                              style: ThemeText.paragraph
                                                  .copyWith(
                                                      color: colorScheme(
                                                              context)
                                                          .onSurfaceVariant))
                                          : Container(),
                                      depart != null
                                          ? Text(
                                              DateFormat.jm().format(depart!),
                                              style: ThemeText.paragraph
                                                  .copyWith(
                                                      color: colorScheme(
                                                              context)
                                                          .onSurfaceVariant))
                                          : Container(),
                                    ]),
                              ),
                              Expanded(
                                child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 2, vertical: 2),
                                        child: Icon(
                                            roundTrip
                                                ? CupertinoIcons
                                                    .arrow_right_arrow_left
                                                : CupertinoIcons.airplane,
                                            size: 24,
                                            color: colorScheme(context)
                                                .outlineVariant),
                                      ),
                                    ]),
                              ),
                              SizedBox(
                                width: 64,
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(flightSegment1.arrCityNameEng,
                                          style: ThemeText.paragraph.copyWith(
                                              color: colorScheme(context)
                                                  .onSurfaceVariant)),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 1),
                                        child: Text(
                                          flightSegment1.arr,
                                          style: ThemeText.title2.copyWith(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      arrival != null
                                          ? Text(
                                              DateFormat.MMMEd()
                                                  .format(arrival!),
                                              style: ThemeText.paragraph
                                                  .copyWith(
                                                      color: colorScheme(
                                                              context)
                                                          .onSurfaceVariant))
                                          : Container(),
                                      arrival != null
                                          ? Text(
                                              DateFormat.jm().format(arrival!),
                                              style: ThemeText.paragraph
                                                  .copyWith(
                                                      color: colorScheme(
                                                              context)
                                                          .onSurfaceVariant))
                                          : Container(),
                                    ]),
                              )
                            ]),
                      ),
                    ],
                  ),
                  Divider(color: colorScheme(context).primaryContainer),
                  Padding(
                    padding: EdgeInsets.only(
                      left: spacingUnit(2),
                      right: spacingUnit(2),
                      bottom: spacingUnit(2),
                      top: spacingUnit(1),
                    ),
                    child: Row(children: [
                      ClipRRect(
                        borderRadius: ThemeRadius.xsmall,
                        child: Image.network(
                          plane!.logo,
                          width: 20,
                        ),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Text(
                        flightSegment2.airline,
                        style: ThemeText.subtitle2,
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            borderRadius: ThemeRadius.xsmall,
                            color: colorScheme(context).outline),
                        child: Text(flightSegment2.flightNum,
                            style: ThemeText.paragraph),
                      )
                    ]),
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      /// DECORATION
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
                                          color: colorScheme(context).primary,
                                          width: 1),
                                      shape: BoxShape.circle),
                                ),
                                const Expanded(
                                  child: DashedBorder(),
                                ),
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: colorScheme(context).primary,
                                          width: 1),
                                      shape: BoxShape.circle),
                                ),
                              ])),

                      /// DESTINATION
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: spacingUnit(2)),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 64,
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(flightSegment2.dptCityNameEng,
                                          style: ThemeText.paragraph.copyWith(
                                              color: colorScheme(context)
                                                  .onSurfaceVariant)),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 1),
                                        child: Text(
                                          flightSegment2.dpt,
                                          style: ThemeText.title2.copyWith(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      depart != null
                                          ? Text(
                                              DateFormat.MMMEd()
                                                  .format(depart!),
                                              style: ThemeText.paragraph
                                                  .copyWith(
                                                      color: colorScheme(
                                                              context)
                                                          .onSurfaceVariant))
                                          : Container(),
                                      depart != null
                                          ? Text(
                                              DateFormat.jm().format(depart!),
                                              style: ThemeText.paragraph
                                                  .copyWith(
                                                      color: colorScheme(
                                                              context)
                                                          .onSurfaceVariant))
                                          : Container(),
                                    ]),
                              ),
                              Expanded(
                                child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 2, vertical: 2),
                                        child: Icon(
                                            roundTrip
                                                ? CupertinoIcons
                                                    .arrow_right_arrow_left
                                                : CupertinoIcons.airplane,
                                            size: 24,
                                            color: colorScheme(context)
                                                .outlineVariant),
                                      ),
                                    ]),
                              ),
                              SizedBox(
                                width: 64,
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(flightSegment2.arrCityNameEng,
                                          style: ThemeText.paragraph.copyWith(
                                              color: colorScheme(context)
                                                  .onSurfaceVariant)),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 1),
                                        child: Text(
                                          flightSegment2.arr,
                                          style: ThemeText.title2.copyWith(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      arrival != null
                                          ? Text(
                                              DateFormat.MMMEd()
                                                  .format(arrival!),
                                              style: ThemeText.paragraph
                                                  .copyWith(
                                                      color: colorScheme(
                                                              context)
                                                          .onSurfaceVariant))
                                          : Container(),
                                      arrival != null
                                          ? Text(
                                              DateFormat.jm().format(arrival!),
                                              style: ThemeText.paragraph
                                                  .copyWith(
                                                      color: colorScheme(
                                                              context)
                                                          .onSurfaceVariant))
                                          : Container(),
                                    ]),
                              )
                            ]),
                      ),
                    ],
                  )
                ])
              : Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: spacingUnit(2),
                        right: spacingUnit(2),
                        bottom: spacingUnit(2),
                        top: spacingUnit(1),
                      ),
                      child: Row(children: [
                        ClipRRect(
                          borderRadius: ThemeRadius.xsmall,
                          child: Image.network(
                            plane!.logo,
                            width: 20,
                          ),
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Text(
                          flightSegment2.airline,
                          style: ThemeText.subtitle2,
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                              borderRadius: ThemeRadius.xsmall,
                              color: colorScheme(context).outline),
                          child: Text(flightSegment2.flightNum,
                              style: ThemeText.paragraph),
                        )
                      ]),
                    ),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        /// DECORATION
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
                                            color: colorScheme(context).primary,
                                            width: 1),
                                        shape: BoxShape.circle),
                                  ),
                                  const Expanded(
                                    child: DashedBorder(),
                                  ),
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: colorScheme(context).primary,
                                            width: 1),
                                        shape: BoxShape.circle),
                                  ),
                                ])),

                        /// DESTINATION
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: spacingUnit(2)),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 64,
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(flightSegment2.dptCityNameEng,
                                            // overflow: TextOverflow.ellipsis,
                                            style: ThemeText.paragraph.copyWith(
                                                color: colorScheme(context)
                                                    .onSurfaceVariant)),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 1),
                                          child: Text(
                                            flightSegment2.dpt,
                                            style: ThemeText.title2.copyWith(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        depart != null
                                            ? Text(
                                                DateFormat.MMMEd()
                                                    .format(depart!),
                                                style: ThemeText.paragraph
                                                    .copyWith(
                                                        color: colorScheme(
                                                                context)
                                                            .onSurfaceVariant))
                                            : Container(),
                                        depart != null
                                            ? Text(
                                                DateFormat.jm().format(depart!),
                                                style: ThemeText.paragraph
                                                    .copyWith(
                                                        color: colorScheme(
                                                                context)
                                                            .onSurfaceVariant))
                                            : Container(),
                                      ]),
                                ),
                                Expanded(
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 2, vertical: 2),
                                          child: Icon(
                                              roundTrip
                                                  ? CupertinoIcons
                                                      .arrow_right_arrow_left
                                                  : CupertinoIcons.airplane,
                                              size: 24,
                                              color: colorScheme(context)
                                                  .outlineVariant),
                                        ),
                                      ]),
                                ),
                                SizedBox(
                                  width: 64,
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(flightSegment2.arrCityNameEng,
                                            style: ThemeText.paragraph.copyWith(
                                                color: colorScheme(context)
                                                    .onSurfaceVariant)),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 1),
                                          child: Text(
                                            flightSegment2.arr,
                                            style: ThemeText.title2.copyWith(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        arrival != null
                                            ? Text(
                                                DateFormat.MMMEd()
                                                    .format(arrival!),
                                                style: ThemeText.paragraph
                                                    .copyWith(
                                                        color: colorScheme(
                                                                context)
                                                            .onSurfaceVariant))
                                            : Container(),
                                        arrival != null
                                            ? Text(
                                                DateFormat.jm()
                                                    .format(arrival!),
                                                style: ThemeText.paragraph
                                                    .copyWith(
                                                        color: colorScheme(
                                                                context)
                                                            .onSurfaceVariant))
                                            : Container(),
                                      ]),
                                )
                              ]),
                        ),
                      ],
                    ),
                  ],
                ),

          /// PRICE AND LABEL
          Divider(color: colorScheme(context).primaryContainer),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: spacingUnit(1)),
            child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
              flightSegment1.arr == flightSegment2.dpt
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                          Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                  borderRadius: ThemeRadius.xsmall,
                                  color:
                                      colorScheme(context).secondaryContainer),
                              child: Text(
                                  "${locilization.departure} : ${formatDuration1(locilization.hours, locilization.min)}",
                                  style: ThemeText.paragraph.copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: colorScheme(context).onSurface))),
                          Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                  borderRadius: ThemeRadius.xsmall,
                                  color:
                                      colorScheme(context).secondaryContainer),
                              child: Text(
                                  "${locilization.returnword} : ${formatDuration2(locilization.hours, locilization.min)}",
                                  style: ThemeText.paragraph.copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: colorScheme(context).onSurface)))
                        ])
                  : Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                          borderRadius: ThemeRadius.xsmall,
                          color: colorScheme(context).secondaryContainer),
                      child: Text(
                          formatDuration1(locilization.hours, locilization.min),
                          style: ThemeText.paragraph.copyWith(
                              fontWeight: FontWeight.w500,
                              color: colorScheme(context).onSurface))),
              const SizedBox(width: 5),
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                    borderRadius: ThemeRadius.xsmall,
                    color: colorScheme(context).tertiaryContainer),
                child: Icon(CupertinoIcons.time,
                    color: colorScheme(context).tertiary, size: 16),
              ),
              // const Spacer(),
              // discount > 0
              //     ? Text('\$${price.toStringAsFixed(0)}',
              //         textAlign: TextAlign.end,
              //         style: ThemeText.headline.copyWith(
              //             color: colorScheme(context).onSurfaceVariant,
              //             height: 1,
              //             decoration: TextDecoration.lineThrough))
              //     : Container(),
              SizedBox(
                width: spacingUnit(1),
              ),
              Expanded(
                child: Text(
                    flightExtInfo!.totalPrice < 100000
                        ? '¥${formatter.format(flightExtInfo.totalPrice)}'
                        : '₮${formatter.format(flightExtInfo.totalPrice)}',
                    textAlign: TextAlign.end,
                    style: ThemeText.title.copyWith(
                        color: colorScheme(context).primary,
                        height: 1,
                        fontWeight: FontWeight.w500)),
              )
            ]),
          ),
        ],
      ),
    );
  }
}
