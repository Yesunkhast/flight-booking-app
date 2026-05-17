import 'package:flight_app/l10n/app_localizations.dart';
import 'package:flight_app/ui/themes/theme_breakpoints.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/ui/themes/theme_text.dart';
import 'package:flight_app/widgets/cards/paper_card.dart';

class ContactList extends StatelessWidget {
  const ContactList({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: ThemeSize.sm),
        child: ListView(padding: EdgeInsets.all(spacingUnit(2)), children: [
          VSpaceShort(),
          Text(localization.contactUsDesc, style: ThemeText.headline),
          VSpace(),
          PaperCard(
              content: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: FaIcon(FontAwesomeIcons.viber,
                        color: Colors.lightGreen),
                    title: Text('+976 9090 1550'),
                    subtitle: Text('Viber'),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ))),
          VSpaceShort(),
          PaperCard(
              content: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: Icon(Icons.phone, color: Colors.cyan),
                    title: Text('+976 9090 1550'),
                    subtitle: Text(localization.phoneNumber),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ))),
          VSpaceShort(),
          PaperCard(
              content: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: Icon(Icons.email, color: Colors.teal),
                    title: Text('contact@echina.mn'),
                    subtitle: Text('Email'),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ))),
          VSpaceShort(),
          PaperCard(
              content: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: Icon(Icons.location_on, color: Colors.red),
                    title: Text(localization.locationDesc),
                    subtitle: Text(localization.location),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ))),
          VSpaceShort(),
          PaperCard(
              content: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: ListTile(
                    leading:
                        FaIcon(FontAwesomeIcons.facebook, color: Colors.blue),
                    title: Text('EChina.mn'),
                    subtitle: Text('Facebook'),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ))),
        ]),
      ),
    );
  }
}
