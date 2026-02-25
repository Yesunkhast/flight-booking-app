import 'package:flight_app/app/app_link.dart';
import 'package:flight_app/ui/themes/theme_button.dart';
import 'package:flight_app/ui/themes/theme_palette.dart';
import 'package:flight_app/ui/themes/theme_radius.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/ui/themes/theme_text.dart';
import 'package:flight_app/widgets/app_input/app_textfield.dart';
import 'package:flight_app/widgets/search_filter/passengger_class.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/route_manager.dart';

class SearchFlightForm extends StatefulWidget {
  const SearchFlightForm({super.key, required this.roundTrip});

  final bool roundTrip;

  @override
  State<SearchFlightForm> createState() => _SearchFlightFormState();
}

class _SearchFlightFormState extends State<SearchFlightForm> {
  final TextEditingController _dateFromRef = TextEditingController(text: '1/1/2025');
  final TextEditingController _dateToRef = TextEditingController();
  final TextEditingController _passenggerClassRef = TextEditingController();

  double _adults = 1;
  double _children = 0;
  double _infants = 0;
  String _classType = 'Economy';

  void _showBottomSheet() async {
    Get.bottomSheet(
      StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
        return Wrap(children: [
          PassenggerClass(
            /// ADD PASSENGERS
            addPassenggers: (String type) {
              final double totalPassengers = _adults + _children + _infants;
              setState(() {
                switch (type) {
                  case 'adults':
                    _adults++;
                    break;
                  case 'children':
                    _children++;
                    break;
                  case 'infants':
                    _infants++;
                    break;
                  default:
                    break;
                }
                _passenggerClassRef.text = '$totalPassengers Passengger${totalPassengers > 1 ? 's' : ''}, $_classType';
              });
            },
            /// REMOVE PASSENGERS
            removePassenggers: (String type) {
              final double totalPassengers = _adults + _children + _infants;
              setState(() {
                switch (type) {
                  case 'adults':
                    _adults--;
                    break;
                  case 'children':
                    _children--;
                    break;
                  case 'infants':
                    _infants--;
                    break;
                  default:
                    break;
                }
                _passenggerClassRef.text = '$totalPassengers Passengger${totalPassengers > 1 ? 's' : ''}, $_classType';
              });
            },
            passengers: [_adults, _children, _infants],
            classType: _classType,
            setClass: (String type) {
              /// SET CLASS
              final double totalPassengers = _adults + _children + _infants;
              setState(() {
                _classType = type;
                _passenggerClassRef.text = '$totalPassengers Passengger${totalPassengers > 1 ? 's' : ''}, $_classType';
              });
            }
          )
        ]);
      }),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16))
      )
    );
  }

  Future _selectDate(TextEditingController targetRef) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2025),
      lastDate: DateTime(2027),
    );

    if (picked != null) {
      setState(() {
        targetRef.text = picked.toString().split(" ")[0];
      });
    }
  } 

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: spacingUnit(2), horizontal: spacingUnit(2)),
      child: ListView(shrinkWrap: true, padding: const EdgeInsets.all(0), physics: const ClampingScrollPhysics(), children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: AppTextField(
                label: 'Flying From',
                onChanged: (_) => {},
                onTap: () => {
                  Get.toNamed(AppLink.searchList)
                },
                prefixIcon: FontAwesomeIcons.planeDeparture
              ),
            ),
            SizedBox(width: spacingUnit(1)),
            InkWell(
              onTap: () {},
              child: Container(
                width: 50,
                height: 50,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  borderRadius: ThemeRadius.small,
                  color: colorScheme(context).primaryContainer
                ),
                child: Icon(CupertinoIcons.arrow_up_arrow_down, size: 24, color: colorScheme(context).onPrimaryContainer)
              ),
            )
          ],
        ),
        SizedBox(height: spacingUnit(2)),
        AppTextField(
          label: 'Flying To',
          onChanged: (_) => {},
          onTap: () => {
            Get.toNamed(AppLink.searchList)
          },
          prefixIcon: FontAwesomeIcons.planeArrival
        ),
        SizedBox(height: spacingUnit(2)),
        AppTextField(
          label: 'Departure Date',
          onChanged: (_) => {},
          controller: _dateFromRef,
          readOnly: true,
          prefixIcon: FontAwesomeIcons.calendar,
          onTap: () {
            _selectDate(_dateFromRef);
          },
        ),
        widget.roundTrip ? Padding(
          padding: EdgeInsets.only(top: spacingUnit(1)),
          child: AppTextField(
            label: 'Return Date',
            onChanged: (_) => {},
            controller: _dateToRef,
            readOnly: true,
            prefixIcon: FontAwesomeIcons.calendar,
            onTap: () {
              _selectDate(_dateToRef);
            },
          ),
        ) : Container(),
        SizedBox(height: spacingUnit(2)),
        AppTextField(
          label: 'Passenger and Class',
          onChanged: (_) => {},
          prefixIcon: FontAwesomeIcons.user,
          readOnly: true,
          controller: _passenggerClassRef,
          onTap: _showBottomSheet,
        ),
        SizedBox(height: spacingUnit(2)),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: () {
              if (widget.roundTrip) {
                Get.toNamed(AppLink.flightListRoundTrip);
              } else {
                Get.toNamed(AppLink.flightList);
              }
            },
            style: ThemeButton.btnBig.merge(ThemeButton.primary),
            child: Text('Search Flights'.toUpperCase(), style: ThemeText.subtitle.copyWith(color: Colors.white)),
          ),
        ),
        SizedBox(height: spacingUnit(1)),
      ]),
    );
  }
}