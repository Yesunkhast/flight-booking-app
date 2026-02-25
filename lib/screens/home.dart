import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/utils/custom_tooltip.dart';
import 'package:flight_app/widgets/bottom_nav/bottom_nav_menu.dart';
import 'package:flight_app/widgets/home/city_destinations/city_destinations_main.dart';
import 'package:flight_app/widgets/home/header.dart';
import 'package:flight_app/widgets/home/news_list.dart';
import 'package:flight_app/widgets/home/package_list_slider.dart';
import 'package:flight_app/widgets/home/partners_logo.dart';
import 'package:flight_app/widgets/home/promo_slider.dart';
import 'package:flight_app/widgets/home/search.dart';
import 'package:flight_app/widgets/home/flight_list_double.dart';
import 'package:flutter/material.dart';
import 'package:overlay_tooltip/overlay_tooltip.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ScrollController _scrollref = ScrollController();
  final TooltipController _tooltipRef = TooltipController();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  final String _key = 'finishedGuide';

  bool _isDoneGuide = false;
  bool _isFixed = false;

  void _checkFinishedGuide() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDoneGuide = prefs.getBool(_key) ?? false;
    });
  }

  @override
  void initState() {
    _tooltipRef.onDone(() async {
      SharedPreferences pref = await _prefs;
      pref.setBool(_key, true);
      setState(() {
        _isDoneGuide = true;
      });
    });

    _checkFinishedGuide();
    super.initState();
  }

  @override
  void dispose() {
    _tooltipRef.dispose();
    _scrollref.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _scrollref.addListener(() {
      setState(() {
        if(_scrollref.offset > 60) {
          _isFixed = true;
        } else {
          _isFixed = false;
        }
      });
    });

    return OverlayTooltipScaffold(
      overlayColor: Colors.black.withValues(alpha: 0.4),
      tooltipAnimationCurve: Curves.linear,
      tooltipAnimationDuration: const Duration(milliseconds: 1000),
      controller: _tooltipRef,
      startWhen: (initializedWidgetLength) async {
        await Future.delayed(const Duration(milliseconds: 500));
        return initializedWidgetLength == 1 && !_isDoneGuide;
      },
      builder: (context) => Scaffold(
        extendBodyBehindAppBar: true,
        extendBody: true,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: HomeHeader(isFixed: _isFixed),
        ),
        body: SingleChildScrollView(
          controller: _scrollref,
          child: Column(
            children: [
              const SearchHome(),
              const VSpace(),
              OverlayTooltipItem(
                displayIndex: 1,
                tooltip: (controller) => Padding(
                  padding: EdgeInsets.all(spacingUnit(1)),
                  child: MTooltip(title: 'Explore The Most Popular Places', controller: controller),
                ),
                child: const CityDestinations()
              ),
              const VSpace(),
              const PromoSlider(),
              const VSpaceBig(),
              const PackageListSlider(),
              const VSpaceBig(),
              const FlightListDouble(),
              const VSpace(),
              const NewsList(),
              const VSpace(),
              const PartnersLogo(),
              const SizedBox(height: 100,)
            ],
          ),
        ),
        bottomNavigationBar: const BottomNavMenu(),
      ),
    );
  }
}