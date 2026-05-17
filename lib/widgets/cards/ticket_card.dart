// import 'package:flight_app/models/city.dart';
// import 'package:flight_app/models/plane.dart';
import 'package:flight_app/l10n/app_localizations.dart';
import 'package:flight_app/models/booking.dart';
import 'package:flight_app/models/realModel/flight.dart';
import 'package:flight_app/ui/themes/theme_palette.dart';
import 'package:flight_app/ui/themes/theme_radius.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/ui/themes/theme_text.dart';
import 'package:flight_app/widgets/decorations/cut_deco.dart';
import 'package:flight_app/widgets/decorations/dashed_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:intl/intl.dart';

class TicketCard extends StatelessWidget {
  const TicketCard(
      {super.key,
      required this.from,
      required this.to,
      // required this.plane,
      required this.price,
      required this.depart,
      required this.arrival,
      required this.createdDate,
      required this.status,
      required this.timeLeft,
      required this.bookingCode,
      this.showBoardingPass,
      this.showDetail});

  final FlightSegment from;
  final FlightSegment to;
  // final Plane plane;
  final int price;
  final String depart;
  final String arrival;
  final String createdDate;
  final BookStatus status;
  final String timeLeft;
  final String bookingCode;
  final Function()? showBoardingPass;
  final Function()? showDetail;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final formatter = NumberFormat("#,###");
    final bool isDark = Get.isDarkMode;
    final Color cardColor = isDark
        ? colorScheme(context).outline
        : colorScheme(context).primaryContainer;

