// import 'package:flight_app/models/voucher.dart';
// import 'package:flight_app/widgets/promo/promo_voucher_grid.dart';
// import 'package:flight_app/widgets/promo/promo_voucher_list.dart';
// import 'package:flight_app/widgets/promo/tab_menu_promo.dart';
import 'package:flight_app/app/constants/app_const.dart';
import 'package:flight_app/app/controller/post_controller.dart';
import 'package:flight_app/l10n/app_localizations.dart';
import 'package:flight_app/models/realModel/post.dart';
import 'package:flight_app/ui/themes/theme_breakpoints.dart';
import 'package:flight_app/ui/themes/theme_palette.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/ui/themes/theme_text.dart';
import 'package:flight_app/widgets/promo/promo_grid.dart';
import 'package:flutter/material.dart';
import 'package:flight_app/models/promo.dart';
import 'package:flight_app/widgets/promo/promo_list.dart';
import 'package:flight_app/widgets/search_filter/search_input_btn.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';

class NewsMain extends StatefulWidget {
  const NewsMain({super.key});

  @override
  State<NewsMain> createState() => _NewsMainState();
}

class _NewsMainState extends State<NewsMain> {
  bool _showSearch = false;
  int current = 0;
  final postController = Get.find<PostController>();

  @override
  void initState() {
    super.initState();
    postController.fetchPosts();
  }

  List<Post> get postList => postController.posts;

  late final List<Widget> _tabContentList = <Widget>[
    PromoList(items: postList, isHome: true),
    // PromoVoucherList(dataList: voucherList)
  ];

  // late final List<Widget> _tabContentGrid = <Widget>[
  //   PromoGrid(items: postList, isHome: true),
  //   // PromoVoucherGrid(dataList: voucherList)
  // ];

  void toggleSearch() {
    setState(() {
      _showSearch = !_showSearch;
    });
  }

  // void _changeMenu(int index) {
  //   setState(() {
  //     _current = index;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 60,
          forceMaterialTransparency: true,
          backgroundColor: colorScheme(context).surface,
          titleSpacing: 0,
          automaticallyImplyLeading: false,
          centerTitle: true,

          /// TITLE AND SEARCH
          title: _showSearch
              ? Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: spacingUnit(2), horizontal: spacingUnit(2)),
                  child: SearchInputBtn(
                    location: '/search-list',
                    title: localization.search,
                    onCancel: () {
                      toggleSearch();
                    },
                  ),
                )
              : Text(
                  localization.news,
                  style: ThemeText.title2,
                ),
          actions: [
            /// SEARCH BUTTON
            !_showSearch
                ? IconButton(
                    icon: const Icon(Icons.search, size: 40),
                    onPressed: () {
                      toggleSearch();
                    },
                  )
                : Container(),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(20.0),
            child: DecoratedBox(
              decoration: BoxDecoration(
                  color: colorScheme(context).surfaceContainerLowest),
              child: Column(children: [
                Text('${localization.checkAllNews} ${branding.name}'),
                // TabMenuPromo(onSelect: _changeMenu, current: _current)
              ]),
            ),
          ),
        ),
        body: RefreshIndicator(
            onRefresh: () async {
              await postController.fetchPosts(); // Cache-ийг алгасна
            },
            child: _tabContentList[current]));
    //  ThemeBreakpoints.smUp(context)
    //     ? _tabContentGrid[current]
    //     : _tabContentList[current]);
  }
}
