import 'package:flight_app/l10n/app_localizations.dart';
import 'package:flight_app/models/city.dart';
import 'package:flight_app/models/realModel/order.dart';
import 'package:flight_app/models/realModel/passenger.dart';
import 'package:flight_app/models/trip.dart';
import 'package:flight_app/models/user.dart';
import 'package:flight_app/models/booking.dart';
import 'package:flight_app/ui/themes/theme_palette.dart';
import 'package:flight_app/ui/themes/theme_radius.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/ui/themes/theme_text.dart';
import 'package:flight_app/widgets/app_input/app_input_box.dart';
import 'package:flight_app/widgets/booking/passenger_detail.dart';
import 'package:flight_app/widgets/cards/flight_card.dart';
import 'package:flight_app/widgets/decorations/dashed_border.dart';
import 'package:flight_app/widgets/title/title_basic.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:intl/intl.dart';

class ReviewOrder extends StatelessWidget {
  const ReviewOrder({
    super.key,
    this.withFlightDetail = true,
    required this.orderResponse,
  });

  static const double price = 600;
  static const double discount = 10;

  final bool withFlightDetail;

  final CreateOrderResponse orderResponse;

  @override
  Widget build(BuildContext context) {
    // final Trip item = tripList[1];
    final localization = AppLocalizations.of(context)!;
    final formatter = NumberFormat("#,###");

    /// BAGAGE POPUP
    void showPassengerDetail(OrderPassenger passenger) async {
      Get.bottomSheet(
        StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
          return PassengerDetail(passenger: passenger);
        }),
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        backgroundColor: colorScheme(context).surface,
      );
    }

    return ListView(
        shrinkWrap: true,
        physics: const ScrollPhysics(),
        padding: const EdgeInsets.all(0),
        children: [
          /// FLIGHT SUMMARY
          withFlightDetail ? SizedBox(height: spacingUnit(2)) : Container(),
          // withFlightDetail
          //     ? Padding(
          //         padding: EdgeInsets.symmetric(horizontal: spacingUnit(2)),
          //         child:
          //          FlightCard(
          //           from: cityList[1],
          //           to: cityList[2],
          //           plane: item.plane,
          //           price: 700,
          //           depart: item.depart,
          //           arrival: item.arrival,
          //           transit: item.transit,
          //           discount: 10,
          //           label: '10% OFF',
          //         ),
          //       )
          //     :
          Container(),

          /// PASSENGGER LIST
          const LineSpace(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: spacingUnit(2)),
            child: TitleBasic(
              title: localization.passengerDetail,
              size: 'small',
            ),
          ),
          ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: spacingUnit(2)),
              physics: const ClampingScrollPhysics(),
              itemCount: orderResponse.result.passengers.length,
              itemBuilder: ((BuildContext context, int index) {
                OrderPassenger passenger =
                    orderResponse.result.passengers[index];
                return Padding(
                  padding: EdgeInsets.only(top: spacingUnit(2)),
                  child: AppInputBox(
                      content: InkWell(
                          onTap: () {
                            showPassengerDetail(passenger);
                          },
                          child: ListTile(
                            title: Text(
                              passenger.name, //'${item.title} ${item.name}'
                              style: ThemeText.paragraphBold,
                            ),
                            subtitle: Row(children: [
                              Icon(Icons.home_repair_service,
                                  size: 18,
                                  color: colorScheme(context).outlineVariant),
                              const SizedBox(
                                width: 4,
                              ),
                              Text(
                                  '${orderResponse.result.baggageRuleInfos.first.checkedBaggageRule.substring(0, 2)} Kg',
                                  style: ThemeText.paragraph),
                              SizedBox(width: spacingUnit(4)),
                              // Icon(Icons.airline_seat_recline_normal_rounded,
                              //     size: 18,
                              //     color: colorScheme(context).outlineVariant),
                              // Text(item.seat!, style: ThemeText.paragraph),
                              // SizedBox(width: spacingUnit(4)),
                              Icon(Icons.card_membership,
                                  size: 18,
                                  color: colorScheme(context).outlineVariant),
                              const SizedBox(
                                width: 4,
                              ),
                              Text(passenger.passport,
                                  style: ThemeText.paragraph),
                              SizedBox(width: spacingUnit(4)),
                              Icon(passenger.sex == 1 ? Icons.man : Icons.woman,
                                  size: 18,
                                  color: colorScheme(context).outlineVariant),
                              const SizedBox(
                                width: 4,
                              ),
                              Text(
                                  passenger.sex == 1
                                      ? localization.male
                                      : localization.female,
                                  style: ThemeText.paragraph),
                            ]),
                            trailing: Icon(Icons.more_horiz,
                                color: colorScheme(context).primary),
                            contentPadding: const EdgeInsets.all(0),
                            minTileHeight: 0,
                          ))),
                );
              })),

          /// PRICE DETAIL
          const LineSpace(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: spacingUnit(2)),
            child: TitleBasic(
              title: localization.priceDetail,
              size: 'small',
            ),
          ),
          const VSpaceShort(),
          ListTile(
            title: Text(
              '${localization.ticket} ${orderResponse.result.flightInfo.first.dptCityNameEng} to ${orderResponse.result.flightInfo.last.arrCityNameEng}',
              style: ThemeText.paragraph,
            ),
            subtitle: Text(
              orderResponse.result.priceInfo.price < 100000
                  ? '¥${formatter.format(orderResponse.result.priceInfo.price)} x ${orderResponse.result.passengers.length}'
                  : '₮${formatter.format(orderResponse.result.priceInfo.price)} x ${orderResponse.result.passengers.length}',
              style: ThemeText.paragraph,
            ),
            trailing: Text(
                orderResponse.result.priceInfo.price < 100000
                    ? '¥${formatter.format(orderResponse.result.priceInfo.price * orderResponse.result.passengers.length)}'
                    : '₮${formatter.format(orderResponse.result.priceInfo.price * orderResponse.result.passengers.length)}',
                style: ThemeText.paragraph.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme(context).onSurface)),
            contentPadding: EdgeInsets.symmetric(horizontal: spacingUnit(2)),
            minTileHeight: 0,
          ),

          // ListTile(
          //   title: const Text(
          //     'Additional Baggage',
          //     style: ThemeText.paragraph,
          //   ),
          //   subtitle: const Text(
          //     '\$50 x 1(Adult)',
          //     style: ThemeText.paragraph,
          //   ),
          //   trailing: Text('\$50',
          //       style: ThemeText.paragraph.copyWith(
          //           fontWeight: FontWeight.bold,
          //           color: colorScheme(context).onSurface)),
          //   contentPadding: EdgeInsets.symmetric(horizontal: spacingUnit(2)),
          //   minTileHeight: 0,
          // ),

          // ListTile(
          //   title: const Text(
          //     'Meal and Beverage',
          //     style: ThemeText.paragraph,
          //   ),
          //   subtitle: const Text(
          //     '\$20 x 2(Adult)',
          //     style: ThemeText.paragraph,
          //   ),
          //   trailing: Text('\$40',
          //       style: ThemeText.paragraph.copyWith(
          //           fontWeight: FontWeight.bold,
          //           color: colorScheme(context).onSurface)),
          //   contentPadding: EdgeInsets.symmetric(horizontal: spacingUnit(2)),
          //   minTileHeight: 0,
          // ),

          ListTile(
            title: Text(
              localization.feeAndTax,
              style: ThemeText.paragraph,
            ),
            trailing: Text(
                orderResponse.result.priceInfo.tax < 100000
                    ? '¥${formatter.format(orderResponse.result.priceInfo.tax)}'
                    : '₮${formatter.format(orderResponse.result.priceInfo.tax)}',
                style: ThemeText.paragraph.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme(context).onSurface)),
            contentPadding: EdgeInsets.symmetric(horizontal: spacingUnit(2)),
            minTileHeight: 0,
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: DashedBorder(),
          ),

          ListTile(
            title: Text(
              localization.subtotal,
              style: ThemeText.paragraph.copyWith(fontWeight: FontWeight.bold),
            ),
            trailing: Text(
                orderResponse.result.priceInfo.tax < 100000
                    ? '¥${formatter.format(orderResponse.result.priceInfo.tax + orderResponse.result.priceInfo.price * orderResponse.result.passengers.length)}'
                    : '₮${formatter.format(orderResponse.result.priceInfo.tax + orderResponse.result.priceInfo.price * orderResponse.result.passengers.length)}',
                style:
                    ThemeText.paragraph.copyWith(fontWeight: FontWeight.bold)),
            contentPadding: EdgeInsets.symmetric(horizontal: spacingUnit(2)),
            minTileHeight: 0,
          ),
          // ListTile(
          //   title: Text(
          //     'Discount 10%',
          //     style: ThemeText.paragraph.copyWith(fontWeight: FontWeight.bold),
          //   ),
          //   trailing: Text('-\$70',
          //       style:
          //           ThemeText.paragraph.copyWith(fontWeight: FontWeight.bold)),
          //   contentPadding: EdgeInsets.symmetric(horizontal: spacingUnit(2)),
          //   minTileHeight: 0,
          // ),

          Container(
            margin: EdgeInsets.symmetric(horizontal: spacingUnit(1)),
            decoration: BoxDecoration(
                borderRadius: ThemeRadius.small,
                color: colorScheme(context).primaryContainer),
            child: ListTile(
              title: Text(localization.total, style: ThemeText.subtitle2),
              trailing: Text(
                  orderResponse.result.amount < 100000
                      ? '¥${formatter.format(orderResponse.result.amount)}'
                      : '₮${formatter.format(orderResponse.result.amount)}',
                  style: ThemeText.subtitle2.copyWith(
                      color: colorScheme(context).onPrimaryContainer)),
              contentPadding: EdgeInsets.symmetric(horizontal: spacingUnit(2)),
              minTileHeight: 0,
            ),
          ),
          // const VSpaceShort(),

          // Container(
          //   margin: EdgeInsets.symmetric(horizontal: spacingUnit(1)),
          //   padding: EdgeInsets.symmetric(horizontal: spacingUnit(1)),
          //   child: const Text(
          //       'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur tortor lectus, imperdiet vitae massa nec, malesuada congue massa. Nam sed venenatis lorem',
          //       style: ThemeText.paragraph),
          // ),
          // const VSpace()
        ]);
  }
}
