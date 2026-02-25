import 'package:flight_app/ui/themes/theme_text.dart';
import 'package:flight_app/widgets/booking/ticket_settings.dart';
import 'package:flight_app/widgets/cards/e_ticket_card.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:flight_app/ui/themes/theme_palette.dart';

class ETicket extends StatelessWidget {
  const ETicket({super.key});

  @override
  Widget build(BuildContext context) {
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
            shadowColor: Colors.black
          ),
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        title: Text('E-Ticket', style: ThemeText.subtitle.copyWith(color: Colors.white),),
        centerTitle: true,
        actions: const [
          TicketSettingsPopup(whiteIcon: true,)
        ],
      ),
      body: Container(
        color: ThemePalette.primaryDark,
        padding: const EdgeInsets.all(10),
        child: const Center(
          child: ETicketCard(
            date: '12 May 2025 - 30 May 2025',
          ),
        ),
      )
    );
  }
}