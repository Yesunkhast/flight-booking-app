import 'package:flight_app/app/app_link.dart';
import 'package:flight_app/app/controller/auth_controller.dart';
import 'package:flight_app/app/controller/user_controller.dart';
import 'package:flight_app/l10n/app_localizations.dart';
import 'package:flight_app/ui/themes/theme_breakpoints.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:flight_app/ui/themes/theme_button.dart';
import 'package:flight_app/ui/themes/theme_palette.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/ui/themes/theme_text.dart';
import 'package:flight_app/widgets/app_input/app_textfield.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _loginKey = GlobalKey<FormBuilderState>();
  bool _hidePassword = true;

  final AuthController _authController = Get.find<AuthController>();
  final UserController _userController = Get.find<UserController>();

  void handleShowPassword() {
    setState(() {
      _hidePassword = !_hidePassword;
    });
  }

  Future<void> _handleLogin() async {
    _authController.errorMessage.value = '';
    final isValid = _loginKey.currentState?.saveAndValidate() ?? false;

    if (!isValid) return;

    final formData = _loginKey.currentState!.value;
    final identifier = (formData['mailOrPhone'] ?? '').toString().trim();
    final password = (formData['password'] ?? '').toString().trim();

    // ignore: avoid_print
    // print('field deh value: $identifier - $password');

    if (_authController.errorMessage.value.isNotEmpty) {
      // ignore: avoid_print
      print('error is :${_authController.errorMessage.value}');
    }

    await _authController.login(
      identifier: identifier,
      password: password,
    );

    await _userController.getUserToApi();
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: ThemeSize.sm),
      child: FormBuilder(
        key: _loginKey,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const VSpace(),
            Text(localization.login, style: ThemeText.title),
            SizedBox(height: spacingUnit(1)),
            Text(
              '✨ Welcome back! Please login to your account.',
              style: ThemeText.headline.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const VSpace(),
            FormBuilderField(
              name: 'mailOrPhone',
              builder: (FormFieldState<dynamic> field) {
                return AppTextField(
                  label: localization.emailOrPhoneNumber,
                  onChanged: (value) => field.didChange(value),
                  errorText:
                      field.hasError ? 'Incorrect email or phone number' : null,
                );
              },
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
                // FormBuilderValidators.or([
                //   FormBuilderValidators.email(),
                //   FormBuilderValidators.phoneNumber(),
                // ]),
              ]),
            ),
            const VSpace(),
            FormBuilderField(
              name: 'password',
              builder: (FormFieldState<dynamic> field) {
                return AppTextField(
                  label: localization.password,
                  obscureText: _hidePassword,
                  onChanged: (value) => field.didChange(value),
                  errorText:
                      field.hasError ? 'Please fill your password!' : null,
                  suffix: IconButton(
                    onPressed: handleShowPassword,
                    icon: _hidePassword
                        ? const Icon(Icons.visibility)
                        : const Icon(Icons.visibility_off),
                  ),
                );
              },
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
                FormBuilderValidators.or([
                  FormBuilderValidators.minLength(6),
                ]),
              ]),
            ),
            const VSpace(),
            Obx(() {
              if (_authController.errorMessage.value.isEmpty) {
                return const SizedBox.shrink();
              }
              return Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      // color: colorScheme.errorContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline,
                            color: colorScheme.error, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _authController.errorMessage.value,
                            style: ThemeText.caption
                                .copyWith(color: colorScheme.error),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),
            Obx(
              () => SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton(
                  onPressed: _authController.isLoading.value &&
                          _userController.isLoading.value
                      ? null
                      : _handleLogin,
                  // print("pressed");
                  style: ThemeButton.btnBig.merge(ThemeButton.primary),
                  child: _authController.isLoading.value
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(
                          localization.login.toUpperCase(),
                          style: ThemeText.subtitle,
                        ),
                ),
              ),
            ),
            const VSpaceBig(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: () {
                    Get.toNamed(AppLink.resetPassword);
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          CircleAvatar(
                            backgroundColor: ThemePalette.secondaryLight,
                            radius: 22,
                          ),
                          Icon(
                            Icons.help_outline,
                            size: 32,
                            color: ThemePalette.secondaryDark,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Forgot Password',
                        style: ThemeText.caption,
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    Get.toNamed(AppLink.contact);
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          CircleAvatar(
                            backgroundColor: ThemePalette.primaryLight,
                            radius: 22,
                          ),
                          Icon(
                            Icons.question_answer_outlined,
                            size: 32,
                            color: ThemePalette.primaryDark,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Help and Support',
                        style: ThemeText.caption,
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    Get.toNamed(AppLink.home);
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          CircleAvatar(
                            backgroundColor: ThemePalette.tertiaryLight,
                            radius: 22,
                          ),
                          Icon(
                            Icons.group_outlined,
                            size: 32,
                            color: ThemePalette.tertiaryDark,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'User Demo',
                        style: ThemeText.caption,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
