import 'package:flight_app/app/controller/notification_controller.dart';
import 'package:flight_app/models/realModel/notification.dart';
import 'package:flight_app/screens/messages/notification_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/route_manager.dart';
import 'package:flight_app/models/chat.dart';
import 'package:flight_app/ui/themes/theme_palette.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/ui/themes/theme_text.dart';
import 'package:flight_app/widgets/chat/chat_list.dart';

class Notification extends StatefulWidget {
  const Notification({super.key});

  @override
  State<Notification> createState() => _NotificationState();
}

class _NotificationState extends State<Notification>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  final notifController = Get.find<NotificationController>();

  @override
  void initState() {
    super.initState();
    notifController.getNotifByDb();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    // print(result);
    return Scaffold(
        appBar: AppBar(
          forceMaterialTransparency: true,
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Icons.arrow_back_ios_new),
          ),
          title: Text('Notifications', style: ThemeText.subtitle),
          centerTitle: true,
          bottom: TabBar(
              controller: _tabController,
              indicatorColor: ThemePalette.primaryMain,
              labelColor: ThemePalette.primaryMain,
              tabAlignment: TabAlignment.start,
              unselectedLabelColor: Colors.grey.shade500,
              isScrollable: true,
              dividerHeight: 0,
              labelPadding: EdgeInsets.symmetric(horizontal: spacingUnit(3)),
              tabs: [
                Obx(() {
                  return Tab(
                    child: Row(children: [
                      Text('Messages'.toUpperCase(), style: ThemeText.subtitle),
                      SizedBox(width: spacingUnit(1)),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Text(notifController.notCount.value.toString(),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 14)),
                      )
                    ]),
                  );
                }),
                // Tab(
                //     child: Row(children: [
                //   Text('Messages'.toUpperCase(), style: ThemeText.subtitle),
                //   SizedBox(width: spacingUnit(1)),
                //   Container(
                //     padding: const EdgeInsets.all(6),
                //     decoration: const BoxDecoration(
                //       color: Colors.red,
                //       shape: BoxShape.circle,
                //     ),
                //     child: Text(notifController.notCount.value.toString(),
                //         style:
                //             const TextStyle(color: Colors.white, fontSize: 14)),
                //   )
                // ])),
                Tab(
                    child:
                        Text('Chat'.toUpperCase(), style: ThemeText.subtitle)),
              ]),
        ),
        body: Padding(
          padding: EdgeInsets.only(top: spacingUnit(2)),
          child: TabBarView(
            controller: _tabController,
            children: [
              NotificationsList(),
              ChatList(data: chatListPersonal),
            ],
          ),
        ));
  }
}
