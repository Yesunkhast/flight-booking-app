import 'package:flight_app/models/realModel/flight.dart';
import 'package:flight_app/ui/themes/theme_button.dart';
import 'package:flight_app/ui/themes/theme_palette.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/ui/themes/theme_text.dart';
import 'package:flight_app/utils/grabber_icon.dart';
import 'package:flight_app/widgets/title/title_basic.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

// Simple model to hold airline display info extracted from FlightSegment
class AirlineOption {
  final String code;
  final String name;
  final String logo;

  const AirlineOption({
    required this.code,
    required this.name,
    required this.logo,
  });
}

class FilterFlightForm extends StatelessWidget {
  const FilterFlightForm({
    super.key,
    required this.onChangePrice,
    required this.onUpdateAirlines,
    required this.onUpdateTransit,
    required this.onChangeDuration,
    required this.priceRange,
    required this.selectedAirlines,
    required this.transits,
    required this.duration,
    required this.allFlights, // ← needed to build airline list
  });

  // Functions
  final Function(RangeValues) onChangePrice;
  final Function(String type, String airlineCode) onUpdateAirlines; // ← String
  final Function(String type, int) onUpdateTransit;
  final Function(double) onChangeDuration;

  // Values
  final RangeValues priceRange;
  final List<String> selectedAirlines; // ← List<String>
  final List<int> transits;
  final double duration;
  final List<FlightInfo> allFlights; // ← source of truth for airline options

  /// Deduplicate airlines from all flight segments
  List<AirlineOption> _buildAirlineOptions() {
    final seen = <String>{};
    final options = <AirlineOption>[];

    for (final flight in allFlights) {
      for (final seg in flight.flightSegment) {
        if (seg.airlineCode.isNotEmpty && seen.add(seg.airlineCode)) {
          options.add(AirlineOption(
            code: seg.airlineCode,
            name: seg.airline,
            logo: seg.airlineLogo,
          ));
        }
      }
    }

    // Sort alphabetically by name
    options.sort((a, b) => a.name.compareTo(b.name));
    return options;
  }

  @override
  Widget build(BuildContext context) {
    final airlineOptions = _buildAirlineOptions();

    return Padding(
      padding: EdgeInsets.all(spacingUnit(2)),
      child: Column(
        children: [
          const GrabberIcon(),
          const VSpaceShort(),
          const TitleBasic(title: 'Filters'),
          const VSpaceShort(),
          Expanded(
            child: ListView(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              children: [
                /// PRICE RANGE
                Row(
                  children: [
                    const Icon(Icons.price_change_outlined),
                    const Text(' Range Price:', style: ThemeText.subtitle2),
                    SizedBox(width: spacingUnit(1)),
                    Text(
                      '\$${priceRange.start.round()} - \$${priceRange.end.round()}',
                      style: ThemeText.subtitle2.copyWith(
                          color: colorScheme(context).onSecondaryContainer),
                    ),
                  ],
                ),
                SizedBox(height: spacingUnit(1)),
                RangeSlider(
                  values: priceRange,
                  max: 10000,
                  divisions: 100,
                  labels: RangeLabels(
                    priceRange.start.round().toString(),
                    priceRange.end.round().toString(),
                  ),
                  onChanged: onChangePrice,
                ),
                const VSpace(),

                /// TRANSITS
                const Row(
                  children: [
                    Icon(Icons.timeline_sharp),
                    Text(' Transits', style: ThemeText.subtitle2),
                  ],
                ),
                SizedBox(height: spacingUnit(1)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: spacingUnit(2)),
                    _TransitCheckbox(
                      label: 'Direct',
                      value: 0,
                      transits: transits,
                      onUpdate: onUpdateTransit,
                    ),
                    SizedBox(width: spacingUnit(1)),
                    _TransitCheckbox(
                      label: '1 Stop',
                      value: 1,
                      transits: transits,
                      onUpdate: onUpdateTransit,
                    ),
                    SizedBox(width: spacingUnit(1)),
                    _TransitCheckbox(
                      label: '2+ Stops',
                      value: 2,
                      transits: transits,
                      onUpdate: onUpdateTransit,
                    ),
                  ],
                ),
                const VSpaceBig(),

                /// DURATION
                Row(
                  children: [
                    const Icon(Icons.access_time),
                    const Text(' Maximum Trip Duration:',
                        style: ThemeText.subtitle2),
                    SizedBox(width: spacingUnit(1)),
                    Text(
                      '${duration.round()} hours',
                      style: ThemeText.subtitle2.copyWith(
                          color: colorScheme(context).onSecondaryContainer),
                    ),
                  ],
                ),
                SizedBox(height: spacingUnit(1)),
                Slider(
                  value: duration,
                  max: 36,
                  divisions: 36,
                  label: duration.round().toString(),
                  onChanged: onChangeDuration,
                ),
                const VSpace(),

                /// AIRLINES
                const Row(
                  children: [
                    Icon(Icons.flight),
                    Text(' Airlines', style: ThemeText.subtitle2),
                  ],
                ),
                SizedBox(height: spacingUnit(1)),

                if (airlineOptions.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text('No airlines available',
                        style: TextStyle(color: Colors.grey)),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemCount: airlineOptions.length,
                    itemBuilder: (context, index) {
                      final airline = airlineOptions[index];
                      final isSelected =
                          selectedAirlines.contains(airline.code);

                      return CheckboxListTile(
                        secondary: CircleAvatar(
                          radius: 15,
                          // Show logo if URL is valid, else show initials
                          backgroundImage: airline.logo.isNotEmpty
                              ? NetworkImage(airline.logo)
                              : null,
                          child: airline.logo.isEmpty
                              ? Text(
                                  airline.code.length >= 2
                                      ? airline.code.substring(0, 2)
                                      : airline.code,
                                  style: const TextStyle(fontSize: 10),
                                )
                              : null,
                        ),
                        title: Text(airline.name),
                        subtitle: Text(airline.code,
                            style: const TextStyle(fontSize: 11)),
                        value: isSelected,
                        onChanged: (bool? value) {
                          if (value == true) {
                            onUpdateAirlines('add', airline.code);
                          } else {
                            onUpdateAirlines('remove', airline.code);
                          }
                        },
                      );
                    },
                  ),

                const VSpaceBig(),
              ],
            ),
          ),

          /// DONE BUTTON
          Padding(
            padding: EdgeInsets.all(spacingUnit(1)),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Get.back(),
                style:
                    ThemeButton.btnBig.merge(ThemeButton.tonalPrimary(context)),
                child: Text('Done'.toUpperCase(), style: ThemeText.subtitle),
              ),
            ),
          ),
          const VSpace(),
        ],
      ),
    );
  }
}

/// Extracted to avoid repeating transit checkbox boilerplate
class _TransitCheckbox extends StatelessWidget {
  const _TransitCheckbox({
    required this.label,
    required this.value,
    required this.transits,
    required this.onUpdate,
  });

  final String label;
  final int value;
  final List<int> transits;
  final Function(String, int) onUpdate;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: transits.contains(value),
          onChanged: (bool? checked) {
            onUpdate(checked == true ? 'add' : 'remove', value);
          },
        ),
        Text(label),
      ],
    );
  }
}
