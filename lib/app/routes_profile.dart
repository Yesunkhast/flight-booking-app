import 'package:flight_app/app/app_link.dart';
import 'package:flight_app/ui/layouts/general_layout.dart';
import 'package:flight_app/screens/profile/detail_point.dart';
import 'package:flight_app/screens/profile/edit_password.dart';
import 'package:flight_app/screens/profile/edit_profile.dart';
import 'package:flight_app/screens/profile/profile_main.dart';
import 'package:flight_app/screens/profile/rewards.dart';
import 'package:flight_app/ui/layouts/home_layout.dart';
import 'package:get/route_manager.dart';

const int pageTransitionDuration = 200;

final List<GetPage> routesProfile = [
  GetPage(
    name: AppLink.profile,
    page: () => const HomeLayout(content: ProfileMain()),
    transition: Transition.fadeIn,
    transitionDuration: const Duration(milliseconds: pageTransitionDuration)
  ),
  GetPage(
    name: AppLink.reward,
    page: () => const GeneralLayout(content: Rewards()),
  ),
  GetPage(
    name: AppLink.detailPoint,
    page: () => const GeneralLayout(content: DetailPoint()),
  ),
  GetPage(
    name: AppLink.editProfile,
    page: () => const GeneralLayout(content: EditProfile()),
  ),
  GetPage(
    name: AppLink.editPassword,
    page: () => const GeneralLayout(content: EditPassword()),
  ),
];