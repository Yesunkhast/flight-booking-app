import 'package:flight_app/app/constants/img_api.dart';
import 'package:flight_app/app/controller/notification_controller.dart';
import 'package:flight_app/app/data/database/database_service.dart';
import 'package:flight_app/app/service.dart';
import 'package:flight_app/utils/no_data.dart';
import 'package:flutter/material.dart';
import 'package:flight_app/models/ggModel/notification.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/widgets/notifications/filters.dart';
import 'package:flight_app/widgets/notifications/notif_item.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
// import 'package:flight_app/app/app_link.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_navigation/src/extension_navigation.dart';

class NotificationsList extends StatefulWidget {
  const NotificationsList({
    super.key,
  });

  @override
  State<NotificationsList> createState() => _NotificationsListState();
}

class _NotificationsListState extends State<NotificationsList> {
  final notifController = Get.find<NotificationController>();
  // List _filteredItems = [];
  // String _selectedFilter = 'all';
  bool _isClear = false;

  // void handleFilter(String type) {
  //   var result = notifList.where((item) => item.type == type).toList();

  //   setState(() {
  // _selectedFilter = type;
  //     if (type != 'all') {
  //       _filteredItems = result;
  //     } else {
  //       _filteredItems = notifList;
  //     }
  //   });
  // }

  @override
  void initState() {
    setState(() {
      // _filteredItems = notifList;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    for (var item in notifController.notifications) {
      print("Notification: ${item.title}, ${item.body}");
    }
    // print("Notification list: ${notifController.notifications.}");
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx(() {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: spacingUnit(2)),
                child: Text('${notifController.notCount.value} Notifications'),
              );
            }),
            TextButton(
              onPressed: () {
                setState(() {
                  _isClear = true;
                  notifController.clearNotifications();
                  // _filteredItems = [];
                });
              },
              child: const Row(children: [
                Icon(Icons.clear_all_outlined, size: 18),
                SizedBox(
                  width: 4,
                ),
                Text('Clear All')
              ]),
            ),
          ],
        ),

        /// FILTER
        // Padding(
        //   padding: EdgeInsets.symmetric(vertical: spacingUnit(2)),
        //   child: NotificationFilters(
        //     selected: _selectedFilter,
        //     onChangeFilter: handleFilter,
        //   ),
        // ),

        /// NOTIFICATION ITEMS
        // _emptyList(context),
        _isClear
            ? _emptyList(context)
            : Obx(() {
                return Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      itemCount: notifController.notCount.value,
                      padding: EdgeInsets.only(bottom: spacingUnit(3)),
                      itemBuilder: ((BuildContext context, int index) {
                        final item = notifController.notifications[index];
                        return NotifItem(
                          type: item.type ?? "",
                          title: item.title,
                          subtitle: item.body,
                          date: item.sentAt.toString().substring(0, 16),
                          // image: item.image,
                          // isRead: item.isRead,
                          isLast: true,
                          // onTap: () { darah uyd medegdelii delgereh hesegtei holbohg function, onTap: () { Get.toNamed(AppLink.detailNotification, arguments: item);
                          //   Get.toNamed(AppLink.detailPoint, arguments: item);
                          // },
                        );
                      })),
                );
              }),
        // Expanded(
        //   child: ListView.builder(
        //       shrinkWrap: true,
        //       physics: const ClampingScrollPhysics(),
        //       itemCount: notifController.notCount.value,
        //       padding: EdgeInsets.only(bottom: spacingUnit(3)),
        //       itemBuilder: ((BuildContext context, int index) {
        //         final item = notifController.notifications[index];
        //         return NotifItem(
        //           type: item.type ?? "",
        //           title: item.title,
        //           subtitle: item.body,
        //           date: item.sentAt.toString().substring(0, 16),
        //           // image: item.image,
        //           // isRead: item.isRead,
        //           isLast: true,
        //           // onTap: () { darah uyd medegdelii delgereh hesegtei holbohg function, onTap: () { Get.toNamed(AppLink.detailNotification, arguments: item);
        //           //   Get.toNamed(AppLink.detailPoint, arguments: item);
        //           // },
        //         );
        //       })),
        // ),
      ],
    );
  }

  Widget _emptyList(BuildContext context) {
    return NoData(
      image: ImgApi.emptyNotification,
      title: 'All Clear Now',
      desc: 'Nulla condimentum pulvinar arcu a pellentesque.',
    );
  }
}
