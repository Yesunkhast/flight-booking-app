import 'package:flight_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:flight_app/ui/themes/theme_palette.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/ui/themes/theme_text.dart';
import 'package:flight_app/widgets/settings/contact_list.dart';
import 'package:flight_app/widgets/settings/message_form.dart';

class Contact extends StatefulWidget {
  const Contact({super.key});

  @override
  State<Contact> createState() => _ContactState();
}

class _ContactState extends State<Contact> with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Icons.arrow_back_ios_new),
          ),
          title: Text(localization.helpAndSup, style: ThemeText.subtitle),
          centerTitle: true,
          bottom: TabBar(
              controller: _tabController,
              indicatorColor: ThemePalette.primaryMain,
              labelColor: ThemePalette.primaryMain,
              tabAlignment: TabAlignment.center,
              unselectedLabelColor: Colors.grey.shade500,
              isScrollable: true,
              dividerHeight: 0,
              labelPadding: EdgeInsets.symmetric(horizontal: spacingUnit(3)),
              tabs: [
                Tab(
                    child: Text(localization.report.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: ThemeText.subtitle)),
                Tab(
                    child: Text(localization.contact.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: ThemeText.subtitle)),
              ]),
        ),
        body: TabBarView(
            controller: _tabController,
            children: const [MessageForm(), ContactList()]));
  }
}
