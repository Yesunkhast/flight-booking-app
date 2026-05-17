import 'package:flight_app/app/controller/passenger_controller.dart';
import 'package:flight_app/l10n/app_localizations.dart';
import 'package:flight_app/models/list_item.dart';
// import 'package:flight_app/models/realModel/passenger.dart';
import 'package:flight_app/ui/themes/theme_breakpoints.dart';
import 'package:flight_app/ui/themes/theme_button.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/ui/themes/theme_text.dart';
import 'package:flight_app/utils/picker.dart';
import 'package:flight_app/widgets/alert_info/alert_info.dart';
import 'package:flight_app/widgets/app_button/back_icon_button.dart';
import 'package:flight_app/widgets/app_input/app_textfield.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';

class AddPassengger extends StatefulWidget {
  const AddPassengger({super.key});

  @override
  State<AddPassengger> createState() => _AddPassenggerState();
}

class _AddPassenggerState extends State<AddPassengger> {
  final _addPassenggerKey = GlobalKey<FormState>();
  final _passengerController = Get.find<PassengerController>();

  // ── Text Controllers ─────────────────────────────────────────────────────────
  final TextEditingController _lastNameRef = TextEditingController();
  final TextEditingController _firstNameRef = TextEditingController();
  final TextEditingController _passportIdRef = TextEditingController();
  final TextEditingController _birthdayRef = TextEditingController();
  final TextEditingController _passportValidRef = TextEditingController();
  final TextEditingController _genderRef = TextEditingController();

  String? _gender;

  // final List<String> genderValues = ['M', 'F'];

//   ListItem(value: 'M', label: localization.male),
// ListItem(value: 'F', label: localization.female),

  @override
  void dispose() {
    _lastNameRef.dispose();
    _firstNameRef.dispose();
    _passportIdRef.dispose();
    _birthdayRef.dispose();
    _passportValidRef.dispose();
    _genderRef.dispose();
    super.dispose();
  }

  // ── Date picker ──────────────────────────────────────────────────────────────
  Future _selectDate(
    TextEditingController targetRef, {
    DateTime? firstDate,
    DateTime? lastDate,
    DateTime? initialDate,
  }) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime(2000),
      firstDate: firstDate ?? DateTime(1900),
      lastDate: lastDate ?? DateTime.now(),
    );
    if (picked != null && mounted) {
      setState(() {
        targetRef.text =
            '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      });
    }
  }

  // ── Gender picker ────────────────────────────────────────────────────────────
  void _openGenderPicker({required String title}) {
    final localization = AppLocalizations.of(context)!;

    final genderOptions = [
      ListItem(value: 'M', label: localization.male),
      ListItem(value: 'F', label: localization.female),
    ];
    openRadioPicker(
      context: context,
      options: genderOptions,
      title: title,
      onSelected: (value) {
        if (value != null) {
          final label = genderOptions.firstWhere((e) => e.value == value).label;
          setState(() {
            _gender = value;
            _genderRef.text = label;
          });
        }
      },
      initialValue: _gender,
    );
  }

  // ── Save ─────────────────────────────────────────────────────────────────────
  Future<void> _onSave() async {
    if (!_addPassenggerKey.currentState!.validate()) return;

    await _passengerController.addPassenger(
      lastname: _lastNameRef.text.trim(),
      firstname: _firstNameRef.text.trim(),
      idcard: _passportIdRef.text.trim(),
      birthday: _birthdayRef.text.trim(),
      passportvaliddate: _passportValidRef.text.trim(),
      gender: _gender ?? '',
    );

    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(localization.addNewPassengger, style: ThemeText.subtitle),
        leading: BackIconButton(onTap: () => Get.back()),
        centerTitle: true,
      ),
      body: Form(
        key: _addPassenggerKey,
        child: Column(
          children: [
            Expanded(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: ThemeSize.sm),
                child: ListView(
                  padding: EdgeInsets.all(spacingUnit(2)),
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  children: [
                    AlertInfo(
                      type: AlertType.info,
                      text: localization.enterThePassengerCorrectInfo,
                    ),
                    const VSpaceShort(),

                    // ── Surname ───────────────────────────────────────────
                    AppTextField(
                      label: localization.lastName,
                      controller: _lastNameRef,
                      onChanged: (_) {},
                      validator: FormBuilderValidators.required(),
                    ),
                    const VSpace(),

                    // ── Name ─────────────────────────────────────────────
                    AppTextField(
                      label: localization.firstName,
                      controller: _firstNameRef,
                      onChanged: (_) {},
                      validator: FormBuilderValidators.required(),
                    ),
                    const VSpace(),

                    // ── Passport ID ───────────────────────────────────────
                    AppTextField(
                      label: localization.passportID,
                      controller: _passportIdRef,
                      onChanged: (_) {},
                      validator: FormBuilderValidators.required(),
                    ),
                    const VSpace(),

                    // ── Birthday ─────────────────────────────────────────
                    AppTextField(
                      controller: _birthdayRef,
                      readOnly: true,
                      prefixIcon: Icons.date_range,
                      label: localization.dateOfBirth,
                      onChanged: (_) {},
                      validator: FormBuilderValidators.required(),
                      onTap: () => _selectDate(
                        _birthdayRef,
                        lastDate: DateTime.now(),
                      ),
                    ),
                    const VSpace(),

                    // ── Passport valid date ───────────────────────────────
                    AppTextField(
                      controller: _passportValidRef,
                      readOnly: true,
                      prefixIcon: Icons.date_range,
                      label: localization.passportValidDate,
                      onChanged: (_) {},
                      validator: FormBuilderValidators.required(),
                      onTap: () => _selectDate(
                        _passportValidRef,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                        initialDate: DateTime.now().add(
                          const Duration(days: 365),
                        ),
                      ),
                    ),
                    const VSpace(),

                    // ── Gender ────────────────────────────────────────────
                    AppTextField(
                      controller: _genderRef,
                      label: localization.gender,
                      readOnly: true,
                      onChanged: (_) {},
                      validator: FormBuilderValidators.required(),
                      suffix: Icon(Icons.arrow_drop_down),
                      onTap: () => _openGenderPicker(
                        title: localization.chooseGender,
                      ),
                    ),
                    const VSpace(),
                  ],
                ),
              ),
            ),

            // ── Save button ───────────────────────────────────────────────
            Center(
              child: Container(
                constraints: BoxConstraints(maxWidth: ThemeSize.sm),
                padding: EdgeInsets.only(
                  left: spacingUnit(2),
                  right: spacingUnit(2),
                  top: spacingUnit(1),
                  bottom: spacingUnit(4),
                ),
                child: Obx(() => SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: _passengerController.isLoading.value
                            ? null // ✅ disable while saving
                            : _onSave,
                        style: ThemeButton.btnBig.merge(ThemeButton.primary),
                        child: _passengerController.isLoading.value
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : Text(localization.save,
                                style: ThemeText.subtitle2),
                      ),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
