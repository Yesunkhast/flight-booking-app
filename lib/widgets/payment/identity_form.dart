import 'package:flutter/material.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/widgets/app_input/app_textfield.dart';

class IdentityForm extends StatelessWidget {
  const IdentityForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      AppTextField(
        label: 'First Name',
        onChanged: (_) {},
      ),
      SizedBox(height: spacingUnit(2)),
      AppTextField(
        label: 'Last Name',
        onChanged: (_) {},
      ),
      SizedBox(height: spacingUnit(2)),
      AppTextField(
        label: 'Phone Number',
        onChanged: (_) {},
      ),
    ]);
  }
}