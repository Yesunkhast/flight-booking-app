import 'package:flight_app/app/app_link.dart';
import 'package:flight_app/app/controller/flight_search_controller.dart';
import 'package:flight_app/models/airport.dart';
import 'package:flight_app/ui/themes/theme_palette.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/ui/themes/theme_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:get/route_manager.dart';

class CityListAutocomplete extends StatelessWidget {
  const CityListAutocomplete(
      {super.key, required this.keyword, required this.type});

  final String keyword;
  final String type;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FlightSearchController>();
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.all(spacingUnit(1)),
      itemCount: airportList.length,
      itemBuilder: (context, index) {
        final Airport item = airportList[index];
        final String location = '${item.location}, ${item.name}';
        if (!location.toLowerCase().contains(keyword.toLowerCase())) {
          return const SizedBox.shrink();
        }
        return ListTile(
          leading: CircleAvatar(
            radius: 20,
            backgroundColor: colorScheme(context).surfaceDim,
            child:
                Icon(Icons.flight, color: colorScheme(context).outlineVariant),
          ),
          title: Text(item.location), // Replace with actual data
          subtitle: Text(item.name),
          trailing: Text(
            item.code,
            style: ThemeText.subtitle,
          ), // Replace with actual data
          onTap: () {
            if (type == "from") {
              controller.from.value = item.location;
            } else {
              controller.to.value = item.location;
            }
            Get.toNamed(AppLink.home);
          },
        );
      },
    );
  }
}
