import 'package:flight_app/app/controller/flight_booking_controller.dart';
import 'package:flight_app/app/controller/flight_search_controller.dart';
import 'package:flight_app/l10n/app_localizations.dart';
import 'package:flight_app/models/realModel/booking.dart';
import 'package:flight_app/ui/themes/theme_palette.dart';
import 'package:flight_app/ui/themes/theme_radius.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/ui/themes/theme_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class BaggageInfo extends StatelessWidget {
  const BaggageInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final bookingController = Get.find<BookingController>();
    final searchController = Get.find<FlightSearchController>();
    final isRoundTrip = searchController.roundTrip.value;

    return Obx(() {
      final result = bookingController.bookingResult.value;
      if (result == null) return const SizedBox();
      if (result.baggageRuleInfos.isEmpty) return const SizedBox();

      final flightSegments = result.flightInfo;

      return Column(
        children: [
          if (!isRoundTrip || flightSegments.length == 1)
            _BaggageCard(
              dpt: flightSegments.first.dpt,
              arr: flightSegments.last.arr,
              flightNum: flightSegments.first.flightNum,
              baggage: result.baggageRuleInfos.first,
            ),
          if (isRoundTrip && flightSegments.length >= 2)
            Row(
              children: [
                Expanded(
                  child: _BaggageCard(
                    dpt: flightSegments.first.dpt,
                    arr: flightSegments.first.arr,
                    flightNum: flightSegments.first.flightNum,
                    baggage: result.baggageRuleInfos.length > 0
                        ? result.baggageRuleInfos[0]
                        : null,
                  ),
                ),
                SizedBox(width: spacingUnit(1)),
                Expanded(
                  child: _BaggageCard(
                    dpt: flightSegments.last.dpt,
                    arr: flightSegments.last.arr,
                    flightNum: flightSegments.last.flightNum,
                    baggage: result.baggageRuleInfos.length > 1
                        ? result.baggageRuleInfos[1]
                        : result.baggageRuleInfos.first,
                  ),
                ),
              ],
            ),
        ],
      );
    });
  }
}

// ── Single baggage card ────────────────────────────────────────────────────────
class _BaggageCard extends StatelessWidget {
  const _BaggageCard({
    required this.dpt,
    required this.arr,
    required this.flightNum,
    required this.baggage,
  });

  final String dpt;
  final String arr;
  final String flightNum;
  final BaggageRule? baggage;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    if (baggage == null) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ✈️ Header
        Row(
          children: [
            Icon(
              Icons.flight,
              size: 14,
              color: colorScheme(context).primary,
            ),
            const SizedBox(width: 4),
            Text(
              '$dpt → $arr',
              style: ThemeText.paragraphBold.copyWith(
                color: colorScheme(context).onSurface,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              '($flightNum)',
              style: ThemeText.caption.copyWith(
                color: colorScheme(context).onSurfaceVariant,
              ),
            ),
          ],
        ),

        SizedBox(height: spacingUnit(2)),

        // 🎒 Baggage list
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (baggage!.cabinBaggageRule.isNotEmpty)
              _BaggageItem(
                icon: FontAwesomeIcons.briefcase,
                label: localization.carryOn,
                value: baggage!.cabinBaggageRule,
              ),
            if (baggage!.cabinBaggageRule.isNotEmpty &&
                baggage!.checkedBaggageRule.isNotEmpty)
              SizedBox(height: spacingUnit(1)),
            if (baggage!.checkedBaggageRule.isNotEmpty)
              _BaggageItem(
                icon: FontAwesomeIcons.suitcaseRolling,
                label: localization.checkedBaggage,
                value: baggage!.checkedBaggageRule,
              ),
            if (baggage!.infantBaggageRule.isNotEmpty) ...[
              SizedBox(height: spacingUnit(1)),
              _BaggageItem(
                icon: FontAwesomeIcons.baby,
                label: localization.infantBaggage,
                value: baggage!.infantBaggageRule,
              ),
            ],
          ],
        ),
      ],
    );
  }
}

// ── Single baggage item (icon + label + value) ────────────────────────────────
class _BaggageItem extends StatelessWidget {
  const _BaggageItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(spacingUnit(1) + 2),
      decoration: BoxDecoration(
        color: colorScheme(context).primaryContainer.withValues(alpha: 0.4),
        borderRadius: ThemeRadius.small,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: colorScheme(context).primary),
              const SizedBox(width: 6),
              Text(
                label,
                style: ThemeText.paragraph.copyWith(
                  color: colorScheme(context).primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: spacingUnit(1)),
          Text(
            value,
            style: ThemeText.paragraph.copyWith(
              color: colorScheme(context).onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
