import 'package:flight_app/app/app_link.dart';
import 'package:flight_app/app/controller/user_controller.dart';
import 'package:flight_app/l10n/app_localizations.dart';
import 'package:flight_app/ui/themes/theme_radius.dart';
import 'package:flutter/material.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/route_manager.dart';
import 'package:flight_app/app/constants/app_const.dart';
import 'package:flight_app/ui/themes/theme_button.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/ui/themes/theme_text.dart';
import 'package:flight_app/utils/grabber_icon.dart';

class AccountInfo extends StatelessWidget {
  const AccountInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final userController = Get.find<UserController>();
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      const GrabberIcon(),
      const VSpace(),
      Text(localization.accountInfo,
          style: ThemeText.title2.copyWith(fontWeight: FontWeight.bold)),
      const VSpaceShort(),

      /// ACCOUNT INFO
      SizedBox(
        height: 400,
        child: Padding(
            padding: EdgeInsets.all(spacingUnit(2)),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(children: [
                    Text(localization.name,
                        style: ThemeText.subtitle
                            .copyWith(fontWeight: FontWeight.bold)),
                    const Spacer(),
                    Text(userController.user.value?.lastName ?? 'Guest'),
                  ]),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: spacingUnit(2)),
                    child: const LineList(),
                  ),
                  Row(children: [
                    Text(localization.email,
                        style: ThemeText.subtitle
                            .copyWith(fontWeight: FontWeight.bold)),
                    const Spacer(),
                    Text(userController.user.value?.email ?? 'guest@mail.com'),
                  ]),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: spacingUnit(2)),
                    child: const LineList(),
                  ),
                  Row(children: [
                    Text(localization.phoneNumber,
                        style: ThemeText.subtitle
                            .copyWith(fontWeight: FontWeight.bold)),
                    const Spacer(),
                    Text(userController.user.value?.phone ?? '+12345678'),
                  ]),
                  const VSpaceBig(),
                  SizedBox(
                    width: 250,
                    height: 40,
                    child: OutlinedButton(
                        onPressed: () {
                          Get.toNamed(AppLink.editProfile);
                        },
                        style: ThemeButton.outlinedPrimary(context),
                        child: Text(localization.editProfile,
                            style: ThemeText.subtitle)),
                  ),
                  const VSpaceShort(),
                  SizedBox(
                    width: 250,
                    height: 40,
                    child: OutlinedButton(
                        onPressed: () {
                          Get.toNamed(AppLink.editPassword);
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.red.shade300),
                          foregroundColor: Colors.red.shade300,
                          shape: RoundedRectangleBorder(
                            borderRadius: ThemeRadius.medium,
                          ),
                        ),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.lock, color: Colors.red.shade300),
                              Text(localization.changePassword,
                                  style: ThemeText.subtitle),
                            ])),
                  ),
                  const VSpaceBig(),
                ])),
      ),
    ]);
  }
}
