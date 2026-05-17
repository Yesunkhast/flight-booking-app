import 'package:flight_app/l10n/app_localizations.dart';
import 'package:flight_app/models/realModel/order.dart';
import 'package:flight_app/ui/themes/theme_text.dart';
import 'package:flight_app/widgets/booking/ticket_settings.dart';
import 'package:flight_app/widgets/cards/e_order_ticket.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:flight_app/ui/themes/theme_palette.dart';

class EOrderTicket extends StatelessWidget {
  const EOrderTicket({super.key});

  @override
  Widget build(BuildContext context) {
    final order = Get.arguments as CreateOrderResponse;
    final locaization = AppLocalizations.of(context)!;
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            style: IconButton.styleFrom(
                backgroundColor: colorScheme(context).surface,
                elevation: 2,
                shadowColor: Colors.black),
            icon: const Icon(Icons.arrow_back_ios_new),
          ),
          title: Text(
            locaization.eTicket,
            style: ThemeText.subtitle.copyWith(color: Colors.white),
          ),
          centerTitle: true,
          actions: const [
            TicketSettingsPopup(
              whiteIcon: true,
            )
          ],
        ),
        body: Container(
          color: ThemePalette.primaryDark,
          padding: const EdgeInsets.all(10),
          child: Center(
            child: EOrderTicketCard(
              date: '12 May 2025 - 30 May 2025',
              order: order,
            ),
          ),
        ));
  }
}
