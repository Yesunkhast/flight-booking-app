// import 'package:flight_app/models/booking.dart';
// import 'package:flight_app/widgets/booking/tag_filter.dart';
import 'package:flight_app/app/app_link.dart';
import 'package:flight_app/app/constants/img_api.dart';
import 'package:flight_app/app/controller/order_controller.dart';
import 'package:flight_app/app/controller/user_controller.dart';
import 'package:flight_app/l10n/app_localizations.dart';
import 'package:flight_app/ui/themes/theme_button.dart';
import 'package:flight_app/ui/themes/theme_palette.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/ui/themes/theme_text.dart';
import 'package:flight_app/utils/no_data.dart';
import 'package:flight_app/widgets/booking/ticket_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/route_manager.dart';

class OrderList extends StatefulWidget {
  const OrderList({super.key});

  @override
  State<OrderList> createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  final orderController = Get.find<OrderController>();
  final userController = Get.find<UserController>();

  @override
  void initState() {
    super.initState();
    fetchOrders();
    // print("order: ${orderController.orderResponse.first.result.email}");
  }

  Future<void> fetchOrders() async {
    await orderController.getOrderNumber(userController.user.value!.id);
    await orderController.getOrders();
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return Scaffold(
      extendBody: true,
      body: RefreshIndicator(
        onRefresh: () async {
          await orderController.getOrders(
              forceRefresh: true); // Cache-ийг алгасна
        },
        child: CustomScrollView(
          slivers: <Widget>[
            /// SLIVER APPBAR AND BANNER
            SliverAppBar(
              expandedHeight: 250.0,
              collapsedHeight: 120,
              floating: true,
              pinned: true,
              toolbarHeight: 100,
              centerTitle: false,
              backgroundColor: colorScheme(context).primary,
              automaticallyImplyLeading: false,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: EdgeInsets.all(spacingUnit(2)),
                background: Image.asset(
                  ImgApi.myTicketBanner,
                  fit: BoxFit.cover,
                  alignment: Alignment.topRight,
                ),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// INFO
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: spacingUnit(2), vertical: spacingUnit(1)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(localization.myOrders,
                                  style: ThemeText.title
                                      .copyWith(color: Colors.white)),
                              Row(
                                children: [
                                  Text(localization.request,
                                      style: ThemeText.paragraph
                                          .copyWith(color: Colors.white)),
                                  SizedBox(width: spacingUnit(1)),
                                  SizedBox(
                                    width: 32,
                                    height: 32,
                                    child: IconButton(
                                        onPressed: () {
                                          Get.toNamed(AppLink.request);
                                        },
                                        style: ThemeButton.iconBtn(context),
                                        icon: Icon(Icons.message,
                                            color: colorScheme(context).primary,
                                            size: 24)),
                                  )
                                ],
                              ),
                            ],
                          ),
                          Text(localization.allYourOrders,
                              textAlign: TextAlign.start,
                              style: ThemeText.headline
                                  .copyWith(color: Colors.white)),
                        ],
                      ),
                    ),

                    /// DECORATION
                    // Container(
                    //     width: double.infinity,
                    //     height: 70,
                    //     decoration: BoxDecoration(
                    //       color: colorScheme(context).surfaceContainerLowest,
                    //       borderRadius: const BorderRadius.vertical(
                    //         top: Radius.circular(16),
                    //       ),
                    //       boxShadow: [
                    //         BoxShadow(
                    //             color:
                    //                 colorScheme(context).surfaceContainerLowest,
                    //             offset: const Offset(0, 2),
                    //             blurRadius: 0,
                    //             spreadRadius: 0)
                    //       ],
                    //     ),
                    //     child: Padding(
                    //       padding: EdgeInsets.only(
                    //           top: spacingUnit(3), bottom: spacingUnit(2)),
                    //       child: const TagFilter(),
                    //     ))
                  ],
                ),
              ),
            ),

            /// CONTENT
            SliverToBoxAdapter(
              child: Obx(() {
                if (orderController.isLoading.value) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (orderController.orderResponse.isEmpty) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: NoData(
                      image: ImgApi.emptyNotFound,
                      title: localization.orderNotFound,
                      desc: '',
                      primaryAction: () {
                        Get.toNamed(AppLink.home);
                      },
                      primaryTxtBtn: localization.backToHome,
                    ),
                  );
                }
                return Column(
                  children: [
                    SizedBox(height: spacingUnit(1)),
                    TicketList(bookingList: orderController.orderResponse),
                    // Container(
                    //   padding: EdgeInsets.symmetric(horizontal: spacingUnit(2)),
                    //   width: double.infinity,
                    //   child: OutlinedButton(
                    //       onPressed: () {
                    //         Get.toNamed(AppLink.searchFlight);
                    //       },
                    //       style: ThemeButton.btnBig
                    //           .merge(ThemeButton.outlinedPrimary(context)),
                    //       child: const Text('CHECK & ADD MORE TICKET')),
                    // ),
                    const SizedBox(height: 160)
                  ],
                );
              }),
            )
          ],
        ),
      ),
    );
  }
}
