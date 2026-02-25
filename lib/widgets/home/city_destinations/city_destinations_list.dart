import 'package:flight_app/app/app_link.dart';
import 'package:flight_app/models/city.dart';
import 'package:flight_app/ui/themes/theme_palette.dart';
import 'package:flight_app/ui/themes/theme_radius.dart';
import 'package:flight_app/ui/themes/theme_shadow.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/ui/themes/theme_text.dart';
import 'package:flight_app/utils/shimmer_preloader.dart';
import 'package:flight_app/widgets/title/title_basic.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class CityDestinationsList extends StatelessWidget {
  const CityDestinationsList({super.key});

  @override
  Widget build(BuildContext context) {
    final List<City> recomendedCityList = cityList.sublist(6, 14);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: spacingUnit(2), vertical: spacingUnit(5)),
      decoration: BoxDecoration(
        color: colorScheme(context).surfaceContainerLowest,
        borderRadius: ThemeRadius.medium
      ),
      child: Column(
        children: [
          const TitleBasic(title: 'Popular Destinations'),
          SizedBox(height: spacingUnit(2),), 
          SizedBox(
            height: 200,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: recomendedCityList.length,
              separatorBuilder: (context, index) => SizedBox(width: spacingUnit(2)),
              itemBuilder: (context, index) {
                final item = recomendedCityList[index];
                return GestureDetector(
                  onTap: () {
                    Get.toNamed(AppLink.searchFlight);
                  },
                  child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                    Container(
                      height: 160,
                      width: 160,
                      decoration: BoxDecoration(
                        borderRadius: ThemeRadius.medium,
                        boxShadow: [ThemeShade.shadeMedium(context)],
                      ),
                      child: ClipRRect(
                        borderRadius: ThemeRadius.medium,
                        child: Image.network(
                          item.photos[0],
                          fit: BoxFit.cover,
                          loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const SizedBox(
                              width: double.infinity,
                              height: 60,
                              child: ShimmerPreloader()
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: spacingUnit(1)),
                    Text(item.name, overflow: TextOverflow.ellipsis, style: ThemeText.subtitle)
                  ])
                );
              },
            ),
          )
        ],
      ),
    );
  }
}