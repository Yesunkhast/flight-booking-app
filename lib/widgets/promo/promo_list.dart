import 'package:flight_app/app/app_link.dart';
import 'package:flight_app/app/service.dart';
import 'package:flight_app/models/realModel/post.dart';
import 'package:flight_app/widgets/cards/post_card.dart';
import 'package:flutter/material.dart';
// import 'package:flight_app/models/promo.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:get/get.dart';

class PromoList extends StatelessWidget {
  const PromoList({super.key, required this.items, this.isHome = false});

  final List<Post> items;
  final bool isHome;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      padding: EdgeInsets.only(
          top: spacingUnit(2),
          left: spacingUnit(2),
          right: spacingUnit(2),
          bottom: isHome ? 100 : spacingUnit(1)),
      itemCount: items.length,
      itemBuilder: (BuildContext context, int index) {
        Post item = items[index];
        return Padding(
          padding: EdgeInsets.only(bottom: spacingUnit(1)),
          child: PostCard(
            title: item.title,
            liked: false,
            image: item.image,
            desc: item.description,
            time: item.createdAt.toString(),
            onTap: () {
              print('Tapped on ${item.title}');
              // NotificationService.instance.showNotification(
              //   title: item.title,
              //   body: item.description,
              //   payload: AppLink.home,
              // );
              Get.toNamed(AppLink.promoDetail, arguments: item);
            },
          ),
        );
      },
    );
  }
}
