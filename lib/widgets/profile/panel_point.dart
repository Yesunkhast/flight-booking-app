import 'package:flight_app/app/controller/user_controller.dart';
import 'package:flight_app/l10n/app_localizations.dart';
import 'package:flight_app/ui/themes/theme_palette.dart';
import 'package:flight_app/ui/themes/theme_shadow.dart';
import 'package:flutter/material.dart';
import 'package:flight_app/ui/themes/theme_radius.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/ui/themes/theme_text.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';

class PanelPoint extends StatelessWidget {
  const PanelPoint({super.key});

  @override
  Widget build(BuildContext context) {
    final userController = Get.find<UserController>();
    final localization = AppLocalizations.of(context)!;
    return Container(
      margin: EdgeInsets.only(
          top: spacingUnit(2), left: spacingUnit(2), right: spacingUnit(2)),
      decoration: BoxDecoration(
          color: colorScheme(context).surface,
          borderRadius: ThemeRadius.medium,
          boxShadow: [ThemeShade.shadeSoft(context)]),
      child: Padding(
        padding: EdgeInsets.all(spacingUnit(1)),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// USER LEVEL
              Padding(
                padding: EdgeInsets.only(right: spacingUnit(1)),
                child: const CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.amber,
                    child: Icon(Icons.wallet_giftcard,
                        size: 24, color: Colors.white)),
              ),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(localization.gold, style: ThemeText.subtitle2),
                      ClipRRect(
                        borderRadius: ThemeRadius.big,
                        child: LinearProgressIndicator(
                          value: 0.5,
                          backgroundColor: Colors.grey.withValues(alpha: 0.25),
                          color: Colors.amber,
                          minHeight: 10,
                          semanticsLabel: localization.levelProgressIndicator,
                        ),
                      )
                    ]),
              ),

              SizedBox(
                  height: 40,
                  width: 40,
                  child: VerticalDivider(
                      color: colorScheme(context).outline,
                      width: 20,
                      thickness: 2)),

              /// USER POINT
              Padding(
                padding: EdgeInsets.only(right: spacingUnit(1)),
                child: CircleAvatar(
                    radius: 20,
                    backgroundColor: colorScheme(context).primary,
                    child:
                        const Icon(Icons.star, size: 24, color: Colors.white)),
              ),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(userController.user.value?.point.toString() ?? '0',
                          style: ThemeText.subtitle2.copyWith(height: 1)),
                      Text(localization.yourPoint, style: ThemeText.paragraph),
                    ]),
              ),
            ]),
      ),
    );
  }
}
