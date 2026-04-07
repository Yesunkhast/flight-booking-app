import 'package:flight_app/app/app_link.dart';
import 'package:flight_app/app/controller/flight_search_controller.dart';
import 'package:flight_app/l10n/app_localizations.dart';
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
import 'package:form_builder_validators/form_builder_validators.dart';
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
  final TextEditingController _dateToRef = TextEditingController(
    text:
        DateFormat('yyyy-MM-dd').format(DateTime.now().add(Duration(days: 7))),
  );
  final TextEditingController _passengerClassRef = TextEditingController();

  int _adults = 1;
  int _children = 0;
  int _infants = 0;

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
                        break;
                      case 'children':
                        _children++;
                        break;
                      case 'infants':
                        _infants++;
                        break;
                    }

                    // final double totalPassengers =
                    //     _adults + _children + _infants;

                    // _passenggerClassRef.text =
                    //     'adults:$_adults childrens:$_children infants: $_infants';
                  });
                },
                removePassenggers: (String type) {
                  setState(() {
                    switch (type) {
                      case 'adults':
                        _adults > 0 ? _adults-- : _adults = 0;
                        break;
                      case 'children':
                        _children > 0 ? _children-- : _children = 0;
                        break;
                      case 'infants':
                        _infants > 0 ? _infants-- : _infants = 0;
                        break;
                    }

                    // final double totalPassengers =
                    //     _adults + _children + _infants;

                    // _passenggerClassRef.text =
                    //     'adults:$_adults childrens:$_children infants: $_infants';
                  });
                },
                passengers: [
                  _adults.toDouble(),
                  _children.toDouble(),
                  _infants.toDouble()
                ],
                classType: "",
                setClass: (String type) {
                  setState(() {
                    // final double totalPassengers =
                    //     _adults + _children + _infants;
                    controller.adults.value = _adults;
                    controller.children.value = _children;
                    controller.infants.value = _infants;
                    if (_adults > 0 && _children > 0 && _infants > 0) {
                      _passengerClassRef.text =
                          'adult:$_adults child:$_children infant: $_infants';
                    } else if (_adults > 0 && _children > 0 && _infants == 0) {
                      _passengerClassRef.text =
                          'adult:$_adults children:$_children';
                    } else if (_adults > 0 && _children == 0 && _infants > 0) {
                      _passengerClassRef.text =
                          'adult:$_adults infant: $_infants';
                    } else if (_adults == 0 && _children > 0 && _infants > 0) {
                      _passengerClassRef.text =
                          'child:$_children infant: $_infants';
                    } else if (_adults > 0 && _children == 0 && _infants == 0) {
                      _passengerClassRef.text = 'adult:$_adults';
                    } else if (_adults == 0 && _children > 0 && _infants == 0) {
                      _passengerClassRef.text = 'child:$_children';
                    } else if (_adults == 0 && _children == 0 && _infants > 0) {
                      _passengerClassRef.text = 'infant: $_infants';
                    }
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

  void _selectDate(TextEditingController controller) async {
    final isReturnDate = controller == _dateToRef;

    DateTime firstDate = DateTime.now();

    if (isReturnDate && _dateFromRef.text.isNotEmpty) {
      final departureDate = DateFormat('yyyy-MM-dd').parse(_dateFromRef.text);
      firstDate = departureDate
          .add(Duration(days: 7)); // return must be after departure
    }

    // initialDate must never be before firstDate
    final initialDate =
        DateTime.now().isBefore(firstDate) ? firstDate : DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate, // safe value
      firstDate: firstDate,
      lastDate: DateTime(2100),
    );

    if (!mounted) return;

    if (picked != null) {
      controller.text = DateFormat('yyyy-MM-dd').format(picked);
      if (controller == _dateFromRef) {
        // Clear return date if it's now before the new departure date
        _dateToRef.clear();
        _formKey.currentState?.validate();
      }
    }
  }

  @override
  void dispose() {
    _dateFromRef.dispose();
    _dateToRef.dispose();
    _passengerClassRef.dispose();
    _fromRef.dispose();
    _toRef.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
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
                    // validator: FormBuilderValidators.compose(
                    //     [FormBuilderValidators.required()]),
                    label: localizations.flyingFrom,
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
              // validator: FormBuilderValidators.compose(
              //     [FormBuilderValidators.required()]),
              label: localizations.flyingTo,
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
              label: localizations.departureDate,
              onChanged: (_) {},
              controller: _dateFromRef,
              readOnly: true,
              prefixIcon: FontAwesomeIcons.calendar,
              validator: FormBuilderValidators.compose(
                  [FormBuilderValidators.required()]),
              onTap: () {
                _selectDate(_dateFromRef);
              },
            ),
            widget.roundTrip
                ? Padding(
                    padding: EdgeInsets.only(top: spacingUnit(1)),
                    child: AppTextField(
                      label: localizations.returnDate,
                      onChanged: (_) {},
                      controller: _dateToRef,
                      readOnly: true,
                      prefixIcon: FontAwesomeIcons.calendar,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please select return date';
                        }

                        // Parse both dates and compare
                        final departureText = _dateFromRef.text;
                        if (departureText.isNotEmpty) {
                          final dateFormat =
                              DateFormat('dd/MM/yyyy'); // adjust to your format
                          final departureDate = dateFormat.parse(departureText);
                          final returnDate = dateFormat.parse(value);

                          if (returnDate.isBefore(departureDate)) {
                            return 'Return date must be after departure date';
                          }

                          if (returnDate.isAtSameMomentAs(departureDate)) {
                            return 'Return date must be different from departure date';
                          }
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
              // validator: FormBuilderValidators.compose(
              //     [FormBuilderValidators.required()]),
              label: localizations.passenger,
              onChanged: (_) {},
              prefixIcon: FontAwesomeIcons.user,
              readOnly: true,
              controller: _passengerClassRef,
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
                  localizations.searchFlight.toUpperCase(),
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
