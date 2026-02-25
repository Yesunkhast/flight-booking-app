import 'package:flutter/material.dart';
import 'package:flight_app/ui/themes/theme_radius.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/ui/themes/theme_text.dart';
import 'package:flight_app/utils/expanded_section.dart';

class TagHistory extends StatelessWidget {
  const TagHistory({super.key});

  @override
  Widget build(BuildContext context) {
    final List tagsList = ['Tokyo', 'Bandung', 'Singapore', 'London', 'Mecca'];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: spacingUnit(1)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Search History',
              style: ThemeText.subtitle.copyWith(fontWeight: FontWeight.bold)),
          SizedBox(height: spacingUnit(1)),
          Wrap(
              alignment: WrapAlignment.start,
              children: tagsList
                  .map((item) => InkWell(
                        onTap: () {},
                        child: Container(
                          margin: const EdgeInsets.all(4),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                              borderRadius: ThemeRadius.big,
                              color: Theme.of(context)
                                  .colorScheme
                                  .outline
                                  .withValues(alpha: 0.5)),
                          child: Text(item),
                        ),
                      ))
                  .toList())
        ],
      ),
    );
  }
}

class TagTrending extends StatelessWidget {
  const TagTrending({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> tagsList = [
      'New York',
      'London',
      'Jakarta',
      'Singapore',
      'Beijing',
      'Tokyo',
      'Hong Kong',
      'Sydney',
      'Paris',
      'Dubai',
      'Bangkok',
      'Los Angeles',
      'Seoul',
      'Moscow',
      'Rome',
      'Istanbul',
      'Barcelona',
    ];

    // final visibleTags = tagsList.take(6).toList();
    // final remainingCount = tagsList.length - visibleTags.length;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: spacingUnit(1)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Trending Search',
            style: ThemeText.subtitle.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: spacingUnit(1)),
          Wrap(
              alignment: WrapAlignment.start,
              children: tagsList
                  .map((item) => InkWell(
                        onTap: () {},
                        child: Container(
                          margin: const EdgeInsets.all(4),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                              borderRadius: ThemeRadius.big,
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer),
                          child: Row(mainAxisSize: MainAxisSize.min, children: [
                            const Icon(Icons.trending_up),
                            const SizedBox(width: 2),
                            Text(item, style: ThemeText.paragraph)
                          ]),
                        ),
                      ))
                  .toList())
        ],
      ),
    );
  }
}

class TagChina extends StatefulWidget {
  const TagChina({
    super.key,
    this.tagsList,
  });
  final List<String>? tagsList;

  @override
  State<TagChina> createState() => _TagChinaState();
}

class _TagChinaState extends State<TagChina> {
  late bool _expand = false;

  void _setExpand(bool value) {
    setState(() {
      _expand = value;
    });
  }

  late List<String> listCity = [
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

  @override
  void initState() {
    super.initState();
    listCity = widget.tagsList ?? listCity;
  }

  List<String> get visibleTags => listCity.take(6).toList();

  Widget _buildChip(BuildContext context, String item) {
    return InkWell(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          borderRadius: ThemeRadius.big,
          color: Theme.of(context).colorScheme.primaryContainer,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.trending_up),
            const SizedBox(width: 2),
            Text(item, style: ThemeText.paragraph),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final remainingCities = listCity.skip(6).toList();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: spacingUnit(1)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Chine\'s Popular Cities',
            style: ThemeText.subtitle.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: spacingUnit(1)),
          Wrap(
            children: [
              // first 6 always visible
              ...visibleTags.map((item) => _buildChip(context, item)),

              // extra cities
              ExpandedSection(
                expand: _expand,
                child: Wrap(
                  children: remainingCities
                      .map((item) => _buildChip(context, item))
                      .toList(),
                ),
              ),

              // Toggle Button
              if (remainingCities.isNotEmpty)
                InkWell(
                  onTap: () {
                    _setExpand(!_expand);
                  },
                  child: Container(
                    margin: const EdgeInsets.all(4),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      borderRadius: ThemeRadius.big,
                      color: Theme.of(context).colorScheme.primaryContainer,
                    ),
                    child: Text(
                      _expand ? "Show Less..." : "Show More...",
                      style: ThemeText.paragraph,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}



//                       ExpandedSection(
//                         expand: false,
//                         child: Container(),
//                       )

// class TagTrending extends StatelessWidget {
//   const TagTrending({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final List tagsList = [
//       'New York',
//       'London',
//       'Jakarta',
//       'Singapore',
//       'Beijing'
//     ];

//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: spacingUnit(1)),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text('Trending Search',
//               style: ThemeText.subtitle.copyWith(fontWeight: FontWeight.bold)),
//           SizedBox(height: spacingUnit(1)),
//           Wrap(
//               alignment: WrapAlignment.start,
//               children: tagsList
//                   .map((item) => InkWell(
//                         onTap: () {},
//                         child: Container(
//                           margin: const EdgeInsets.all(4),
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 8, vertical: 2),
//                           decoration: BoxDecoration(
//                               borderRadius: ThemeRadius.big,
//                               color: Theme.of(context)
//                                   .colorScheme
//                                   .primaryContainer),
//                           child: Row(mainAxisSize: MainAxisSize.min, children: [
//                             const Icon(Icons.trending_up),
//                             const SizedBox(width: 2),
//                             Text(item, style: ThemeText.paragraph)
//                           ]),
//                         ),
//                       ))
//                   .toList())
          // if (remainingCount > 0)
          //   InkWell(
          //     onTap: () {
          //       showModalBottomSheet(
          //         context: context,
          //         builder: (_) => Wrap(
          //           runSpacing: (10),
          //           spacing: (6),
          //           alignment: WrapAlignment.start,
          //           children: tagsList
          //               .map(
          //                 (tag) => InkWell(
          //                   onTap: () {},
          //                   child: Container(
          //                     margin: const EdgeInsets.all(4),
          //                     padding: const EdgeInsets.symmetric(
          //                         horizontal: 8, vertical: 2),
          //                     decoration: BoxDecoration(
          //                       borderRadius: ThemeRadius.big,
          //                       color: Theme.of(context)
          //                           .colorScheme
          //                           .primaryContainer,
          //                     ),
          //                     child: Row(
          //                       mainAxisSize: MainAxisSize.min,
          //                       children: [
          //                         const Icon(Icons.trending_up, size: 16),
          //                         const SizedBox(width: 2),
          //                         Text(tag, style: ThemeText.paragraph),
          //                       ],
          //                     ),
          //                   ),
          //                 ),
          //               )
          //               .toList(),
          //         ),
          //       );
          //     },
          //     child: Container(
          //       margin: const EdgeInsets.all(4),
          //       padding:
          //           const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          //       decoration: BoxDecoration(
          //         borderRadius: ThemeRadius.big,
          //         color: Theme.of(context).colorScheme.secondaryContainer,
          //       ),
          //       child: Text(
          //         "+$remainingCount more",
          //         style: ThemeText.paragraph,
          //       ),
          //     ),
          //   ),
//         ],
//       ),
//     );
//   }
// }
