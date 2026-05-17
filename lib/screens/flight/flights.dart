import 'package:flight_app/app/app_link.dart';
import 'package:flight_app/app/controller/flight_booking_controller.dart';
import 'package:flight_app/app/controller/flight_search_controller.dart';
import 'package:flight_app/app/controller/fligth_detail_controller.dart';
import 'package:flight_app/app/controller/user_controller.dart';
import 'package:flight_app/l10n/app_localizations.dart';
import 'package:flight_app/models/realModel/flight_detail.dart';
import 'package:flight_app/ui/themes/theme_palette.dart';
import 'package:flight_app/ui/themes/theme_radius.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/ui/themes/theme_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:intl/intl.dart';

class Flights extends StatefulWidget {
  const Flights({super.key});

  @override
  State<Flights> createState() => _FlightsState();
}

class _FlightsState extends State<Flights> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchData();
    });
  }

  final detailController = Get.find<FlightDetailController>();
  final searchController = Get.find<FlightSearchController>();
  // final bookingController = Get.find<BookingController>();
  final userController = Get.find<UserController>();
  Future<void> fetchData() async {
    if (searchController.domestic.value) {
      await detailController.getFlightPrice(
        dpt: searchController.fromCode.value,
        arr: searchController.toCode.value,
        date: searchController.dateFrom.value,
        adult: searchController.adults.value,
        child: searchController.children.value,
        flightNum: detailController.ext!.code,
        nctype: 'd',
      );
    } else if (searchController.roundTrip.value) {
      await detailController.getFlightPrice(
        dpt: searchController.fromCode.value,
        arr: searchController.toCode.value,
        date: searchController.dateFrom.value,
        backDate: searchController.dateTo.value,
        adult: searchController.adults.value,
        child: searchController.children.value,
        flightNum: detailController.ext!.code,
        type: 'rt',
        flightType: 'int',
        nctype: 'int',
      );
    } else {
      await detailController.getFlightPrice(
        dpt: searchController.fromCode.value,
        arr: searchController.toCode.value,
        date: searchController.dateFrom.value,
        adult: searchController.adults.value,
        child: searchController.children.value,
        flightNum: detailController.ext!.code,
        type: 'ow',
        flightType: 'int',
        nctype: 'int',
      );
    }
    print("fetch called: ${searchController.fromCode.value}");
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final detailController = Get.find<FlightDetailController>();

    return Obx(() {
      if (detailController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final vendors = detailController.flightDetail.value?.vendors;

      if (vendors == null || vendors.isEmpty) {
        return Center(child: Text(localization.flightIsNotAvailable));
      }

      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: vendors.length,
        itemBuilder: (context, index) {
          final flight = vendors[index];
          return FlightDetailItem(
            vendor: flight,
            onBook: () {
              // handle booking
              print(
                  'Booking URL: ${flight.bookingParamKey} + user is available: ${userController.userIsAvailable}');
              userController.userIsAvailable
                  ? Get.toNamed(AppLink.bookingStep1, arguments: flight)
                  : Get.toNamed(AppLink.login);
            },
          );
        },
      );
    });
  }
}

class FlightDetailItem extends StatelessWidget {
  const FlightDetailItem({super.key, required this.vendor, this.onBook});

  final Vendor vendor;
  final VoidCallback? onBook;

  String get _formattedPrice {
    final formatter = NumberFormat("#,###");
    return vendor.totalPrice < 100000
        ? '¥${formatter.format(vendor.totalPrice)}'
        : '${formatter.format(vendor.totalPrice)} ₮';
  }

  String get _formattedChildPrice {
    if (vendor.businessExtMap.childPrice == null) return '';
    final formatter = NumberFormat("#,###");
    return vendor.businessExtMap.childPrice! < 100000
        ? '¥${formatter.format(vendor.businessExtMap.childPrice!)}'
        : '${formatter.format(vendor.businessExtMap.childPrice!)} ₮';
  }

