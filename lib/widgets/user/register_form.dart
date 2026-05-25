import 'package:flight_app/app/app_link.dart';
import 'package:flight_app/app/controller/auth_controller.dart';
// import 'package:flight_app/app/controller/auth_controller.dart';
// import 'package:flight_app/app/controller/mail_auth_controller.dart';
// import 'package:get/get_instance/src/extension_instance.dart';
import 'package:flight_app/l10n/app_localizations.dart';
// import 'package:flight_app/screens/profile/terms_condition.dart';
import 'package:flight_app/ui/themes/theme_breakpoints.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/route_manager.dart';
import 'package:flight_app/ui/themes/theme_button.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/ui/themes/theme_text.dart';
import 'package:flight_app/widgets/app_input/app_textfield.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _registerKey = GlobalKey<FormBuilderState>();
  // final EmailAuthController emailAuthController =
  //     Get.find<EmailAuthController>();

  bool termsValidator = false;

  checkValidate() {
    setState(() {
      termsValidator =
          _registerKey.currentState?.fields['accept_terms']?.value ?? false;
    });
  }

  final _authController = Get.find<AuthController>();
  Future<void> _handleRegister() async {
    final isValid = _registerKey.currentState?.saveAndValidate() ?? false;

    if (!isValid) return;

    final formData = _registerKey.currentState!.value;
    final name = (formData['name'] ?? '').toString().trim();
    final mailOrPhone = (formData['mailOrPhone'] ?? '').toString().trim();
    final password = (formData['password'] ?? '').toString().trim();

    await _authController.register(
      firstName: name,
      phone: mailOrPhone,
      password: password,
    );
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: ThemeSize.sm),
      child: FormBuilder(
        key: _registerKey,
        child: ListView(padding: EdgeInsets.zero, children: [
          /// TITLE
          const VSpace(),
          Text(localization.register.toUpperCase(), style: ThemeText.title),
          SizedBox(height: spacingUnit(1)),
          Text(localization.registerFormPrag,
              style: ThemeText.headline
                  .copyWith(color: colorScheme.onSurfaceVariant)),
          const VSpace(),

          /// INPUT FIELD
          FormBuilderField(
            name: 'name',
            builder: (FormFieldState<dynamic> field) {
              return AppTextField(
                label: localization.firstName,
                onChanged: (value) => field.didChange(value),
                errorText:
                    field.hasError ? localization.pleaseFillYourName : null,
              );
            },
            validator: FormBuilderValidators.required(),
          ),
          const VSpace(),

          FormBuilderField(
            name: 'mailOrPhone',
            builder: (FormFieldState<dynamic> field) {
              return AppTextField(
                // controller: emailAuthController.,
                label: localization.phoneNumber,
                onChanged: (value) => field.didChange(value),
                errorText: field.hasError
                    ? localization.incorrectEmailOrPhoneNumber
                    : null,
              );
            },
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
              FormBuilderValidators.or([
                FormBuilderValidators.email(),
                FormBuilderValidators.phoneNumber(),
              ])
            ]),
          ),
          const VSpace(),

          FormBuilderField(
            name: 'password',
            builder: (FormFieldState<dynamic> field) {
              return AppTextField(
                label: localization.password,
                obscureText: true,
                onChanged: (value) => field.didChange(value),
                errorText:
                    field.hasError ? localization.passwordMinLength : null,
              );
            },
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
              FormBuilderValidators.minLength(6),
            ]),
          ),
          const VSpace(),

          FormBuilderField(
            name: 'repeat_password',
            autovalidateMode: AutovalidateMode.onUserInteraction,
            builder: (FormFieldState<dynamic> field) {
              return AppTextField(
                label: localization.repeatPassword,
                obscureText: true,
                onChanged: (value) => field.didChange(value),
                errorText: field.hasError ? 'Password doesn\'t match' : null,
              );
            },
            validator: (value) =>
                _registerKey.currentState?.fields['password']?.value != value
                    ? localization.passwordNotMatch
                    : null,
          ),
          const VSpaceShort(),
          FormBuilderCheckbox(
            name: 'accept_terms',
            initialValue: termsValidator,
            onChanged: (value) {
              value == true
                  ? {Get.toNamed(AppLink.terms), checkValidate()}
                  : null;
            },
            title: Text(localization.agreewithOurTermsAndConditions),
            validator: FormBuilderValidators.equal(
              termsValidator,
              errorText: localization.acceptTermsError,
            ),
          ),
          const VSpace(),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: FilledButton(
                onPressed:
                    // _authController.isLoading.value ? null :
                    () {
                  if (_registerKey.currentState?.saveAndValidate() ?? false) {
                    debugPrint(_registerKey.currentState?.value.toString());
                    _handleRegister();
                    // _authController.sendOtp();
                    Get.toNamed(AppLink.otp);
                  }
                },
                style: ThemeButton.btnBig.merge(ThemeButton.primary),
                child: Text(localization.register.toUpperCase(),
                    style: ThemeText.subtitle)),
          ),
          const VSpaceBig(),
        ]),
      ),
    );
  }
}
