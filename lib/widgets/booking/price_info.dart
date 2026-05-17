import 'package:flight_app/app/controller/flight_booking_controller.dart';
import 'package:flight_app/app/controller/flight_search_controller.dart';
import 'package:flight_app/app/controller/payment_controller.dart';
import 'package:flight_app/l10n/app_localizations.dart';
// import 'package:flight_app/models/realModel/booking.dart';
import 'package:flight_app/ui/themes/theme_palette.dart';
import 'package:flight_app/ui/themes/theme_radius.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/ui/themes/theme_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class PaymentInfoWidget extends StatelessWidget {
  const PaymentInfoWidget({super.key, this.onPay, required this.mnt});

  final VoidCallback? onPay;
  final double mnt;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final bookingController = Get.find<BookingController>();
    final searchController = Get.find<FlightSearchController>();
    final paymentController = Get.find<PaymentController>();

    return Obx(() {
      final priceInfo = bookingController.priceInfo;
      if (priceInfo == null) return const SizedBox();

      final adults = searchController.adults.value;
      final children = searchController.children.value;
      final formatter = NumberFormat("#,###");

      // ── Calculations ───────────────────────────────────────────────

      //       "price": 4644700.0,
      // "tax": 1118900.0,
      // "totalPrice": 4644700.0,
      // "cTax": 1118900.0,
      // "cPrice": 4644700.0,
      // "cTotalPrice": 4644700.0,
      double adultTotal = priceInfo.totalPrice * adults;
      double childTotal = priceInfo.cTotalPrice * children;
      double fee = priceInfo.fee;
      double nightFee = priceInfo.nightFee;
      double bankFeePercent = priceInfo.moneyTransfer; // e.g. 3
      // double operatorFeePercent = priceInfo.operatorFeePercent;
      double subtotal = adultTotal + childTotal + fee;
      double bankFee = subtotal * bankFeePercent / 100;
      double operatorFee = priceInfo.operatorFee;
      double totalfee = fee + operatorFee;
      double grandTotal = (subtotal + bankFee + operatorFee + nightFee);
      // operatorFeePercent /
      // 100;
      print("total price ${priceInfo.totalPrice}");
      if (priceInfo.totalPrice < 10000) {
        adultTotal = adultTotal * mnt;
        childTotal = childTotal * mnt;
        subtotal = adultTotal + childTotal + fee;
        bankFee = subtotal * bankFeePercent / 100;
        grandTotal = (subtotal + bankFee + operatorFee + nightFee) + 3855;
        print("to mnt price $mnt");
      }

      String formatPrice(double val) {
        return val < 100000
            ? '¥${formatter.format(val)}'
            : '${formatter.format(val)}₮';
      }

      return Container(
        // margin: EdgeInsets.all(spacingUnit(2)),
        padding: EdgeInsets.all(spacingUnit(2)),
        decoration: BoxDecoration(
          color: colorScheme(context).surfaceContainer,
          borderRadius: ThemeRadius.medium,
          // border: Border.all(color: colorScheme(context).outlineVariant),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Title ──────────────────────────────────────────────────
            Row(
              children: [
                Text(
                  localization.paymentInfo,
                  style: ThemeText.subtitle.copyWith(
                    color: colorScheme(context).primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.credit_card_outlined,
                  color: colorScheme(context).onSurfaceVariant,
                  size: 20,
                ),
              ],
            ),

            SizedBox(height: spacingUnit(2)),
            Divider(color: colorScheme(context).outlineVariant, height: 1),
            SizedBox(height: spacingUnit(2)),

            // ── Adult price ────────────────────────────────────────────
            _PriceRow(
              label: localization.adult,
              badge: 'x$adults',
              value: formatPrice(adultTotal),
              context: context,
            ),

            SizedBox(height: spacingUnit(1) + 4),

            // ── Child price ────────────────────────────────────────────
            _PriceRow(
              label: localization.child,
              badge: 'x$children',
              value: children > 0 ? formatPrice(childTotal) : formatPrice(0),
              context: context,
            ),

            SizedBox(height: spacingUnit(1) + 4),

            // ── Service fee ────────────────────────────────────────────
            _PriceRow(
              label: localization.serviceFee,
              subLabel: '${formatter.format(totalfee)}₮x1',
              value: '${formatter.format(totalfee)}₮',
              context: context,
            ),

            nightFee != 0
                ? _PriceRow(
                    label: localization.nightFee,
                    subLabel: '${formatter.format(nightFee)}₮x1',
                    value: '${formatter.format(nightFee)}₮',
                    context: context,
                  )
                : const SizedBox(),

            SizedBox(height: spacingUnit(1) + 4),

            // ── Bank fee ───────────────────────────────────────────────
            bankFeePercent != 0
                ? _PriceRow(
                    label: localization.bankFee,
                    badge: '$bankFeePercent%',
                    value: '${formatter.format(bankFee)}₮',
                    context: context,
                  )
                : const SizedBox(),

            SizedBox(height: spacingUnit(2)),
            Divider(color: colorScheme(context).outlineVariant, height: 1),
            SizedBox(height: spacingUnit(2)),

            // ── Grand total ────────────────────────────────────────────
            Row(
              children: [
                Text(
                  localization.totalPayment,
                  style: ThemeText.subtitle.copyWith(
                    color: colorScheme(context).primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Text(
                  formatPrice(paymentController
                          .orderResponse.value?.result.amount
                          .toDouble() ??
                      grandTotal),
                  style: ThemeText.subtitle.copyWith(
                    color: colorScheme(context).primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            SizedBox(height: spacingUnit(2)),

            // ── Pay button ─────────────────────────────────────────────
            // SizedBox(
            //   width: double.infinity,
            //   child: FilledButton(
            //     onPressed: onPay,
            //     style: FilledButton.styleFrom(
            //       backgroundColor: const Color(0xFFD4006E),
            //       padding: EdgeInsets.symmetric(vertical: spacingUnit(2)),
            //       shape: RoundedRectangleBorder(
            //         borderRadius: ThemeRadius.medium,
            //       ),
            //     ),
            //     child: Text(
            //       'Үргэлжлүүлэх',
            //       style: ThemeText.subtitle.copyWith(
            //         color: Colors.white,
            //         fontWeight: FontWeight.bold,
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      );
    });
  }
}

// ── Price row ──────────────────────────────────────────────────────────────────
class _PriceRow extends StatelessWidget {
  const _PriceRow({
    required this.label,
    required this.value,
    required this.context,
    this.badge,
    this.subLabel,
  });

  final String label;
  final String value;
  final String? badge;
  final String? subLabel;
  final BuildContext context;

  @override
  Widget build(BuildContext ctx) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Label + badge
            Expanded(
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      label,
                      style: ThemeText.paragraph.copyWith(
                        color: colorScheme(context).onSurface,
                      ),
                    ),
                  ),
                  if (badge != null) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: colorScheme(context).primaryContainer,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        badge!,
                        style: ThemeText.caption.copyWith(
                          color: colorScheme(context).primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            // Value
            Text(
              value,
              style: ThemeText.paragraph.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme(context).onSurface,
              ),
            ),
          ],
        ),
        // Sub label (e.g. "3000₮x1")
        if (subLabel != null)
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              subLabel!,
              style: ThemeText.caption.copyWith(
                color: colorScheme(context).primary,
              ),
            ),
          ),
      ],
    );
  }
}
