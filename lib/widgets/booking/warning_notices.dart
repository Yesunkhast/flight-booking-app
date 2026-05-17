import 'package:flight_app/l10n/app_localizations.dart';
import 'package:flight_app/ui/themes/theme_palette.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/ui/themes/theme_text.dart';
import 'package:flutter/material.dart';

class WarningNotice extends StatelessWidget {
  const WarningNotice({
    super.key,
    this.notices,
  });

  final List<String>? notices;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    List<String> defaultNotices = [
      localization.warningPassportResponsibility,
      localization.warningTransitFlight,
      localization.warningArrivalTime,
      localization.warningScheduleChanges,
      localization.warningFlightChanges,
    ];
    // final items = notices ?? _defaultNotices;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Title ───────────────────────────────────────────────────
        Row(
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: Color(0xFFF9A825),
              size: 30,
            ),
            SizedBox(width: spacingUnit(1)),
            Text(
              localization.warningTitle,
              style: ThemeText.paragraph.copyWith(
                color: const Color(0xFFF9A825),
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),

        SizedBox(height: spacingUnit(2)),
        Divider(color: colorScheme(context).outlineVariant, height: 1),
        SizedBox(height: spacingUnit(2)),

        // ── Notice items ─────────────────────────────────────────────
        ...defaultNotices.map(
          (notice) => Padding(
            padding: EdgeInsets.only(bottom: spacingUnit(2)),
            child: Text(
              notice,
              style: ThemeText.paragraph.copyWith(
                color: colorScheme(context).onSurface,
                height: 1.6,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
