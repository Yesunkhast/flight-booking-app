import 'package:flight_app/app/controller/flight_booking_controller.dart';
import 'package:flight_app/l10n/app_localizations.dart';
import 'package:flight_app/models/realModel/booking.dart';
import 'package:flight_app/ui/themes/theme_palette.dart';
import 'package:flight_app/ui/themes/theme_radius.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/ui/themes/theme_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:intl/intl.dart';

class TgqInfoWidget extends StatefulWidget {
  const TgqInfoWidget({
    super.key,
  });

  @override
  State<TgqInfoWidget> createState() => _TgqInfoWidgetState();
}

class _TgqInfoWidgetState extends State<TgqInfoWidget> {
  final bookingController = Get.find<BookingController>();
  bool _returnExpanded = true;
  bool _changeExpanded = true;
  List<TgqData> get tgqShowData => bookingController.tgqShowData;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    if (tgqShowData.isEmpty) return const SizedBox();

    final charges = tgqShowData.first.tgqPointCharges;
    if (charges.isEmpty) return const SizedBox();

    return Column(
      children: [
        // ── Return fee section ─────────────────────────────────────────
        _TgqSection(
          title: localization.refundFeePerTicket,
          expanded: _returnExpanded,
          onToggle: () => setState(() => _returnExpanded = !_returnExpanded),
          charges: charges,
          isReturn: true,
          context: context,
        ),

        SizedBox(height: spacingUnit(1)),

        // ── Change fee section ─────────────────────────────────────────
        _TgqSection(
          title: localization.changeFeePerTicket,
          expanded: _changeExpanded,
          onToggle: () => setState(() => _changeExpanded = !_changeExpanded),
          charges: charges,
          isReturn: false,
          context: context,
        ),
      ],
    );
  }
}

// ── Section widget ─────────────────────────────────────────────────────────────
class _TgqSection extends StatelessWidget {
  const _TgqSection({
    required this.title,
    required this.expanded,
    required this.onToggle,
    required this.charges,
    required this.isReturn,
    required this.context,
  });

  final String title;
  final bool expanded;
  final VoidCallback onToggle;
  final List<TgqPointCharge> charges;
  final bool isReturn;
  final BuildContext context;

  String _formatFee(String fee) {
    // handles both int-as-string and formatted strings
    final num = double.tryParse(fee.replaceAll(',', ''));
    if (num == null) return fee;
    final formatter = NumberFormat("#,###");
    return num < 100000
        ? '¥${formatter.format(num)}'
        : '${formatter.format(num)}₮';
  }

  @override
  Widget build(BuildContext ctx) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme(context).surface,
        borderRadius: ThemeRadius.medium,
        border: Border.all(color: colorScheme(context).outlineVariant),
      ),
      child: Column(
        children: [
          // ── Header ──────────────────────────────────────────────────
          InkWell(
            onTap: onToggle,
            borderRadius: ThemeRadius.medium,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: spacingUnit(2),
                vertical: spacingUnit(2),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: ThemeText.paragraph.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme(context).onSurface,
                      ),
                    ),
                  ),
                  Icon(
                    expanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: colorScheme(context).onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),

          // ── Charges grid ────────────────────────────────────────────
          if (expanded) ...[
            Divider(
              height: 1,
              color: colorScheme(context).outlineVariant,
            ),
            Padding(
              padding: EdgeInsets.all(spacingUnit(2)),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 2.2,
                ),
                itemCount: charges.length,
                itemBuilder: (context, index) {
                  final charge = charges[index];
                  final fee = isReturn ? charge.returnFee : charge.changeFee;

                  return _ChargeItem(
                    timeText: charge.timeText,
                    fee: _formatFee(fee),
                    context: context,
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ── Single charge item ─────────────────────────────────────────────────────────
class _ChargeItem extends StatelessWidget {
  const _ChargeItem({
    required this.timeText,
    required this.fee,
    required this.context,
  });

  final String timeText;
  final String fee;
  final BuildContext context;

  @override
  Widget build(BuildContext ctx) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Person icon ──────────────────────────────────────────────
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: colorScheme(context).surfaceContainerHighest,
            borderRadius: ThemeRadius.small,
          ),
          child: Icon(
            Icons.people_outline,
            size: 20,
            color: colorScheme(context).onSurfaceVariant,
          ),
        ),

        SizedBox(width: spacingUnit(1)),

        // ── Time + fee ───────────────────────────────────────────────
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                timeText,
                style: ThemeText.paragraph.copyWith(
                  color: colorScheme(context).onSurfaceVariant,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                fee,
                style: ThemeText.paragraph.copyWith(
                  color: colorScheme(context).primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