    return Column(
      children: [
        /// TOP PROPERTIES
        GestureDetector(
          onTap: showDetail,
          child: Container(
            decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: cardColor, width: 1),
                  left: BorderSide(color: cardColor, width: 1),
                  right: BorderSide(color: cardColor, width: 1),
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                )),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              /// TOP INFO
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: spacingUnit(2), vertical: spacingUnit(1)),
                child: Row(children: [
                  Text('${localization.date}: ',
                      style: ThemeText.paragraph.copyWith(
                          color: colorScheme(context).onSurfaceVariant)),
                  Text(createdDate.substring(0, 10),
                      style: ThemeText.caption
                          .copyWith(fontWeight: FontWeight.bold)),
                  const Spacer(),
                  status != BookStatus.waiting
                      ? Text("${localization.bookingCode}: ",
                          style: ThemeText.paragraph.copyWith(
                              color: colorScheme(context).onSurfaceVariant))
                      : Container(),
                  status != BookStatus.waiting
                      ? Text(bookingCode,
                          style: ThemeText.caption.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme(context).primary))
                      : Container(),
                ]),
              ),
              SizedBox(height: spacingUnit(1)),

              /// TRIP DETAIL
              Stack(
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
                                  border:
                                      Border.all(color: cardColor, width: 1),
                                  shape: BoxShape.circle),
                            ),
                            const Expanded(child: DashedBorder()),
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: cardColor, width: 1),
                                  shape: BoxShape.circle),
                            ),
                          ])),

                  /// FLIGHT DETAILS
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: spacingUnit(2)),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 64,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(from.dptCityNameEng,
                                      overflow: TextOverflow.ellipsis,
                                      style: ThemeText.caption.copyWith(
                                          color: colorScheme(context)
                                              .onSurfaceVariant)),
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 1),
                                    child: Text(
                                      from.dpt,
                                      style: ThemeText.paragraph.copyWith(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Text(from.dptDate,
                                      style: ThemeText.caption.copyWith(
                                          color:
                                              colorScheme(context).onSurface)),
                                  Text(from.dptTime,
                                      style: ThemeText.caption.copyWith(
                                          color: colorScheme(context)
                                              .onSurfaceVariant)),
                                ]),
                          ),
                          Expanded(
                            child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(from.airline,
                                      overflow: TextOverflow.ellipsis,
                                      style: ThemeText.caption.copyWith(
                                          fontWeight: FontWeight.bold)),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Icon(CupertinoIcons.airplane,
                                        size: 24,
                                        color: colorScheme(context)
                                            .outlineVariant),
                                  ),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ClipRRect(
                                          borderRadius: ThemeRadius.xsmall,
                                          child: to.airline.isEmpty
                                              ? Image.network(to.airline,
                                                  width: 36,
                                                  height: 36,
                                                  fit: BoxFit.contain,
                                                  errorBuilder: (_, __, ___) =>
                                                      _airlineInitials(context))
                                              : _airlineInitials(context),
                                        ),
                                        const SizedBox(
                                          width: 4,
                                        ),
                                        Text(from.flightNum,
                                            style: ThemeText.paragraph),
                                        // SizedBox(width: spacingUnit(1)),
                                        // Container(
                                        //   padding: const EdgeInsets.symmetric(
                                        //       horizontal: 4),
                                        //   decoration: BoxDecoration(
                                        //       borderRadius: ThemeRadius.xsmall,
                                        //       color: colorScheme(context)
                                        //           .surfaceDim),
                                        //   child: Text(plane.classType,
                                        //       style: ThemeText.caption),
                                        // ),
                                      ]),
                                ]),
                          ),
                          SizedBox(
                            width: 64,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(to.arrAirportEng,
                                      style: ThemeText.caption.copyWith(
                                          color: colorScheme(context)
                                              .onSurfaceVariant)),
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 1),
                                    child: Text(
                                      to.arr,
                                      style: ThemeText.paragraph.copyWith(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Text(to.arrDate,
                                      style: ThemeText.caption.copyWith(
                                          color: colorScheme(context)
                                              .onSurfaceVariant)),
                                  Text(to.arrTime,
                                      style: ThemeText.caption.copyWith(
                                          color: colorScheme(context)
                                              .onSurfaceVariant)),
                                ]),
                          )
                        ]),
                  ),
                ],
              ),
              SizedBox(
                height: spacingUnit(1),
              )
            ]),
          ),
        ),

        /// CUT DECO
        const CutDeco(),

        /// BOTTOM INFO
        Container(
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              color: cardColor),
          child: Column(
            children: [
              /// PRICE AND STATUS
              GestureDetector(
                onTap: showDetail,
                child: Container(
                  padding: EdgeInsets.all(spacingUnit(1)),
                  decoration: BoxDecoration(
                      color: colorScheme(context).surfaceContainerLowest,
                      border: Border(
                        bottom: BorderSide(color: cardColor, width: 1),
                        left: BorderSide(color: cardColor, width: 1),
                        right: BorderSide(color: cardColor, width: 1),
                      ),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      )),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        /// TIME LEFT AND STATUS
                        Center(child: _ticketStatus(context, status)),
                        // _ticketStatus(context, status),

                        /// PRICE
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(localization.totalAmount,
                                textAlign: TextAlign.end,
                                style: ThemeText.paragraph.copyWith(
                                    color:
                                        colorScheme(context).onSurfaceVariant)),
                            SizedBox(width: spacingUnit(1)),
                            Text(
                                price < 10000
                                    ? '¥${formatter.format(price)}'
                                    : '${formatter.format(price)}₮',
                                textAlign: TextAlign.end,
                                style: ThemeText.subtitle),
                          ],
                        ),
                      ]),
                ),
              ),

              /// SHOW BOARDING PASS BUTTON
              status == BookStatus.active
                  ? GestureDetector(
                      onTap: showBoardingPass,
                      child: Padding(
                        padding: EdgeInsets.all(spacingUnit(1)),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.qr_code, color: cardColor, size: 16),
                              SizedBox(width: spacingUnit(1)),
                              Text('SHOW BOARDING PASS',
                                  style: ThemeText.paragraph.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: colorScheme(context)
                                          .onPrimaryContainer)),
                            ]),
                      ),
                    )
                  : Container()
            ],
          ),
        ),
      ],
    );
  }

  Widget _ticketStatus(BuildContext context, BookStatus status) {
    Color colorStatus(BookStatus st) {
      switch (st) {
        case BookStatus.active:
          return Colors.green;
        case BookStatus.waiting:
          return Colors.orange;
        case BookStatus.canceled:
          return Colors.red;
        default:
          return Colors.grey;
      }
    }

    switch (status) {
      case BookStatus.active:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Check in available in',
                textAlign: TextAlign.start,
                style: ThemeText.caption
                    .copyWith(color: colorScheme(context).onSurfaceVariant)),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
              decoration: BoxDecoration(
                borderRadius: ThemeRadius.small,
                color: colorStatus(status).withValues(alpha: 0.25),
              ),
              child: Row(children: [
                const Icon(Icons.access_time, size: 16),
                const SizedBox(width: 4),
                Text(timeLeft,
                    textAlign: TextAlign.center, style: ThemeText.subtitle),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                  decoration: BoxDecoration(
                    borderRadius: ThemeRadius.small,
                    color: colorStatus(status),
                  ),
                  child: Text(status.name.toUpperCase(),
                      style: ThemeText.caption.copyWith(
                          fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ]),
            )
          ],
        );
      case BookStatus.waiting:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Expired in',
                textAlign: TextAlign.start,
                style: ThemeText.caption
                    .copyWith(color: colorScheme(context).onSurfaceVariant)),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
              decoration: BoxDecoration(
                borderRadius: ThemeRadius.small,
                color: colorStatus(status).withValues(alpha: 0.25),
              ),
              child: Row(children: [
                const Icon(Icons.access_time, size: 16),
                const SizedBox(width: 4),
                Text(timeLeft,
                    textAlign: TextAlign.center, style: ThemeText.subtitle),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                  decoration: BoxDecoration(
                    borderRadius: ThemeRadius.small,
                    color: colorStatus(status),
                  ),
                  child: Text(status.name.toUpperCase(),
                      style: ThemeText.caption.copyWith(
                          fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ]),
            )
          ],
        );
      default:
        return Container(
          padding: EdgeInsets.all(spacingUnit(1)),
          decoration: BoxDecoration(
            borderRadius: ThemeRadius.small,
            color: colorStatus(status).withValues(alpha: 0.25),
          ),
          child: Text(
            status.name.toUpperCase(),
            style: ThemeText.caption.copyWith(fontWeight: FontWeight.bold),
          ),
        );
    }
  }

  Widget _airlineInitials(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colorScheme(context).primaryContainer,
        borderRadius: ThemeRadius.xsmall,
      ),
      child: Text(
        from.airline.length >= 2
            ? from.airline.substring(0, 2).toUpperCase()
            : from.airline,
        style: ThemeText.paragraph.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}
