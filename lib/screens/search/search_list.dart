// import 'package:flight_app/app/controllers.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/widgets/search_filter/city_list_autocomplete.dart';
import 'package:flight_app/widgets/search_filter/search_input.dart';
import 'package:flight_app/widgets/search_filter/search_tags.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:get/route_manager.dart';
// import 'package:flight_app/widgets/search_filter/';

class SearchList extends StatefulWidget {
  const SearchList({super.key});

  @override
  State<SearchList> createState() => _SearchListState();
}

class _SearchListState extends State<SearchList> {
  final TextEditingController _textRef = TextEditingController();

  bool _showList = false;

  // final controller = Get.find<FlightSearchController>();

  late String _type;
  @override
  void initState() {
    super.initState();
    _type = Get.arguments;
    _textRef.addListener(_checkTextLength);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _textRef.dispose();
    super.dispose();
  }

  void _checkTextLength() {
    setState(() {
      _showList = _textRef.text.length >= 3;
    });
  }

  List<String> list = [
    'Shanghai',
    'Beijing',
    'Guangzhou',
    'Shenzhen',
    'Chengdu',
    'Hangzhou',
    'Wuhan',
    'Xi\'an',
    'Nanjing',
    'Tianjin',
    'Chongqing',
    'Suzhou',
    'Qingdao',
    'Dalian',
    'Zhengzhou',
    'Shenyang',
    'Harbin',
    'Changsha',
    'Kunming',
    'Fuzhou'
  ];

  // void getCity(String city) {
  //   selectCity!(city);
  //   Get.back();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            forceMaterialTransparency: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new),
              onPressed: () {
                Get.back();
              },
            ),
            titleSpacing: 0,
            title: SearchInput(
              autofocus: true,
              textRef: _textRef,
              hintText: 'Search City or Airport',
            )),
        body: _showList
            ? CityListAutocomplete(keyword: _textRef.text, type: _type)
            // ListView.builder(
            //     itemCount: list
            //         .where((city) => city
            //             .toLowerCase()
            //             .contains(_textRef.text.toLowerCase()))
            //         .length,
            //     itemBuilder: (context, index) {
            //       final filteredList = list
            //           .where((city) => city
            //               .toLowerCase()
            //               .contains(_textRef.text.toLowerCase()))
            //           .toList();

            //       final city = filteredList[index];

            //       return ListTile(
            //         title: Text(city),
            //         onTap: () => _selectCity(city),
            //       );
            //     },
            //   )
            : ListView(children: [
                VSpaceShort(), //edgeer listruu damjuulj songson hotig avah
                TagHistory(),
                VSpaceShort(),
                TagTrending(),
                VSpaceShort(),
                TagChina(tagsList: list),
              ]));
  }
}
