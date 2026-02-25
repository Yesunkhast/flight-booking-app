import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flight_app/widgets/bottom_nav/bottom_nav_menu.dart';

class HomeLayout extends StatelessWidget {
  const HomeLayout({super.key, required this.content});

  final Widget content;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: Theme.of(context).brightness == Brightness.dark
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
      child: Scaffold(
        extendBody: true,
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 1024,
              minHeight: 480
            ),
            child: content
          ),
        ),
        bottomNavigationBar: const BottomNavMenu(),
      ),
    );
  }
}