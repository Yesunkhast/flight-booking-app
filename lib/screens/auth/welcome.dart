import 'package:flight_app/constants/img_api.dart';
import 'package:flight_app/ui/themes/theme_breakpoints.dart';
import 'package:flight_app/widgets/app_button/back_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flight_app/constants/app_const.dart';
import 'package:flight_app/ui/themes/theme_button.dart';
import 'package:flight_app/ui/themes/theme_palette.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/ui/themes/theme_text.dart';
import 'package:flight_app/widgets/user/auth_options.dart';
import 'package:get/get.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  bool _openAuthOpt = false;

  void _showModal(Widget content) {
    Future<void> future = showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return content;
      },
    );
    future.then((void value) => _closeModal(value));
  }

  void _closeModal(void value) {
    setState(() {
      _openAuthOpt = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: BackIconButton(onTap: () {
          Get.back();
        }),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: ThemePalette.primaryMain
        ),
        child: Container(
          padding: EdgeInsets.all(spacingUnit(3)),
          decoration: BoxDecoration(
            color: colorScheme(context).surface.withValues(alpha: 0.1),
            image: DecorationImage(image: AssetImage(ImgApi.welcomeBg), fit: BoxFit.cover )
          ),
          child: Align(
            alignment: Alignment.center,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: ThemeSize.sm
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
              
                /// TEXT
                Text('Welcome to ${branding.name}', style: const TextStyle(fontSize: 48, color: Colors.white, fontWeight: FontWeight.bold)),
                const VSpaceShort(),
                Text(branding.title, style: ThemeText.title2.copyWith(color: Colors.white, fontWeight: FontWeight.normal)),
                const VSpaceBig(),
              
                /// BUTTONS
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: FilledButton(
                    onPressed: () {
                      setState(() {
                        _openAuthOpt = true;
                      });
                      _showModal(const Wrap(
                        children: [
                          AuthOptions()
                        ],
                      ));
                    },
                    style: ThemeButton.btnBig.merge(ThemeButton.black),
                    child: const Text('REGISTER', style: ThemeText.title2)
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: spacingUnit(3)),
                  child: const Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                    Expanded(child: LineList()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text('Already have account?', style: TextStyle(fontSize: 18, color: Colors.white)),
                    ),
                    Expanded(child: LineList()),
                  ])
                ),
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _openAuthOpt = true;
                      });
                      _showModal(const Wrap(
                        children: [
                          AuthOptions(isLogin: true,)
                        ],
                      ));
                    },
                    style: ThemeButton.btnBig.merge(ThemeButton.outlinedWhite()),
                    child: const Text('LOGIN', style: ThemeText.title2)
                  ),
                ),
                const VSpaceBig(),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: _openAuthOpt ? 200 : 0,
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