  bool get _refundable => vendor.tag.isNotEmpty;
  bool get _changeable => vendor.pType.isNotEmpty;
  bool get _hasLuggage => vendor.luggage.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: spacingUnit(2), vertical: spacingUnit(1)),
      decoration: BoxDecoration(
        color: colorScheme(context).surface,
        borderRadius: ThemeRadius.medium,
        border: Border.all(color: colorScheme(context).outlineVariant),
      ),
      child: Column(
        children: [
          // ── Main row ──────────────────────────────────────────────────────
          Padding(
            padding: EdgeInsets.all(spacingUnit(2)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Left: 4 info columns ──────────────────────────────────
                Expanded(
                  child: Wrap(
                    spacing: spacingUnit(2),
                    runSpacing: spacingUnit(1),
                    children: [
                      // Refund
                      _InfoColumn(
                        icon: FontAwesomeIcons.dollarSign,
                        label: localization.refund,
                        value: _refundable
                            ? vendor.tag
                            : localization.notAvailable,
                        valueColor: _refundable
                            ? colorScheme(context).primary
                            : colorScheme(context).onSurfaceVariant,
                        context: context,
                      ),

                      // Change
                      _InfoColumn(
                        icon: FontAwesomeIcons.planeDeparture,
                        label: localization.changeDate,
                        value: _changeable
                            ? localization.withFee
                            : localization.notAvailable,
                        valueColor: _changeable
                            ? colorScheme(context).primary
                            : colorScheme(context).onSurfaceVariant,
                        context: context,
                      ),

                      // Child price
                      _InfoColumn(
                        icon: FontAwesomeIcons.child,
                        label: localization.child,
                        value: vendor.businessExtMap.childPrice != null
                            ? _formattedChildPrice
                            : localization.notAvailable,
                        valueColor: vendor.businessExtMap.childPrice != null
                            ? colorScheme(context).primary
                            : colorScheme(context).onSurfaceVariant,
                        context: context,
                      ),

                      // Seat
                      _InfoColumn(
                        icon: FontAwesomeIcons.chair,
                        label: localization.seat,
                        value: vendor.cabinCount == 'A' ||
                                vendor.cabinCount == '0'
                            ? localization.manySeats
                            : '${vendor.cabinCount} ${localization.availableSeats.toLowerCase()}',
                        valueColor: colorScheme(context).primary,
                        context: context,
                      ),
                    ],
                  ),
                ),

                SizedBox(width: spacingUnit(1)),

                // ── Right: price + book button ────────────────────────────
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _formattedPrice,
                      style: ThemeText.subtitle.copyWith(
                        color: colorScheme(context).primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: spacingUnit(1)),
                    SizedBox(
                      width: 85,
                      child: FilledButton(
                        onPressed: onBook,
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFFD4006E),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 6),
                          shape: RoundedRectangleBorder(
                            borderRadius: ThemeRadius.small,
                          ),
                        ),
                        child: Text(
                          localization.book,
                          style: ThemeText.paragraph.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ── Luggage row (only if has luggage info) ────────────────────────
          if (_hasLuggage)
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                  horizontal: spacingUnit(2), vertical: spacingUnit(1)),
              decoration: BoxDecoration(
                color: colorScheme(context).surfaceContainerLowest,
                borderRadius: BorderRadius.only(
                  bottomLeft: ThemeRadius.medium.bottomLeft,
                  bottomRight: ThemeRadius.medium.bottomRight,
                ),
                border: Border(
                  top: BorderSide(color: colorScheme(context).outlineVariant),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    FontAwesomeIcons.suitcaseRolling,
                    size: 15,
                    color: colorScheme(context).onSurfaceVariant,
                  ),
                  SizedBox(width: spacingUnit(1)),
                  Expanded(
                    child: Text(
                      vendor.luggage,
                      style: ThemeText.paragraph.copyWith(
                        color: colorScheme(context).onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// ── Info column widget ─────────────────────────────────────────────────────────
class _InfoColumn extends StatelessWidget {
  const _InfoColumn({
    required this.icon,
    required this.label,
    required this.value,
    required this.valueColor,
    required this.context,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color valueColor;
  final BuildContext context;

  @override
  Widget build(BuildContext ctx) {
    return SizedBox(
      width: 110,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Icon(icon,
                size: 15, color: colorScheme(context).onSurfaceVariant),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: ThemeText.paragraph.copyWith(
                    color: colorScheme(context).onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  value,
                  style: ThemeText.paragraph.copyWith(color: valueColor),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
