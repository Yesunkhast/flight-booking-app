import 'package:flight_app/constants/img_api.dart';
import 'package:flutter/material.dart';
import 'package:flight_app/ui/themes/theme_palette.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';

class AuthWrap extends StatelessWidget {
  const AuthWrap({super.key, required this.content});

  final Widget content;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ThemePalette.primaryMain
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.05),
          image: DecorationImage(image: AssetImage(ImgApi.welcomeBg), fit: BoxFit.cover )
        ),
        child: Container(
          margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top + spacingUnit(5)),
          padding: EdgeInsets.symmetric(horizontal: spacingUnit(2)),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
            color: Theme.of(context).colorScheme.surface,
          ),
          child: Center(child: content)
        ),
      ),
    );
  }
}