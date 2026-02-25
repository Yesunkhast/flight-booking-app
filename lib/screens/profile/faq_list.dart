import 'package:flight_app/app/app_link.dart';
import 'package:flight_app/constants/app_const.dart';
import 'package:flight_app/ui/themes/theme_breakpoints.dart';
import 'package:flight_app/widgets/app_button/back_icon_button.dart';
import 'package:flight_app/widgets/search_filter/search_input_btn.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';
import 'package:flight_app/models/faq.dart';
import 'package:flight_app/ui/themes/theme_button.dart';
import 'package:flight_app/ui/themes/theme_palette.dart';
import 'package:flight_app/ui/themes/theme_radius.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/ui/themes/theme_text.dart';

class FaqList extends StatefulWidget {
  const FaqList({super.key});

  @override
  State<FaqList> createState() => _FaqListState();
}

class _FaqListState extends State<FaqList> {
  bool _showSearch = false;

  void toggleSearch() {
    setState(() {
      _showSearch = !_showSearch;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark, 
        forceMaterialTransparency: true,
        backgroundColor: Colors.transparent,
        leading: BackIconButton(
          onTap: () {
            Get.back();
          }
        ),
        titleSpacing: 0,
        title: _showSearch ? Padding(
          padding: EdgeInsets.symmetric(vertical: spacingUnit(2), horizontal: spacingUnit(2)),
          child: SearchInputBtn(
            location: '/search-list',
            title: 'Search Topic',
            onCancel: () {
              toggleSearch();
            },
          ),
        ) : Container(),
        centerTitle: true,
        actions: [
          /// SEARCH BUTTON
          !_showSearch ? IconButton(
            icon: const Icon(Icons.search, size: 32, color: Colors.black),
            onPressed: () {
              toggleSearch();
            },
          ) : Container(),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: colorScheme(context).secondary
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// BANNER
            Padding(
              padding: EdgeInsets.only(top: spacingUnit(8) + MediaQuery.of(context).padding.top, bottom: spacingUnit(1), left: spacingUnit(2), right: spacingUnit(2)),
              child: RichText(text: TextSpan(text: 'Hello ', style: ThemeText.title2.copyWith(fontWeight: FontWeight.normal, color: Colors.black), children: [
                TextSpan(text: userDummy.name, style: TextStyle(fontWeight: FontWeight.bold, color: colorScheme(context).primary))
              ])),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: spacingUnit(3), left: spacingUnit(2), right: spacingUnit(2)),
              child: Text('How can we help you?', style: ThemeText.title.copyWith(color: Colors.black))
            ),
      
            /// CONTENTS
            Expanded(
              child: Container(
                padding: EdgeInsets.all(spacingUnit(3)),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                  color: Theme.of(context).colorScheme.surface,
                ),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: ThemeSize.sm
                    ),
                    child: ListView(
                      padding: const EdgeInsets.all(0),
                      shrinkWrap: true,
                      children: [
                        /// FAQ LIST
                        ExpansionPanelList(
                          elevation: 0,
                          expansionCallback: (int index, bool isExpanded) {
                            setState(() {
                              faqData[index].isExpanded = isExpanded;
                            });
                          },
                          children: faqData.asMap().entries.map<ExpansionPanel>((entry) {
                            Faq item = entry.value;
                            int index = entry.key;
                                    
                            return ExpansionPanel(
                              headerBuilder: (BuildContext context, bool isExpanded) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      faqData[index].isExpanded = !faqData[index].isExpanded;
                                    });
                                  },
                                  child: ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    title: Text(item.headerValue, style: ThemeText.subtitle2,),
                                  ),
                                );
                              },
                              body: Text(item.expandedValue),
                              isExpanded: item.isExpanded,
                            );
                          }).toList(),
                        ),
                        const VSpace(),
                                  
                        /// CONTACT BUTTON
                        Container(
                          padding: EdgeInsets.all(spacingUnit(2)),
                          decoration: BoxDecoration(
                            borderRadius: ThemeRadius.medium,
                            color: Theme.of(context).colorScheme.primaryContainer,
                          ),
                          child: Column(children: [
                            Text('Still no luck? We can help!', style: ThemeText.subtitle.copyWith(color: colorScheme(context).onPrimaryContainer,)),
                            const SizedBox(height: 8),
                            const Text('Contact us and we’ll get back to you as soon as possible.', textAlign: TextAlign.center, style: ThemeText.paragraph,),
                            const VSpaceShort(),
                            SizedBox(
                              width: double.infinity,
                              height: 40,
                              child: OutlinedButton(
                                onPressed: () {
                                  Get.toNamed(AppLink.contact);
                                },
                                style: ThemeButton.outlinedPrimary(context),
                                child: const Text('CONTACT US'),
                              ),
                            )
                          ],)
                        ),
                      ],
                    ),
                  ),
                )
              ),
            ),
          ],
        ),
      ),
    );
  }
}