import 'package:flight_app/widgets/explore/airport_list_slider.dart';
import 'package:flight_app/widgets/explore/promo_list_slider.dart';
import 'package:flight_app/widgets/home/flight_list_slider.dart';
import 'package:flight_app/widgets/home/package_list_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:flight_app/widgets/explore/ads.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/widgets/explore/banner.dart';
import 'package:flight_app/widgets/explore/header.dart';
import 'package:flight_app/widgets/explore/search.dart';

class ExploreMain extends StatelessWidget {
  const ExploreMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: Stack(
            alignment: Alignment.topCenter,
            children: [
              /// BANNER ILLLUSTRATION
              BannerExplore(),
              /// HEADER
              Positioned(
                left: spacingUnit(1),
                right: spacingUnit(1),
                top: MediaQuery.of(context).padding.top,
                child: SizedBox(child: HeaderExplore())
              ),
            ],
          )),
          /// MINI MAP
          SliverStickyHeader.builder(
            builder: (context, state) {
              /// SEARCH
              return const SearchExplore();
            },
            /// PROMO AND EVENT LIST
            sliver: SliverList(delegate: SliverChildListDelegate([
              const VSpace(),
              const PackageListSlider(),
              const VSpaceBig(),
              const PromoListSlider(),
              const AdsFood(),
              const VSpaceBig(),
              const FlightListSlider(),
              const VSpace(),
              const AirportListSlider(),
              const VSpaceBig(),
              const AdsHoliday(),
              const VSpaceBig(),
            ]))
          ),
        ],
      )
    );
  }
}