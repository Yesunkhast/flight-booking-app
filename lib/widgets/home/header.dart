import 'package:flight_app/app/app_link.dart';
import 'package:flight_app/app/controller/location_controller.dart';
import 'package:flight_app/app/controller/notification_controller.dart';
import 'package:flight_app/app/controller/user_controller.dart';
import 'package:flight_app/app/data/database/database_service.dart';
import 'package:flight_app/l10n/app_localizations.dart';
import 'package:flight_app/models/realModel/notification.dart';
import 'package:flight_app/ui/themes/theme_palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flight_app/widgets/action_header/home_action_group.dart';
import 'package:flight_app/ui/themes/theme_radius.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/ui/themes/theme_text.dart';
// import 'package:flight_app/utils/custom_tooltip.dart';
// import 'package:flight_app/app/constants/app_const.dart';
// import 'package:overlay_tooltip/overlay_tooltip.dart';

class HomeHeader extends StatefulWidget {
  const HomeHeader({super.key, this.isFixed = false});

  final bool isFixed;

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  final LocationController controller = Get.find<LocationController>();
  final notifController = Get.find<NotificationController>();

  final UserController userController = Get.find<UserController>();

  @override
  void initState() {
    super.initState();
    notifController.getNotifByDb();
  }

  @override
  Widget build(BuildContext context) {
    print(notifController.notifications.length);
    final localization = AppLocalizations.of(context)!;
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      toolbarHeight: 60,
      scrolledUnderElevation: 0.0,
      forceMaterialTransparency: true,
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      titleSpacing: spacingUnit(1),
      flexibleSpace: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        color:
            widget.isFixed ? colorScheme(context).surface : Colors.transparent,
      ),
      title: GestureDetector(
        onTap: () {
          Get.toNamed(AppLink.profile);
        },
        child: Row(
          children: [
            Obx(() => CircleAvatar(
                  radius: 24,
                  backgroundImage: (userController.user.value?.image != null &&
                          userController.user.value!.image.isNotEmpty)
                      ? NetworkImage(userController.user.value!.image)
                      : null,
                  child: (userController.user.value?.image == null ||
                          userController.user.value!.image.isEmpty)
                      ? const Icon(Icons.person)
                      : null,
                )),
            SizedBox(width: spacingUnit(1)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () => Text(
                    //first last name soligdtson?
                    userController.user.value?.firstName ??
                        localization.guestUser,
                    style: ThemeText.title2.copyWith(
                      color: widget.isFixed
                          ? colorScheme(context).onSurface
                          : Colors.white,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  padding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 4),
                  decoration: BoxDecoration(
                    borderRadius: ThemeRadius.small,
                    color: colorScheme(context).surface.withValues(alpha: 0.8),
                  ),
                  child: Obx(() {
                    final city = controller.city.value;
                    final country = controller.country.value;
                    final loading = controller.isLoading.value;

                    return Row(
                      children: [
                        const Icon(Icons.location_on,
                            size: 12, color: Colors.red),
                        const SizedBox(width: 2),
                        Text(
                          loading
                              ? 'Locating...'
                              : city.isNotEmpty && country.isNotEmpty
                                  ? '$city • $country'
                                  : 'Location unavailable',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ],
            )
          ],
        ),
      ),
      actions: [
        // OverlayTooltipItem(
        //   displayIndex: 2,
        //   tooltip: (controller) => Padding(
        //     padding: const EdgeInsets.only(right: 15),
        //     child: MTooltip(
        //       title: 'Check messages, the best deals, or notification here.',
        //       controller: controller,
        //     ),
        //   ),
        //   child: Badge.count(
        //     backgroundColor: Colors.red,
        //     count: 3,
        //     offset: const Offset(0, -1),
        //     child: iconBtn(
        //       context,
        //       Icons.notifications,
        //       isFixed,
        //       () {
        //         Get.toNamed(AppLink.notification);
        //       },
        //     ),
        //   ),
        // ),

        Obx(() {
          return notifController.notCount.value == 0
              ? iconBtn(
                  context,
                  Icons.notifications,
                  widget.isFixed,
                  () {
                    Get.toNamed(AppLink.notification,
                        arguments: notifController.notifications);
                  },
                )
              : Badge.count(
                  backgroundColor: Colors.red,
                  count: notifController.notCount.value,
                  offset: const Offset(0, -1),
                  child: iconBtn(
                    context,
                    Icons.notifications,
                    widget.isFixed,
                    () async {
                      Get.toNamed(AppLink.notification, arguments: [
                        notifController.notifications,
                        notifController.notCount.value
                      ]);
                    },
                  ),
                );
        }),
        // Badge.count(
        //   backgroundColor: Colors.red,
        //   count: (await getNotifByDb()).length,
        //   offset: const Offset(0, -1),
        //   child: iconBtn(
        //     context,
        //     Icons.notifications,
        //     isFixed,
        //     () {
        //       Get.toNamed(AppLink.notification);
        //     },
        //   ),
        // ),
        iconBtn(
          context,
          Icons.help,
          widget.isFixed,
          () {
            Get.toNamed(AppLink.faq);
          },
        )
      ],
    );
  }
}
