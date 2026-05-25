import 'package:flight_app/l10n/app_localizations.dart';
import 'package:flight_app/ui/themes/theme_breakpoints.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flight_app/models/ggModel/list_item.dart';
import 'package:flight_app/ui/themes/theme_button.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/ui/themes/theme_text.dart';
import 'package:flight_app/utils/picker.dart';
import 'package:flight_app/widgets/app_input/app_textfield.dart';
import 'package:timezone/timezone.dart';

class MessageForm extends StatefulWidget {
  const MessageForm({super.key});

  @override
  State<MessageForm> createState() => _MessageFormState();
}

class _MessageFormState extends State<MessageForm> {
  final TextEditingController _chooseRef = TextEditingController();
  String? categoryTemp;
  final _messageKey = GlobalKey<FormBuilderState>();

  List<ListItem> categoryOptions = [
    // ListItem(
    //   value: 'promotion',
    //   label: 'Promotion',
    // ),
    ListItem(
      value: 'event',
      label: 'Event',
    ),
    ListItem(
      value: 'account',
      label: 'Account',
    ),
    ListItem(
      value: 'feedback',
      label: 'Feedback',
    ),
    ListItem(
      value: 'app',
      label: 'This App',
    ),
    ListItem(
      value: 'other',
      label: 'Other',
    ),
  ];

  void openPicker(BuildContext context, String title) {
    openRadioPicker(
      context: context,
      options: categoryOptions,
      title: title,
      initialValue: categoryTemp,
      onSelected: (value) {
        if (value != null) {
          String result =
              categoryOptions.firstWhere((e) => e.value == value).label;

          _messageKey.currentState?.patchValue({
            'topic': result,
          });
          _chooseRef.text = result;
        }
        setState(() {
          categoryTemp = value;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: ThemeSize.sm),
        child: FormBuilder(
          key: _messageKey,
          child: ListView(padding: EdgeInsets.all(spacingUnit(2)), children: [
            const VSpaceShort(),
            Text(localization.contactUsReport, style: ThemeText.headline),
            const VSpace(),
            FormBuilderField(
              name: 'topic',
              builder: (FormFieldState<dynamic> field) {
                return AppTextField(
                  controller: _chooseRef,
                  label: localization.chooseTopic,
                  onChanged: (value) => field.didChange(value),
                  errorText:
                      field.hasError ? localization.plsChooseTopic : null,
                  onTap: () {
                    openPicker(context, localization.chooseCategory);
                  },
                  suffix: const Icon(Icons.arrow_drop_down),
                );
              },
              validator: FormBuilderValidators.required(),
            ),
            const VSpaceShort(),
            FormBuilderField(
                name: 'subject',
                builder: (FormFieldState<dynamic> field) {
                  return AppTextField(
                    label: localization.subject,
                    onChanged: (value) => field.didChange(value),
                  );
                }),
            const VSpaceShort(),
            FormBuilderField(
              name: 'description',
              builder: (FormFieldState<dynamic> field) {
                return AppTextField(
                  label: localization.description,
                  maxLines: 5,
                  onChanged: (value) => field.didChange(value),
                  errorText:
                      field.hasError ? localization.plsWriteMessageDesc : null,
                );
              },
              validator: FormBuilderValidators.required(),
            ),
            const VSpace(),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  if (_messageKey.currentState?.saveAndValidate() ?? false) {
                    debugPrint(_messageKey.currentState?.value.toString());
                  }
                },
                style: ThemeButton.btnBig.merge(ThemeButton.primary),
                child: Text(localization.subRep.toUpperCase()),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
