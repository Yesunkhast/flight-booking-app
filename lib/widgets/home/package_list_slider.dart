import 'package:flight_app/app/app_link.dart';
import 'package:flight_app/models/flight_package.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/widgets/cards/package_card.dart';
import 'package:flight_app/widgets/title/title_action.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class PackageListSlider extends StatelessWidget {
  const PackageListSlider({super.key});

  @override
  Widget build(BuildContext context) {
    const double cardWidth = 300;
    const double cardHeight = 220;
    final packageList = flightPackageList.sublist(0, 6);

    return Column(children: [
      Padding(
        padding: EdgeInsets.symmetric(horizontal: spacingUnit(2)),
        child: TitleAction(
          title: 'Featured Packages',
          textAction: 'See All',
          onTap: () {
            Get.toNamed(AppLink.promoDetail);
          }
        ),
      ),
      SizedBox(height: spacingUnit(2)),
      SizedBox(
        height: cardHeight + 16,
        child: ListView.builder(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: packageList.length,
          itemBuilder: ((context, index) {
            FlightPackage item = packageList[index];
        
            return GestureDetector(
              onTap: () {
                Get.toNamed(AppLink.flightDetailPackage);
              },
              child: SizedBox(
                width: cardWidth,
                child: Padding(
                  padding: EdgeInsets.only(right: spacingUnit(1), left: index == 0 ? spacingUnit(1) : 0),
                  child: PackageCard(
                    image: item.img,
                    label: item.label!,
                    from: item.from.name,
                    to: item.to.name,
                    date: item.date,
                    tags: item.tags != null ? item.tags! : [],
                    price: item.price,
                    plane: item.plane
                  ),
                )
              ),
            );
          })
        ),
      )
    ]);
  }
}