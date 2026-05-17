import 'package:flight_app/app/controller/flight_booking_controller.dart';
import 'package:flight_app/app/controller/passenger_controller.dart';
import 'package:flight_app/l10n/app_localizations.dart';
import 'package:flight_app/models/realModel/passenger.dart';
import 'package:flight_app/ui/themes/theme_breakpoints.dart';
import 'package:flight_app/ui/themes/theme_button.dart';
import 'package:flight_app/ui/themes/theme_palette.dart';
import 'package:flight_app/ui/themes/theme_radius.dart';
import 'package:flight_app/ui/themes/theme_shadow.dart';
import 'package:flight_app/ui/themes/theme_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/route_manager.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
// import 'package:get/utils.dart';
import 'package:markdown_widget/markdown_widget.dart';

class CheckoutTermsCondition extends StatelessWidget {
  const CheckoutTermsCondition({
    super.key,
  });

  // final List<Passenger> passengers;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final passengerController = Get.find<PassengerController>();
    final bookingController = Get.find<BookingController>();
    print(
        "booked passengers:${passengerController.bookingPassengers.value.first}");
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: ThemeSize.md),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(spacingUnit(2)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const VSpace(),
                    // ── Page title ──────────────────────────────────────
                    Center(
                      child: Text(
                        localization.checkInfo,
                        style: ThemeText.subtitle.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: spacingUnit(2)),

                    // ── Warning box ─────────────────────────────────────
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(spacingUnit(2)),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF8E1),
                        borderRadius: ThemeRadius.small,
                        border: Border.all(
                          color: const Color(0xFFFFE082),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.warning_amber_rounded,
                            color: Color(0xFFF9A825),
                            size: 30,
                          ),
                          SizedBox(width: spacingUnit(1)),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  localization.warning,
                                  style: ThemeText.paragraphBold.copyWith(
                                    color: const Color(0xFFF9A825),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                RichText(
                                  text: TextSpan(
                                    style: ThemeText.paragraph.copyWith(
                                      color: const Color(0xFF7B3F00),
                                    ),
                                    children: [
                                      TextSpan(
                                          text:
                                              "${localization.passportInfo} "),
                                      TextSpan(
                                        text: "${localization.passportFields} ",
                                        style: ThemeText.paragraph.copyWith(
                                          color: const Color(0xFF7B3F00),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextSpan(
                                          text: localization.warningInvalid),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: spacingUnit(3)),

                    // ── Passenger table title ───────────────────────────
                    Text(
                      localization.passengerInfo,
                      style: ThemeText.paragraph.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: spacingUnit(1)),

                    Divider(color: Theme.of(context).colorScheme.onPrimary),
                    // ── Passenger table ─────────────────────────────────
                    _PassengerTable(
                      passengers: passengerController.bookingPassengers,
                      context: context,
                    ),

                    Divider(color: Theme.of(context).colorScheme.onPrimary),

                    SizedBox(height: spacingUnit(3)),

                    // ── Terms title ─────────────────────────────────────
                    Center(
                      child: Text(
                        localization.flightTermsTitle,
                        style: ThemeText.subtitle2.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    // SizedBox(height: spacingUnit(2)),

                    // ── Terms markdown ──────────────────────────────────
                    buildMarkdown(localization.checkoutTerms),
                  ],
                ),
              ),
            ),

            // ── Agree button ────────────────────────────────────────────
            Container(
              padding: EdgeInsets.symmetric(horizontal: spacingUnit(2)),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerLow,
                boxShadow: [ThemeShade.shadeMedium(context)],
              ),
              height: 90,
              child: Center(
                child: Container(
                  constraints: BoxConstraints(maxWidth: ThemeSize.sm),
                  height: 50,
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () =>
                        {bookingController.isAccepted.value = true, Get.back()},
                    style: ThemeButton.btnBig
                        .merge(ThemeButton.outlinedInvert(context)),
                    child: Text(
                      localization.agreeTerms,
                      style: ThemeText.subtitle2,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMarkdown(dynamic data) => MarkdownWidget(
        data: data,
        shrinkWrap: true,
        selectable: true,
        config: MarkdownConfig(
          configs: [
            H1Config(style: const TextStyle(fontSize: 24)),
            LinkConfig(onTap: (url) => debugPrint('url: $url')),
          ],
        ),
      );
}

// // ── Passenger table ────────────────────────────────────────────────────────────

class _PassengerTable extends StatelessWidget {
  const _PassengerTable({
    required this.passengers,
    required this.context,
  });

  final List<Passenger> passengers;
  final BuildContext context;

  @override
  Widget build(BuildContext ctx) {
    final l = AppLocalizations.of(context)!;

    return Column(
      children: passengers.asMap().entries.map((entry) {
        final i = entry.key;
        final p = entry.value;

        return Container(
          margin: EdgeInsets.only(bottom: spacingUnit(2)),
          decoration: BoxDecoration(
            color: colorScheme(context).surface,
            borderRadius: ThemeRadius.medium,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(
              color: colorScheme(context).outlineVariant.withOpacity(0.3),
            ),
          ),
          child: Column(
            children: [
              // ── Header ─────────────────────────────
              Container(
                padding: EdgeInsets.all(spacingUnit(2)),
                decoration: BoxDecoration(
                  color: colorScheme(context).primaryContainer,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(ThemeRadius.medium.topLeft.x),
                  ),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 14,
                      backgroundColor: colorScheme(context).primary,
                      child: Text(
                        '${i + 1}',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                    SizedBox(width: spacingUnit(1)),
                    Text(
                      l.passenger,
                      style: ThemeText.subtitle.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme(context).onPrimaryContainer,
                      ),
                    ),
                    const Spacer(),

                    // Gender chip
                    _GenderChip(
                      gender: p.gender,
                      context: context,
                    ),
                  ],
                ),
              ),

              // ── Body ─────────────────────────────
              Padding(
                padding: EdgeInsets.all(spacingUnit(2)),
                child: Column(
                  children: [
                    _InfoRow(l.passport, p.idcard),
                    _Divider(),
                    _InfoRow(l.lastName, p.lastname.toUpperCase()),
                    _Divider(),
                    _InfoRow(l.firstName, p.firstname.toUpperCase()),
                    _Divider(),
                    _InfoRow(l.dateOfBirth, p.birthday),
                    _Divider(),
                    _InfoRow(l.expiryDate, p.passportvaliddate),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: spacingUnit(1)),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: ThemeText.paragraph.copyWith(
                color: colorScheme(context).onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: ThemeText.paragraph.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme(context).onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 0.6,
      color: colorScheme(context).outlineVariant.withOpacity(0.3),
    );
  }
}

class _GenderChip extends StatelessWidget {
  const _GenderChip({
    required this.gender,
    required this.context,
  });

  final String gender;
  final BuildContext context;

  @override
  Widget build(BuildContext ctx) {
    final l = AppLocalizations.of(context)!;
    final isMale = gender == 'M';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isMale
            ? Colors.blue.withOpacity(0.1)
            : Colors.pink.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        isMale ? l.male : l.female,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: isMale ? Colors.blue : Colors.pink,
        ),
      ),
    );
  }
}
// class _PassengerTable extends StatelessWidget {
//   const _PassengerTable({
//     required this.passengers,
//     required this.context,
//   });

//   final List<Passenger> passengers;
//   final BuildContext context;

//   @override
//   Widget build(BuildContext ctx) {
//     final localization = AppLocalizations.of(context)!;
//     return Container(
//       decoration: BoxDecoration(
//         border: Border.all(color: colorScheme(context).outlineVariant),
//         borderRadius: ThemeRadius.small,
//       ),
//       child: Column(
//         children: [
//           // ── Header row ─────────────────────────────────────────────
//           Container(
//             padding: EdgeInsets.symmetric(
//               horizontal: spacingUnit(1),
//               vertical: spacingUnit(1),
//             ),
//             decoration: BoxDecoration(
//               color: colorScheme(context).surfaceContainerLowest,
//               borderRadius: const BorderRadius.only(
//                 topLeft: Radius.circular(8),
//                 topRight: Radius.circular(8),
//               ),
//             ),
//             child: Column(
//               children: [
//                 _HeaderCell('№', flex: 1, context: context),
//                 _HeaderCell(localization.passport, flex: 3, context: context),
//                 _HeaderCell(localization.lastName, flex: 3, context: context),
//                 _HeaderCell(localization.firstName, flex: 3, context: context),
//                 _HeaderCell(localization.dateOfBirth,
//                     flex: 3, context: context),
//                 _HeaderCell(localization.passportValidDate,
//                     flex: 3, context: context),
//                 _HeaderCell(localization.gender, flex: 2, context: context),
//               ],
//             ),
//           ),

//           Divider(height: 1, color: colorScheme(context).outlineVariant),

//           // ── Data rows ──────────────────────────────────────────────
//           ...passengers.asMap().entries.map((entry) {
//             final i = entry.key;
//             final p = entry.value;
//             return Row(
//               children: [
//                 Container(
//                   padding: EdgeInsets.symmetric(
//                     horizontal: spacingUnit(1),
//                     vertical: spacingUnit(1) + 2,
//                   ),
//                   child: Column(
//                     children: [
//                       _DataCell('${i + 1}', flex: 1, context: context),
//                       _DataCell(p.idCard, flex: 3, context: context),
//                       _DataCell(p.lastName.toUpperCase(),
//                           flex: 3, context: context),
//                       _DataCell(p.firstName.toUpperCase(),
//                           flex: 3, context: context),
//                       _DataCell(p.birthday, flex: 3, context: context),
//                       _DataCell(p.passportValidDate, flex: 3, context: context),
//                       _DataCell(
//                         p.gender == 'M' ? 'Эрэгтэй' : 'Эмэгтэй',
//                         flex: 2,
//                         context: context,
//                       ),
//                     ],
//                   ),
//                 ),
//                 if (i < passengers.length - 1)
//                   Divider(
//                       height: 1, color: colorScheme(context).outlineVariant),
//               ],
//             );
//           }),
//         ],
//       ),
//     );
//   }
// }

// // ── Table cells ────────────────────────────────────────────────────────────────
// class _HeaderCell extends StatelessWidget {
//   const _HeaderCell(this.text, {required this.flex, required this.context});
//   final String text;
//   final int flex;
//   final BuildContext context;

//   @override
//   Widget build(BuildContext ctx) {
//     return Expanded(
//       flex: flex,
//       child: Text(
//         text,
//         style: ThemeText.caption.copyWith(
//           color: colorScheme(context).primary,
//           fontWeight: FontWeight.w600,
//         ),
//       ),
//     );
//   }
// }

// class _DataCell extends StatelessWidget {
//   const _DataCell(this.text, {required this.flex, required this.context});
//   final String text;
//   final int flex;
//   final BuildContext context;

//   @override
//   Widget build(BuildContext ctx) {
//     return Expanded(
//       flex: flex,
//       child: Text(
//         text,
//         style: ThemeText.caption.copyWith(
//           color: colorScheme(context).onSurface,
//         ),
//         overflow: TextOverflow.ellipsis,
//       ),
//     );
//   }
// }
