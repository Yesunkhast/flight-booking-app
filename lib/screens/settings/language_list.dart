import 'package:flight_app/app/app_link.dart';
import 'package:flight_app/app/service.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LanguageList extends StatelessWidget {
  const LanguageList({super.key});

  @override
  Widget build(BuildContext context) {
    final localizationService = Get.find<LocalizationService>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Language'),
        centerTitle: true,
      ),
      body: ListView(
        children: List.generate(
          localizationService.supportedLocales.length,
          (index) {
            final localName = localizationService.supportedLocalesName[index];
            final local = localizationService.supportedLocales[index];

            return Column(
              children: [
                ListTile(
                  title: Text(localName),
                  onTap: () async {
                    await localizationService.changeLocale(local);
                    Get.toNamed(AppLink.home);
                  },
                ),
                const LineList(),
              ],
            );
          },
        ),
      ),
    );
  }
}
