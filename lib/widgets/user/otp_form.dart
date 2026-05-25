import 'dart:async';

import 'package:flight_app/app/app_link.dart';
import 'package:flight_app/app/controller/auth_controller.dart';
import 'package:flight_app/l10n/app_localizations.dart';
import 'package:flight_app/ui/themes/theme_breakpoints.dart';
import 'package:flight_app/ui/themes/theme_palette.dart';
import 'package:flutter/material.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/route_manager.dart';
import 'package:flight_app/ui/themes/theme_button.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/ui/themes/theme_text.dart';
import 'package:pinput/pinput.dart';

class OtpForm extends StatefulWidget {
  const OtpForm({super.key});

  @override
  State<OtpForm> createState() => _OtpFormState();
}

class _OtpFormState extends State<OtpForm> {
  late final TextEditingController pinController;
  late final FocusNode focusNode;
  late final GlobalKey<FormState> formKey;
  final _authController = Get.find<AuthController>();

  Timer? timer;
  int seconds = 10; // hugtsaa uurhcluh 90second

  @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>();
    pinController = TextEditingController();
    focusNode = FocusNode();
    startTimer();
  }

  @override
  void dispose() {
    pinController.dispose();
    focusNode.dispose();
    timer?.cancel();
    super.dispose();
  }

  void _sendAgain() {
    startTimer();
  }

  void startTimer() {
    seconds = 30; // hugtsaa uurhcluh 90second
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (seconds > 0) {
        setState(() {
          seconds--;
        });
      } else {
        t.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final focusedBorderColor = Theme.of(context).colorScheme.primary;
    final fillColor = Theme.of(context).colorScheme.surface;
    final borderColor = Theme.of(context).colorScheme.outlineVariant;

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 22,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: borderColor),
      ),
    );

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: ThemeSize.xs),
      child: Column(
        children: [
          /// TITLE
          const VSpace(),
          Text(localization.checkYourPhone, style: ThemeText.title2),
          SizedBox(height: spacingUnit(1)),
          Text(localization.weHaveSentCode,
              style: ThemeText.headline
                  .copyWith(color: colorScheme(context).onSurfaceVariant)),
          const VSpace(),

          /// FORM
          Form(
            key: formKey,
            child: Column(
              children: [
                Directionality(
                  // Specify direction if desired
                  textDirection: TextDirection.ltr,
                  child: Pinput(
                    controller: pinController,
                    focusNode: focusNode,
                    defaultPinTheme: defaultPinTheme,
                    separatorBuilder: (index) => const SizedBox(width: 8),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      return value == '1254' ? null : localization.pinIncorrect;
                    },
                    onCompleted: (pin) {
                      debugPrint('onCompleted: $pin');
                    },
                    onChanged: (value) {
                      debugPrint('onChanged: $value');
                    },
                    cursor: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 9),
                          width: 22,
                          height: 1,
                          color: focusedBorderColor,
                        ),
                      ],
                    ),
                    focusedPinTheme: defaultPinTheme.copyWith(
                      decoration: defaultPinTheme.decoration!.copyWith(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: focusedBorderColor),
                      ),
                    ),
                    submittedPinTheme: defaultPinTheme.copyWith(
                      decoration: defaultPinTheme.decoration!.copyWith(
                        color: fillColor,
                        borderRadius: BorderRadius.circular(19),
                        border: Border.all(color: focusedBorderColor),
                      ),
                    ),
                    errorPinTheme: defaultPinTheme.copyBorderWith(
                      border: Border.all(color: Colors.redAccent),
                    ),
                  ),
                ),
                const VSpace(),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    style: ThemeButton.btnBig
                        .merge(ThemeButton.tonalPrimary(context)),
                    onPressed: _authController.isLoading.value
                        ? null
                        : () {
                            // _authController.verifyOtp();
                            focusNode.unfocus();
                            if (formKey.currentState!.validate()) {
                              Get.toNamed(AppLink.editPassword);
                            }
                          },
                    child: Text(localization.verify.toUpperCase()),
                  ),
                ),
                const VSpaceShort(),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    style: ThemeButton.btnBig,
                    onPressed: seconds == 0 ? _sendAgain : null,
                    child: Text(localization.sendAgain.toUpperCase()),
                  ),
                ),
                const SizedBox(height: 8),
                RichText(
                    text: TextSpan(
                        text: '${localization.pleaseWait} ! ',
                        style: ThemeText.paragraph
                            .copyWith(color: colorScheme(context).onSurface),
                        children: [
                      TextSpan(
                          text: ' $seconds sec',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(
                        text: ' ${localization.sendAgain.toLowerCase()}',
                      )
                    ]))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
