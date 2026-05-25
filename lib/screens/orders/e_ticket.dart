import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flight_app/l10n/app_localizations.dart';
import 'package:flight_app/ui/themes/theme_text.dart';
import 'package:flight_app/widgets/booking/ticket_settings.dart';
import 'package:flight_app/widgets/cards/e_ticket_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:flight_app/ui/themes/theme_palette.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class ETicket extends StatefulWidget {
  const ETicket({super.key});

  @override
  State<ETicket> createState() => _ETicketState();
}

class _ETicketState extends State<ETicket> {
  final GlobalKey _screenshotKey = GlobalKey();

  Future<void> _saveTicket() async {
    try {
      // PopupMenu хаагдахыг хүлээнэ
      await Future.delayed(const Duration(milliseconds: 300));

      final boundary = _screenshotKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary?;

      if (boundary == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("'Алдаа', 'Дэлгэц олдсонгүй"),
            duration: const Duration(seconds: 2),
            backgroundColor: colorScheme(context).onPrimaryContainer,
          ),
        );
        return;
      }

      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("zurag uusgej chadsangui"),
            duration: const Duration(seconds: 2),
            backgroundColor: colorScheme(context).onPrimaryContainer,
          ),
        );
        return;
      }

      Uint8List bytes = byteData.buffer.asUint8List();

      final result = await ImageGallerySaverPlus.saveImage(
        bytes,
        quality: 100,
        name: "eticket_${DateTime.now().millisecondsSinceEpoch}",
      );

      if (result['isSuccess'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Амжилттай"),
            duration: const Duration(seconds: 2),
            backgroundColor: colorScheme(context).onPrimaryContainer,
          ),
        );
      }
    } catch (e) {
      print('Save error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Алдаа"),
          duration: const Duration(seconds: 2),
          backgroundColor: colorScheme(context).onPrimaryContainer,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
        actions: [
          TicketSettingsPopup(
            whiteIcon: true,
            onDownload: _saveTicket,
          ),
        ],
      ),
      body: Container(
        color: ThemePalette.primaryDark,
        padding: const EdgeInsets.all(10),
        child: Center(
          child: RepaintBoundary(
            key: _screenshotKey,
            child: ETicketCard(
              date: '12 May 2025 - 30 May 2025',
            ),
          ),
        ),
      ),
    );
  }
}
