import 'package:flight_app/app/app_link.dart';
import 'package:flight_app/app/constants/img_api.dart';
import 'package:flight_app/l10n/app_localizations.dart';
import 'package:flight_app/ui/themes/theme_text.dart';
import 'package:flight_app/utils/no_data.dart';
import 'package:flight_app/widgets/app_button/back_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class FlightNotFound extends StatelessWidget {
  const FlightNotFound({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return Center(
      child: NoData(
        image: ImgApi.emptyNotFound,
        title: localization.notFound,
        desc: localization.flightNotFoundOrCheckInternet,
        primaryAction: () {
          Get.toNamed(AppLink.flightList);
        },
        primaryTxtBtn: localization.searchAnotherDestination,
        secondaryAction: () {
          Get.toNamed(AppLink.home);
        },
        secondaryTxtBtn: localization.backToHome,
      ),
    );
  }
}
