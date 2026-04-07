import 'package:flight_app/app/app_link.dart';
import 'package:flight_app/l10n/app_localizations.dart';
import 'package:flight_app/ui/themes/theme_radius.dart';
import 'package:flight_app/ui/themes/theme_text.dart';
// import 'package:flight_app/utils/custom_tooltip.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:flight_app/ui/themes/theme_palette.dart';
// import 'package:overlay_tooltip/overlay_tooltip.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class BottomNavMenu extends StatelessWidget {
  const BottomNavMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    String currentRoute = Get.currentRoute;

    return BottomAppBar(
        elevation: 20,
        shadowColor: Colors.black,
        height: 70,
        color: Theme.of(context).colorScheme.secondary,
        padding: const EdgeInsets.all(0),
        child: LayoutBuilder(builder: (context, constraints) {
          return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                MenuItem(
                    title: localizations.home,
                    icon: Icons.home,
                    isActive: currentRoute == AppLink.home,
                    onTap: () {
                      Get.toNamed(AppLink.home);
                    }),
                // MenuItem(
                //     title: localizations.news,
                //     icon: CupertinoIcons.location_fill,
                //     isActive: currentRoute == AppLink.explore,
                //     onTap: () {
                //       Get.toNamed(AppLink.explore);
                //     }),
                MenuItem(
                    // title: "News",
                    title: localizations.news,
                    icon: CupertinoIcons.tags_solid,
                    isActive: currentRoute == AppLink.promo,
                    onTap: () {
                      Get.toNamed(AppLink.promo);
                    }),
                // OverlayTooltipItem(
                //   displayIndex: 3,
                //   tooltip: (controller) => Padding(
                //     padding: const EdgeInsets.only(right: 15),
                //     child: MTooltip(
                //         title:
                //             'Your scheduled booking tiket will be listed here.',
                //         controller: controller),
                //   ),
                //   tooltipVerticalPosition: TooltipVerticalPosition.TOP,
                //   tooltipHorizontalPosition: TooltipHorizontalPosition.CENTER,
                //   child: Container(
                //     decoration: BoxDecoration(
                //         shape: BoxShape.circle,
                //         color: colorScheme(context).surface),
                //     child: MenuItem(
                //         title: localizations.orders,
                //         icon: CupertinoIcons.tickets_fill,
                //         isActive: currentRoute == AppLink.myTicket,
                //         onTap: () {
                //           Get.toNamed(AppLink.myTicket);
                //         }),
                //   ),
                // ),
                MenuItem(
                    title: localizations.orders,
                    icon: CupertinoIcons.tickets_fill,
                    isActive: currentRoute == AppLink.myTicket,
                    onTap: () {
                      Get.toNamed(AppLink.myTicket);
                    }),
                MenuItem(
                    title: localizations.profile,
                    icon: CupertinoIcons.person_fill,
                    isActive: currentRoute == AppLink.profile,
                    onTap: () => Get.toNamed(AppLink.profile)),
              ]);
        }));
  }
}

class MenuItem extends StatelessWidget {
  const MenuItem({
    super.key,
    required this.icon,
    required this.title,
    this.isActive = false,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final bool isActive;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return ZoomTapAnimation(
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: () => {onTap()},
        child: SizedBox(
          width: 60,
          height: 50,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(icon,
                    color: isActive
                        ? ThemePalette.primaryMain
                        : ThemePalette.primaryLight),
                Text(title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: isActive
                            ? ThemePalette.primaryMain
                            : ThemePalette.primaryLight,
                        fontSize: ThemeText.caption.fontSize,
                        fontWeight: ThemeText.caption.fontWeight,
                        fontFamily: ThemeText.caption.fontFamily)),
                isActive
                    ? Container(
                        width: 6,
                        height: 6,
                        margin: const EdgeInsets.only(top: 2),
                        decoration: BoxDecoration(
                            borderRadius: ThemeRadius.big,
                            color: ThemePalette.primaryMain),
                      )
                    : Container()
              ]),
        ),
      ),
    );
  }
}
