import 'package:flight_app/app/routes_auth.dart';
import 'package:flight_app/app/routes_booking.dart';
import 'package:flight_app/app/routes_flight.dart';
import 'package:flight_app/app/routes_payment.dart';
import 'package:flight_app/app/routes_profile.dart';
import 'package:flight_app/app/routes_ui_collection.dart';
import 'package:flight_app/screens/explore/explore_main.dart';
import 'package:flight_app/screens/intro/intro_screen.dart';
import 'package:flight_app/screens/intro/start_screen.dart';
import 'package:flight_app/screens/messages/notification.dart';
import 'package:flight_app/screens/not_found.dart';
import 'package:flight_app/screens/orders/order_detail.dart';
import 'package:flight_app/screens/orders/order_list.dart';
import 'package:flight_app/screens/profile/contact.dart';
import 'package:flight_app/screens/profile/faq_list.dart';
import 'package:flight_app/screens/profile/terms_condition.dart';
import 'package:flight_app/screens/promo/promo_detail.dart';
import 'package:flight_app/screens/promo/promo_main.dart';
import 'package:flight_app/screens/promo/voucher_detail.dart';
import 'package:flight_app/screens/search/search_flight.dart';
import 'package:flight_app/screens/search/search_list.dart';
import 'package:flight_app/ui/layouts/general_layout.dart';
import 'package:flight_app/ui/layouts/home_layout.dart';
import 'package:get/route_manager.dart';
import 'package:flight_app/app/app_link.dart';

const int pageTransitionDuration = 200;

final List<GetPage> appRoutes = [
  /// HOME
  GetPage(
    name: AppLink.home,
    page: () => const StartScreen(),
    transition: Transition.fadeIn,
    transitionDuration: const Duration(milliseconds: pageTransitionDuration)
  ),
  GetPage(
    name: AppLink.intro,
    page: () => GeneralLayout(content: IntroScreen(saveIntroStatus: () {})),
  ),
  GetPage(
    name: AppLink.notification,
    page: () => const GeneralLayout(content: Notification()),
  ),
  GetPage(
    name: AppLink.faq,
    page: () => const GeneralLayout(content: FaqList()),
  ),
  GetPage(
    name: AppLink.contact,
    page: () => const GeneralLayout(content: Contact()),
  ),
  GetPage(
    name: AppLink.terms,
    page: () => const GeneralLayout(content: TermsCondition()),
  ),
  GetPage(
    name: AppLink.notFound,
    page: () => const GeneralLayout(content: NotFound()),
  ),

  // MY TICKET
  GetPage(
    name: AppLink.myTicket,
    page: () => const HomeLayout(content: OrderList()),
    transition: Transition.fadeIn,
    transitionDuration: const Duration(milliseconds: pageTransitionDuration)
  ),
  GetPage(
    name: AppLink.ticketDetail,
    page: () => const GeneralLayout(content: OrderDetail()),
  ),

  /// SEARCH
  GetPage(
    name: AppLink.searchFlight,
    page: () => const GeneralLayout(content: SearchFlight()),
  ),
  GetPage(
    name: AppLink.searchList,
    page: () => const GeneralLayout(content: SearchList()),
  ),

  /// EXPLORE
  GetPage(
    name: AppLink.explore,
    page: () => const HomeLayout(content: ExploreMain()),
    transition: Transition.fadeIn,
    transitionDuration: const Duration(milliseconds: pageTransitionDuration)
  ),

  /// PROMO
  GetPage(
    name: AppLink.promo,
    page: () => const HomeLayout(content: PromoMain()),
    transition: Transition.fadeIn,
    transitionDuration: const Duration(milliseconds: pageTransitionDuration)
  ),
  GetPage(
    name: AppLink.promoDetail,
    page: () => const GeneralLayout(content: PromoDetail()),
  ),
  GetPage(
    name: AppLink.voucherDetail,
    page: () => const GeneralLayout(content: VoucherDetail()),
  ),

  /// AUTH
  ...routesAuth,

  /// PROFILE
  ...routesProfile,

  /// FLIGHT LIST
  ...routesFlight,

  /// BOOKING
  ...routesBooking,

  /// PAYMENT
  ...routesPayment,

  /// SAMPLE UI
  ...routesUiCollection,
];