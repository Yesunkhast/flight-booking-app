import 'package:flight_app/app/app_link.dart';
import 'package:flight_app/app/controller/flight_booking_controller.dart';
import 'package:flight_app/app/controller/flight_search_controller.dart';
import 'package:flight_app/app/controller/fligth_detail_controller.dart';
import 'package:flight_app/app/controller/order_controller.dart';
import 'package:flight_app/app/controller/passenger_controller.dart';
import 'package:flight_app/app/controller/payment_controller.dart';
import 'package:flight_app/app/controller/user_controller.dart';
import 'package:flight_app/app/data/database/database_service.dart';
import 'package:flight_app/app/service.dart';
import 'package:flight_app/l10n/app_localizations.dart';
import 'package:flight_app/models/booking.dart';
import 'package:flight_app/models/realModel/passenger.dart';
import 'package:flight_app/ui/themes/theme_breakpoints.dart';
import 'package:flight_app/ui/themes/theme_button.dart';
import 'package:flight_app/ui/themes/theme_palette.dart';
// import 'package:flight_app/ui/themes/theme_palette.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/ui/themes/theme_text.dart';
import 'package:flight_app/widgets/booking/price_info.dart';
import 'package:flight_app/widgets/stepper/step_progress.dart';
import 'package:flight_app/widgets/flight/info_header.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_form_builder/flutter_form_builder.dart';
// import 'package:form_builder_validators/form_builder_validators.dart';
// import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart';
// import 'package:flight_app/app/controller/fligth_detail_controller.dart';
// import 'package:flight_app/widgets/booking/review_order.dart';
// import 'package:flight_app/models/city.dart';

class BookingCheckout extends StatefulWidget {
  const BookingCheckout({super.key});

  @override
  State<BookingCheckout> createState() => _BookingCheckoutState();
}

class _BookingCheckoutState extends State<BookingCheckout> {
  final bookingController = Get.find<BookingController>();
  final searchController = Get.find<FlightSearchController>();
  final detailController = Get.find<FlightDetailController>;
  final passengerController = Get.find<PassengerController>();
  final paymentController = Get.find<PaymentController>();
  final userController = Get.find<UserController>();
  final orderController = Get.find<OrderController>();
  int get bid => bookingController.bookingResult.value?.bookingStrId ?? 0;
  String get contactMob => userController.user.value?.phone ?? '';
  String get email => userController.user.value?.email ?? '';
  String get nctype => bookingController.bookingResult.value?.nctype ?? '';
  String get tag => bookingController.flight.value?.tag ?? '';
  List<Passenger> get passengers => passengerController.passengers;
  final bool isAccepted = false;
  final now = DateTime.now();

  @override
  void initState() {
    super.initState();
    print("booking checkoutoid: ${paymentController.oid.value}");
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // bookingController.getExchangeRate();
      // paymentController.createOrder(
      //     bid: bid,
      //     contactMob: contactMob,
      //     email: email,
      //     passengers: passengers,
      //     nctype: nctype,
      //     flightType: "3",
      //     tag: tag);
      await paymentController.getOrderInfo(paymentController.oid.value);

      await paymentController.getAccountInfo();
    });
  }

  Future<void> _onSubmit() async {
    await paymentController.checkPayment(paymentController.oid.value);
    paymentController.startPaymentCheck(paymentController.oid.value);
    paymentController.restartPaymentCheck(paymentController.oid.value);

    await orderController.registerOrderToDB(
        userController.user.value!.id, paymentController.oid.value);
  }

  @override
  Widget build(BuildContext context) {
    print("oid from checkout: ${paymentController.oid.value}");
    final localization = AppLocalizations.of(context)!;
    bool wideScreen = ThemeBreakpoints.smUp(context);
    // for (int i = 0; i < passengerController.bookingPassengers.length; i++) {
    //   print(
    //       "passenger ${i + 1}: ${passengerController.bookingPassengers[i].firstname}"); // print(passengerController.passengers.length);
    // }
    print(bookingController.bookingResult.value?.bookingStrId);

    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: InfoHeader(
            date: searchController.dateTo.value.isNotEmpty
                ? '${searchController.dateFrom.value} - ${searchController.dateTo.value}'
                : searchController.dateFrom.value,
            from: searchController.fromCode.value,
            to: searchController.toCode.value,
            passengers: searchController.totalPassenger(),
          ),
        ),
        body: Column(children: [
          StepProgress(activeIndex: 2, items: bookingSteps),
          const Divider(),
          Expanded(
            child: Column(children: [
              Obx(() {
                if (bookingController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                return ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: ThemeSize.sm),
                  child: PaymentInfoWidget(
                    mnt: bookingController.rate.value,
                  ),
                );
              }),
              const VSpaceShort(),
            ]),
          ),
          Padding(
              padding: EdgeInsets.all(spacingUnit(2)),
              child: Obx(() => CheckboxListTile(
                    activeColor: colorScheme(context).primary,
                    checkColor: colorScheme(context).onPrimary,
                    value: bookingController.isAccepted.value,
                    onChanged: null,
                    title: Text(localization.checkInfo),
                  ))),
          Padding(
            padding: EdgeInsets.only(
                left: spacingUnit(2),
                right: spacingUnit(2),
                top: spacingUnit(1),
                bottom: spacingUnit(4)),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: ThemeSize.sm),
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    wideScreen
                        ? SizedBox(
                            width: MediaQuery.of(context).size.width * 0.25)
                        : Container(),
                    // Column(
                    //   crossAxisAlignment: CrossAxisAlignment.end,
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     Text('lel',
                    //         textAlign: TextAlign.end,
                    //         style: ThemeText.headline.copyWith(
                    //             color: colorScheme(context).onSurfaceVariant,
                    //             decoration: TextDecoration.lineThrough,
                    //             height: 1)),
                    //     Text('lel',
                    //         textAlign: TextAlign.end,
                    //         style: ThemeText.title.copyWith(
                    //             color: colorScheme(context).primary,
                    //             height: 1,
                    //             fontWeight: FontWeight.bold)),
                    //   ],
                    // ),
                    // SizedBox(width: spacingUnit(4)),
                    Obx(() => Expanded(
                          child: SizedBox(
                            height: 50,
                            child: FilledButton(
                              onPressed: bookingController.isAccepted.value
                                  ? () {
                                      bookingController.isAccepted.value =
                                          false;
                                      NotificationService.instance
                                          .showNotification(
                                              title:
                                                  localization
                                                      .bookingNotificationTitle,
                                              body: localization
                                                  .bookingNotificationBody,
                                              type: "info");
                                      NotificationService.instance
                                          .scheduleAfterMinutes(
                                        title: localization.reminder,
                                        body: localization.bookingTimeUp,
                                        minutes: 1,
                                        payload: AppLink.payment,
                                      );

                                      Get.toNamed(AppLink.payment);

                                      _onSubmit();
                                    }
                                  : () {
                                      Get.toNamed(AppLink.checkout);
                                    },
                              style:
                                  ThemeButton.btnBig.merge(ThemeButton.primary),
                              child: Text(localization.pay,
                                  style: ThemeText.subtitle2),
                            ),
                          ),
                        )),
                  ]),
            ),
          )
        ]));
  }
}
