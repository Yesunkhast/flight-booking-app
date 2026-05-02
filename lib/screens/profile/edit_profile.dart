import 'package:flight_app/app/controller/user_controller.dart';
import 'package:flight_app/l10n/app_localizations.dart';
import 'package:flight_app/ui/themes/theme_breakpoints.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:flight_app/ui/themes/theme_button.dart';
import 'package:flight_app/ui/themes/theme_palette.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/ui/themes/theme_text.dart';
import 'package:flight_app/widgets/app_input/app_textfield.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _editProfileKey = GlobalKey<FormState>();
  final _userController = Get.find<UserController>();

  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _idCardController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // ✅ Fill values after widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = _userController.user.value;
      if (user != null) {
        _lastNameController.text = user.lastName;
        _firstNameController.text = user.firstName;
        _phoneController.text = user.phone;
        _emailController.text = user.email;
        _idCardController.text = user.idCard ?? '';
        _birthdayController.text = user.birthday;
      }
    });
  }

  @override
  void dispose() {
    _lastNameController.dispose();
    _firstNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _idCardController.dispose();
    _birthdayController.dispose();
    super.dispose();
  }

  Future<void> _onUpdate() async {
    if (!_editProfileKey.currentState!.validate()) return;

    final user = _userController.user.value;
    if (user == null) return;

    await _userController.editUser(
      id: user.id,
      lastName: _lastNameController.text.trim(),
      firstName: _firstNameController.text.trim(),
      phone: _phoneController.text.trim(),
      email: _emailController.text.trim(),
      idCard: _idCardController.text.trim(),
      birthday: _birthdayController.text.trim(),
    );

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme(context).surfaceContainerLowest,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        title: Text(localization.editProfile, style: ThemeText.subtitle),
        centerTitle: true,
      ),
      body: Obx(() {
        if (_userController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(spacingUnit(2)),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: ThemeSize.sm),
                child: Form(
                  key: _editProfileKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // ── Avatar ───────────────────────────────────────────
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Obx(() {
                            final image = _userController.user.value?.image;
                            return CircleAvatar(
                              radius: 50,
                              backgroundImage: image != null && image.isNotEmpty
                                  ? NetworkImage(image)
                                  : null,
                              child: image == null || image.isEmpty
                                  ? const Icon(Icons.person, size: 50)
                                  : null,
                            );
                          }),
                          CircleAvatar(
                            radius: 10,
                            backgroundColor: ThemePalette.primaryMain,
                            child: const Icon(Icons.edit,
                                size: 12, color: Colors.white),
                          ),
                        ],
                      ),

                      const VSpace(),

                      // ── last anme ──────────────────────────────────────────
                      AppTextField(
                        label: localization.lastName,
                        controller: _lastNameController,
                        onChanged: (_) {},
                        // validator: FormBuilderValidators.required(),
                      ),
                      const VSpace(),

                      // ── firdt name ─────────────────────────────────────────────
                      AppTextField(
                        label: localization.firstName,
                        controller: _firstNameController,
                        onChanged: (_) {},
                        validator: FormBuilderValidators.required(),
                      ),
                      const VSpace(),

                      // ── Phone ────────────────────────────────────────────
                      AppTextField(
                        label: localization.phoneNumber,
                        controller: _phoneController,
                        onChanged: (_) {},
                        validator: FormBuilderValidators.phoneNumber(),
                      ),
                      const VSpace(),

                      // ── Email ────────────────────────────────────────────
                      AppTextField(
                        label: localization.email,
                        controller: _emailController,
                        onChanged: (_) {},
                        // validator: FormBuilderValidators.email(),
                      ),
                      const VSpace(),

                      // ── ID Card ──────────────────────────────────────────
                      // AppTextField(
                      //   label: 'Үнэмлэхний дугаар',
                      //   controller: _idCardController,
                      //   onChanged: (_) {},
                      // ),
                      // const VSpace(),

                      // ── Birthday ─────────────────────────────────────────
                      AppTextField(
                        label: localization.dateOfBirth,
                        controller: _birthdayController,
                        readOnly: true,
                        onChanged: (_) {},
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );
                          if (picked != null) {
                            _birthdayController.text =
                                '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
                          }
                        },
                      ),
                      const VSpace(),

                      // ── Submit ───────────────────────────────────────────
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: FilledButton(
                          onPressed: _onUpdate,
                          style: ThemeButton.btnBig.merge(ThemeButton.primary),
                          child: Text(
                            localization.update.toUpperCase(),
                            style: ThemeText.subtitle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
