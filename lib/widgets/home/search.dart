import 'package:flight_app/ui/themes/theme_breakpoints.dart';
import 'package:flight_app/ui/themes/theme_palette.dart';
import 'package:flight_app/ui/themes/theme_radius.dart';
import 'package:flight_app/ui/themes/theme_shadow.dart';
import 'package:flight_app/ui/themes/theme_text.dart';
import 'package:flight_app/utils/custom_tooltip.dart';
import 'package:flight_app/utils/expanded_section.dart';
import 'package:flight_app/widgets/app_button/tag_button.dart';
import 'package:flight_app/widgets/search_filter/search_flight_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/widgets/home/banner.dart';
import 'package:get/route_manager.dart';
import 'package:overlay_tooltip/overlay_tooltip.dart';

class SearchHome extends StatefulWidget {
  const SearchHome({super.key});

  @override
  State<SearchHome> createState() => _SearchHomeState();
}

class _SearchHomeState extends State<SearchHome> {
  bool _expand = false;
  bool _roundTrip = false;
  final bool _isDark = Get.isDarkMode;

  void _setExpand(bool value) {
    setState(() {
      _expand = value;
    });
  }

  void _setRoundTrip(bool value) {
    setState(() {
      _roundTrip = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.bottomCenter, children: [
      /// BANNER AND DECORATION
      const Positioned(top: 0, child: HomeBanner()),

      /// SEARCH BUTTON
      SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            SizedBox(height: ThemeBreakpoints.mdUp(context) ? 200 : 290),
            OverlayTooltipItem(
              displayIndex: 0,
              tooltip: (controller) => Padding(
                padding: const EdgeInsets.only(right: 15),
                child: MTooltip(
                    title: 'Search and Create Your Trip Plan',
                    controller: controller),
              ),
              child: Container(
                constraints: BoxConstraints(maxWidth: ThemeSize.sm),
                margin: EdgeInsets.all(spacingUnit(2)),
                decoration: BoxDecoration(
                    borderRadius: ThemeRadius.medium,
                    boxShadow: [ThemeShade.shadeMedium(context)],
                    color: _expand
                        ? colorScheme(context).surface
                        : colorScheme(context).primaryContainer),
                child: Column(
                  children: [
                    /// BUTTON
                    _expand
                        ? Padding(
                            padding: EdgeInsets.only(
                                left: spacingUnit(2),
                                right: spacingUnit(2),
                                top: spacingUnit(2)),
                            child: Row(children: [
                              TagButton(
                                  text: 'One Way',
                                  selected: !_roundTrip,
                                  onPressed: () {
                                    _setRoundTrip(false);
                                  }),
                              SizedBox(width: spacingUnit(1)),
                              TagButton(
                                  text: 'Round Trip',
                                  selected: _roundTrip,
                                  onPressed: () {
                                    _setRoundTrip(true);
                                  }),
                              const Spacer(),
                              SizedBox(
                                width: 32,
                                height: 32,
                                child: IconButton(
                                  icon: Icon(Icons.close,
                                      size: 18,
                                      color: colorScheme(context)
                                          .onSurfaceVariant),
                                  style: IconButton.styleFrom(
                                      padding: const EdgeInsets.all(4),
                                      backgroundColor:
                                          colorScheme(context).surfaceDim),
                                  onPressed: () {
                                    _setExpand(false);
                                  },
                                ),
                              )
                            ]))
                        : InkWell(
                            onTap: () {
                              _setExpand(true);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: spacingUnit(2),
                                  vertical: spacingUnit(1)),
                              child: Row(children: [
                                Icon(CupertinoIcons.airplane,
                                    color: colorScheme(context)
                                        .onPrimaryContainer),
                                SizedBox(width: spacingUnit(1)),
                                Expanded(
                                    child: Text(
                                  'Create New Booking',
                                  style: ThemeText.title2.copyWith(
                                      color: colorScheme(context)
                                          .onPrimaryContainer),
                                )),
                                Icon(CupertinoIcons.add_circled_solid,
                                    color: _isDark
                                        ? ThemePalette.secondaryMain
                                        : ThemePalette.primaryMain),
                              ]),
                            ),
                          ),

                    /// SEARCH FORM
                    ExpandedSection(
                        expand: _expand,
                        child: SearchFlightForm(
                          roundTrip: _roundTrip,
                        ))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ]);
  }
}
