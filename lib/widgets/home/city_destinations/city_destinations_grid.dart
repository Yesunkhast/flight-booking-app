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

class CityDestinationsGrid extends StatelessWidget {
  const CityDestinationsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final List<City> recomendedCityList = cityList.sublist(6, 14);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: spacingUnit(2)),
      decoration: BoxDecoration(
        color: colorScheme(context).surfaceContainerLowest,
        borderRadius: ThemeRadius.medium
      ),
      child: Column(
        children: [
          const TitleBasic(title: 'Popular Destinations'),
          SizedBox(height: spacingUnit(2),), 
          GridView.builder(
            padding: const EdgeInsets.all(0),
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 0.8,
            ),
            itemCount: 8,
            itemBuilder: (context, index) {
              final City item = recomendedCityList[index];
              return GestureDetector(
                onTap: () {
                  Get.toNamed(AppLink.searchFlight);
                },
                child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                  Container(
                    height: 60,
                    width: 60,
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
                  Text(item.name, overflow: TextOverflow.ellipsis, style: ThemeText.paragraph)
                ])
              );
            }
          ),
        ],
      ),
    );
  }
}