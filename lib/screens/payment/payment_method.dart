import 'package:flight_app/models/booking.dart';
import 'package:flight_app/models/city.dart';
import 'package:flight_app/models/trip.dart';
import 'package:flight_app/models/voucher.dart';
import 'package:flight_app/ui/themes/theme_breakpoints.dart';
import 'package:flight_app/ui/themes/theme_palette.dart';
import 'package:flight_app/ui/themes/theme_radius.dart';
import 'package:flight_app/ui/themes/theme_text.dart';
import 'package:flight_app/widgets/cards/flight_card.dart';
import 'package:flight_app/widgets/payment/voucher_list.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:flight_app/ui/themes/theme_button.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/widgets/payment/options.dart';
import 'package:flight_app/widgets/stepper/step_progress.dart';

class PaymentMethod extends StatefulWidget {
  const PaymentMethod({super.key});

  @override
  State<PaymentMethod> createState() => _PaymentMethodState();
}

class _PaymentMethodState extends State<PaymentMethod> {
  static const double price = 700;
  static const double discount = 10;

  String _paymentMethod = '';
  final List<Voucher> _selectedVouchers = [];

  void setPaymentMethod(String val) {
    setState(() {
      _paymentMethod = val;
    });
  }

  void updateVoucherList(String type, item) {
    setState(() {
      if (type == 'add') {
        _selectedVouchers.add(item);
      } else {
        _selectedVouchers.remove(item);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Trip item = tripList[1];

    double finalPrice = price - price * discount / 100;

    void showVoucherList() async {
      Get.bottomSheet(
        StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
          return VoucherList(
            selectedVouchers: _selectedVouchers,
            onSelected: (type, item) {
              setState(() {
                updateVoucherList(type, item);
              });
            },
          );
        }),
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        backgroundColor: colorScheme(context).surface,
      );
    }

    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back_ios_new)
        ),
        centerTitle: true,
        title: const Text('Payment', style: ThemeText.subtitle),
      ),
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        StepProgress(activeIndex: 3, items: bookingSteps),

        Expanded(child: ListView(
          shrinkWrap: true,
          children: [
            Padding(
              padding: EdgeInsets.all(spacingUnit(1)),
              child: FlightCard(
                from: cityList[1],
                to: cityList[2],
                plane: item.plane,
                price: 700,
                depart: item.depart,
                arrival: item.arrival,
                transit: item.transit,
                discount: 0,
              ),
            ),
            PaymentOptions(
              paymentMethod: _paymentMethod,
              setPaymentMethod: setPaymentMethod,
            ),
          ],
        )),

        Container(
          width: double.infinity,
          color: colorScheme(context).surface,
          child: Column(
            children: [
              /// VOUCHER INFO
              InkWell(
                onTap: () {
                  showVoucherList();
                },
                child: Container(
                  color: colorScheme(context).secondaryContainer,
                  padding: EdgeInsets.symmetric(horizontal: spacingUnit(1), vertical: spacingUnit(1)),
                  child: _selectedVouchers.isNotEmpty ? Row(children: [
                    Wrap(
                      spacing: 4.0,
                      children: _selectedVouchers.asMap().entries.map((entry) {
                        int index = entry.key;
                        Voucher item = entry.value;

                        if (index > 1) {
                          return Container();
                        }
                        return Container(
                          width: 80,
                          padding: const EdgeInsets.all(2.0),
                          decoration: BoxDecoration(
                            borderRadius: ThemeRadius.xsmall,
                            border: Border.all(width: 1, color: item.color)
                          ),
                          child: Text(item.title, style: ThemeText.caption, overflow: TextOverflow.ellipsis,)
                        );
                      }).toList(),
                    ),
                    _selectedVouchers.length > 2 ? Text('${_selectedVouchers.length - 2} more...', style: ThemeText.caption,) : Container(),
                    const Spacer(),
                    Text('CHANGE', style: ThemeText.paragraph.copyWith(color: colorScheme(context).onSecondaryContainer, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 4),
                    Icon(Icons.arrow_forward_ios, color: colorScheme(context).onSecondaryContainer, size: 11),
                  ]) : Row(children: [
                    Icon(Icons.discount, color: colorScheme(context).primary, size: 11),
                    const SizedBox(width: 4),
                    Text('5 Vouchers Available', style: ThemeText.paragraph.copyWith(fontWeight: FontWeight.bold)),
                    const Spacer(),
                    Text('USE VOUCHERS', style: ThemeText.paragraph.copyWith(color: colorScheme(context).onSecondaryContainer, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 4),
                    Icon(Icons.arrow_forward_ios, color: colorScheme(context).onSecondaryContainer, size: 11),
                  ])
                ),
              ),

              /// TOTAL PRICE AND ACTION BUTTON
              Padding(
                padding: EdgeInsets.only(
                  top: spacingUnit(1),
                  bottom: spacingUnit(5),
                  left: spacingUnit(2),
                  right: spacingUnit(2)
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ThemeBreakpoints.smUp(context) ? const Spacer() : Container(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                        '\$$price',
                          textAlign: TextAlign.end,
                          style: ThemeText.headline.copyWith(color: colorScheme(context).onSurfaceVariant, decoration: TextDecoration.lineThrough, height: 1)
                        ),
                        Text('\$$finalPrice', textAlign: TextAlign.end, style: ThemeText.title.copyWith(color: colorScheme(context).primary, height: 1, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    SizedBox(width: spacingUnit(4)),
                    Expanded(
                      child: FilledButton(
                        onPressed: () {
                          Get.toNamed('/payment/$_paymentMethod');
                        },
                        style: ThemeButton.btnBig.merge(ThemeButton.primary),
                        child: const Text('CONTINUE', style: ThemeText.subtitle2)
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}