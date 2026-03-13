import 'package:flight_app/app/app_link.dart';
import 'package:flight_app/app/controllers.dart';
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
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SearchFlightForm extends StatefulWidget {
  const SearchFlightForm({super.key, required this.roundTrip});

  final bool roundTrip;

  @override
  State<SearchFlightForm> createState() => _SearchFlightFormState();
}

class _SearchFlightFormState extends State<SearchFlightForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _dateFromRef = TextEditingController(
    text: DateFormat('yyyy-MM-dd').format(DateTime.now()),
  );
  final TextEditingController _dateToRef = TextEditingController();
  final TextEditingController _passenggerClassRef = TextEditingController();

  double _adults = 1;
  double _children = 0;
  double _infants = 0;

  final TextEditingController _fromRef = TextEditingController();
  final TextEditingController _toRef = TextEditingController();

  final controller = Get.put(FlightSearchController());

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setFrom(controller.from.value);
    setTo(controller.to.value);
  }

  void setFrom(String city) {
    setState(() {
      _fromRef.text = city;
    });
  }

  void setTo(String city) {
    setState(() {
      _toRef.text = city;
    });
  }

  void _showBottomSheet() async {
    Get.bottomSheet(
      StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Wrap(
            children: [
              PassenggerClass(
                addPassenggers: (String type) {
                  setState(() {
                    switch (type) {
                      case 'adults':
                        _adults++;
                        controller.adults.value = _adults;
                        break;
                      case 'children':
                        _children++;
                        controller.children.value = _children;
                        break;
                      case 'infants':
                        _infants++;
                        controller.infants.value = _infants;
                        break;
                    }

                    final double totalPassengers =
                        _adults + _children + _infants;

                    _passenggerClassRef.text =
                        '$totalPassengers Passenger${totalPassengers > 1 ? 's' : ''}';
                  });
                },
                removePassenggers: (String type) {
                  setState(() {
                    switch (type) {
                      case 'adults':
                        _adults > 1 ? _adults-- : _adults = 1;
                        break;
                      case 'children':
                        _children > 0 ? _children-- : _children = 0;
                        break;
                      case 'infants':
                        _infants > 0 ? _infants-- : _infants = 0;
                        break;
                    }

                    final double totalPassengers =
                        _adults + _children + _infants;

                    _passenggerClassRef.text =
                        '$totalPassengers Passenger${totalPassengers > 1 ? 's' : ''}';
                  });
                },
                passengers: [_adults, _children, _infants],
                classType: "",
                setClass: (String type) {
                  setState(() {
                    final double totalPassengers =
                        _adults + _children + _infants;

                    _passenggerClassRef.text =
                        '$totalPassengers Passenger${totalPassengers > 1 ? 's' : ''}';
                  });
                },
              ),
            ],
          );
        },
      ),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
    );
  }

  Future<void> _selectDate(TextEditingController targetRef) async {
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
  void dispose() {
    _dateFromRef.dispose();
    _dateToRef.dispose();
    _passenggerClassRef.dispose();
    _fromRef.dispose();
    _toRef.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: spacingUnit(2),
        horizontal: spacingUnit(2),
      ),
      child: Form(
        key: _formKey,
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(0),
          physics: const ClampingScrollPhysics(),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: AppTextField(
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter departure city';
                      }
                      return null;
                    },
                    label: 'Flying From',
                    controller: _fromRef,
                    readOnly: true,
                    onChanged: (_) {},
                    onTap: () {
                      Get.toNamed(
                        AppLink.searchList,
                        arguments: "from",
                      );
                    },
                    prefixIcon: FontAwesomeIcons.planeDeparture,
                  ),
                ),
                SizedBox(width: spacingUnit(1)),
                InkWell(
                  onTap: () {
                    controller.to.value = _fromRef.text;
                    controller.from.value = _toRef.text;
                    _fromRef.text = controller.from.value;
                    _toRef.text = controller.to.value;
                    setState(() {});
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      borderRadius: ThemeRadius.small,
                      color: colorScheme(context).primaryContainer,
                    ),
                    child: Icon(
                      CupertinoIcons.arrow_up_arrow_down,
                      size: 24,
                      color: colorScheme(context).onPrimaryContainer,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: spacingUnit(2)),
            AppTextField(
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter destination city';
                }
                return null;
              },
              label: 'Flying To',
              controller: _toRef,
              readOnly: true,
              onChanged: (_) {},
              onTap: () {
                Get.toNamed(AppLink.searchList, arguments: "to");
              },
              prefixIcon: FontAwesomeIcons.planeArrival,
            ),
            SizedBox(height: spacingUnit(2)),
            AppTextField(
              label: 'Departure Date',
              onChanged: (_) {},
              controller: _dateFromRef,
              readOnly: true,
              prefixIcon: FontAwesomeIcons.calendar,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please select departure date';
                }
                return null;
              },
              onTap: () {
                _selectDate(_dateFromRef);
              },
            ),
            widget.roundTrip
                ? Padding(
                    padding: EdgeInsets.only(top: spacingUnit(1)),
                    child: AppTextField(
                      label: 'Return Date',
                      onChanged: (_) {},
                      controller: _dateToRef,
                      readOnly: true,
                      prefixIcon: FontAwesomeIcons.calendar,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please select return date';
                        }
                        return null;
                      },
                      onTap: () {
                        _selectDate(_dateToRef);
                      },
                    ),
                  )
                : Container(),
            SizedBox(height: spacingUnit(2)),
            AppTextField(
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please select passengers and class';
                }
                return null;
              },
              label: 'Passenger and Class',
              onChanged: (_) {},
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
                  if (_formKey.currentState!.validate()) {
                    controller.from.value = _fromRef.text;
                    controller.to.value = _toRef.text;
                    controller.departureDate.value = _dateFromRef.text;
                    controller.returnDate.value = _dateToRef.text;

                    setFrom("");
                    setTo("");
                    if (widget.roundTrip) {
                      Get.toNamed(AppLink.flightListRoundTrip);
                    } else {
                      Get.toNamed(AppLink.flightList);
                    }
                  }
                },
                style: ThemeButton.btnBig.merge(ThemeButton.primary),
                child: Text(
                  'Search Flights'.toUpperCase(),
                  style: ThemeText.subtitle.copyWith(color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: spacingUnit(1)),
          ],
        ),
      ),
    );
  }
}
