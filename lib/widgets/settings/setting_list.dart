import 'package:flight_app/app/app_link.dart';
import 'package:flight_app/app/controller/user_controller.dart';
import 'package:flight_app/app/data/database/database_service.dart';
import 'package:flight_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/state_manager.dart';
import 'package:get/route_manager.dart';
import 'package:flight_app/app/constants/app_const.dart';
import 'package:flight_app/ui/themes/theme_palette.dart';
import 'package:flight_app/widgets/cards/paper_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/ui/themes/theme_text.dart';
import 'package:flight_app/widgets/settings/account_info.dart';
import 'package:flight_app/widgets/title/title_basic.dart';
import 'package:flight_app/app/controller/auth_controller.dart';

class SettingList extends StatelessWidget {
  SettingList({super.key}) {
    _getThemeStatus();
  }

  Future<void> _logout() async {
    final userController = Get.find<UserController>();
    userController.userIsAvailable = false;
    await DatabaseService.instance.deletedb();
    await Get.find<AuthController>().logout();
  }

  final RxString _themeMode = 'auto'.obs;

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> _getThemeStatus() async {
    var mode = _prefs.then((SharedPreferences prefs) {
      return prefs.getString('appTheme') ?? 'auto';
    }).obs;

    _themeMode.value = await mode.value;
  }

  Future<void> _saveThemeStatus(String val) async {
    SharedPreferences pref = await _prefs;

    _themeMode.value = val;

    switch (val) {
      case 'dark':
        pref.setString('appTheme', val);
        Get.changeThemeMode(ThemeMode.dark);
        break;
      case 'light':
        pref.setString('appTheme', 'light');
        Get.changeThemeMode(ThemeMode.light);
        break;
      default:
        pref.setString('appTheme', 'auto');
        pref.remove('appTheme');

        var brightness =
            SchedulerBinding.instance.platformDispatcher.platformBrightness;
        bool isDarkMode = brightness == Brightness.dark;
        Get.changeThemeMode(isDarkMode ? ThemeMode.dark : ThemeMode.light);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return ListView(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        padding: EdgeInsets.all(spacingUnit(2)),
        children: [
          /// UI SETTINGS
          TitleBasicSmall(title: localization.uiSettings),
          PaperCard(
              content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: [
              ListTile(
                leading: const Icon(Icons.brightness_6_outlined),
                title: Text(localization.auto),
                onTap: () {
                  _saveThemeStatus('auto');
                },
                trailing: Obx(() => _themeMode.value == 'auto'
                    ? Icon(Icons.check_circle, color: ThemePalette.primaryMain)
                    : const Icon(Icons.circle_outlined)),
              ),
              const LineList(),
              ListTile(
                leading: const Icon(Icons.dark_mode),
                title: Text(localization.darkMode),
                onTap: () {
                  _saveThemeStatus('dark');
                },
                trailing: Obx(() => _themeMode.value == 'dark'
                    ? Icon(Icons.check_circle, color: ThemePalette.primaryMain)
                    : const Icon(Icons.circle_outlined)),
              ),
              const LineList(),
              ListTile(
                leading: const Icon(Icons.light_mode),
                title: Text(localization.lightMode),
                onTap: () {
                  _saveThemeStatus('light');
                },
                trailing: Obx(() => _themeMode.value == 'light'
                    ? Icon(Icons.check_circle, color: ThemePalette.primaryMain)
                    : const Icon(Icons.circle_outlined)),
              ),
              const LineList(),
              ListTile(
                leading: const Icon(Icons.language),
                title: Text(localization.language),
                trailing: const Icon(Icons.arrow_forward_ios, size: 12),
                onTap: () {
                  Get.toNamed('/language');
                },
              ),
            ]),
          )),
          const VSpace(),

          /// AUTH PAGES
          TitleBasicSmall(title: localization.auth),
          PaperCard(
              content: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(children: [
                    ListTile(
                      leading: const Icon(Icons.waving_hand_outlined),
                      title: Text(localization.welcomePage),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 12),
                      onTap: () {
                        Get.toNamed('/welcome');
                      },
                    ),
                    const LineList(),
                    ListTile(
                      leading: const Icon(Icons.account_circle_outlined),
                      title: Text(localization.login.toUpperCase()),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 12),
                      onTap: () {
                        Get.toNamed('/login');
                      },
                    ),
                    const LineList(),
                    ListTile(
                      leading: const Icon(Icons.account_box_outlined),
                      title: Text(localization.register.toUpperCase()),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 12),
                      onTap: () {
                        Get.toNamed('/register');
                      },
                    ),
                    // const LineList(),
                    // ListTile(
                    //   leading: const Icon(Icons.pin),
                    //   title: const Text('Pin OTP'),
                    //   trailing: const Icon(Icons.arrow_forward_ios, size: 12),
                    //   onTap: () {
                    //     Get.toNamed('/otp');
                    //   },
                    // ),
                    const LineList(),
                    ListTile(
                      leading: const Icon(Icons.key_sharp),
                      title: Text(localization.resetPassword),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 12),
                      onTap: () {
                        Get.toNamed('/reset-password');
                      },
                    ),
                  ]))),
          const VSpace(),

          // /// ACCOUNT SETTING
          TitleBasicSmall(title: localization.helpAndAccount),
          PaperCard(
              content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: [
              ListTile(
                leading: const Icon(Icons.person),
                title: Text(localization.accountInformation),
                trailing: const Icon(Icons.arrow_forward_ios, size: 12),
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (BuildContext context) {
                        return const Wrap(
                          children: [AccountInfo()],
                        );
                      });
                },
              ),
              const LineList(),
              ListTile(
                onTap: () {
                  Get.toNamed('/faq');
                },
                leading: const Icon(Icons.help_outline),
                title: Text(localization.faq),
                trailing: const Icon(Icons.arrow_forward_ios, size: 12),
              ),
              const LineList(),
              ListTile(
                onTap: () {
                  Get.toNamed('/contact');
                },
                leading: const Icon(Icons.message_outlined),
                title: Text(localization.contactAdmin),
                trailing: const Icon(Icons.arrow_forward_ios, size: 12),
              ),
              const LineList(),
              ListTile(
                onTap: () {
                  Get.toNamed('/terms-conditions');
                },
                leading: const Icon(Icons.insert_drive_file_outlined),
                title: Text(localization.termsAndConditions),
                trailing: const Icon(Icons.arrow_forward_ios, size: 12),
              ),
            ]),
          )),
          const VSpace(),

          // /// GENERAL PAGES
          // const TitleBasicSmall(title: 'General Pages'),
          // PaperCard(
          //     content: Padding(
          //         padding: const EdgeInsets.all(8.0),
          //         child: Column(children: [
          //           ListTile(
          //             leading: const Icon(Icons.notifications_on_rounded),
          //             title: const Text('Notification'),
          //             trailing: const Icon(Icons.arrow_forward_ios, size: 12),
          //             onTap: () {
          //               Get.toNamed(AppLink.notification);
          //             },
          //           ),
          //           const LineList(),
          //           ListTile(
          //             leading: const Icon(Icons.flag),
          //             title: const Text('Intro'),
          //             trailing: const Icon(Icons.arrow_forward_ios, size: 12),
          //             onTap: () {
          //               Get.toNamed(AppLink.intro);
          //             },
          //           ),
          //           const LineList(),
          //           ListTile(
          //             leading: const Icon(Icons.store_mall_directory),
          //             title: const Text('Home Page'),
          //             trailing: const Icon(Icons.arrow_forward_ios, size: 12),
          //             onTap: () {
          //               Get.toNamed(AppLink.home);
          //             },
          //           ),
          //           const LineList(),
          //           ListTile(
          //             leading: const Icon(Icons.search),
          //             title: const Text('Search Flight'),
          //             trailing: const Icon(Icons.arrow_forward_ios, size: 12),
          //             onTap: () {
          //               Get.toNamed(AppLink.searchFlight);
          //             },
          //           ),
          //           const LineList(),
          //           ListTile(
          //             leading: const Icon(Icons.search),
          //             title: const Text('Search List'),
          //             trailing: const Icon(Icons.arrow_forward_ios, size: 12),
          //             onTap: () {
          //               Get.toNamed(AppLink.searchList);
          //             },
          //           ),
          //           const LineList(),
          //           ListTile(
          //             leading: const Icon(Icons.crop_square_sharp),
          //             title: const Text('Not Found'),
          //             trailing: const Icon(Icons.arrow_forward_ios, size: 12),
          //             onTap: () {
          //               Get.toNamed(AppLink.notFound);
          //             },
          //           ),
          //         ]))),
          // const VSpace(),

          // /// PAGE FLIGHT LIST
          // const TitleBasicSmall(title: 'Flights'),
          // PaperCard(
          //     content: Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Column(children: [
          //     ListTile(
          //       leading: const Icon(Icons.list_alt_outlined),
          //       title: const Text('Flight List'),
          //       trailing: const Icon(Icons.arrow_forward_ios, size: 12),
          //       onTap: () {
          //         Get.toNamed(AppLink.flightList);
          //       },
          //     ),
          //     const LineList(),
          //     ListTile(
          //       leading: const Icon(Icons.list_alt_outlined),
          //       title: const Text('Flight List Round Trip'),
          //       trailing: const Icon(Icons.arrow_forward_ios, size: 12),
          //       onTap: () {
          //         Get.toNamed(AppLink.flightListRoundTrip);
          //       },
          //     ),
          //     const LineList(),
          //     ListTile(
          //       leading: const Icon(Icons.flight),
          //       title: const Text('Flight Detail'),
          //       trailing: const Icon(Icons.arrow_forward_ios, size: 12),
          //       onTap: () {
          //         Get.toNamed(AppLink.flightDetail);
          //       },
          //     ),
          //     const LineList(),
          //     ListTile(
          //       leading: const Icon(Icons.flight_takeoff_sharp),
          //       title: const Text('Flight Package Detail'),
          //       trailing: const Icon(Icons.arrow_forward_ios, size: 12),
          //       onTap: () {
          //         Get.toNamed(AppLink.flightDetailPackage);
          //       },
          //     ),
          //     const LineList(),
          //     ListTile(
          //       leading: const Icon(Icons.explore_outlined),
          //       title: const Text('Explore'),
          //       trailing: const Icon(Icons.arrow_forward_ios, size: 12),
          //       onTap: () {
          //         Get.toNamed(AppLink.explore);
          //       },
          //     ),
          //     const LineList(),
          //     ListTile(
          //       leading: const Icon(Icons.airplanemode_inactive_rounded),
          //       title: const Text('Flight Not Found'),
          //       trailing: const Icon(Icons.arrow_forward_ios, size: 12),
          //       onTap: () {
          //         Get.toNamed(AppLink.flightNotFound);
          //       },
          //     ),
          //     const LineList(),
          //     ListTile(
          //       leading: const Icon(Icons.label_off_rounded),
          //       title: const Text('Package Not Found'),
          //       trailing: const Icon(Icons.arrow_forward_ios, size: 12),
          //       onTap: () {
          //         Get.toNamed(AppLink.packageNotFound);
          //       },
          //     ),
          //   ]),
          // )),
          // const VSpace(),

          // /// BOOKING
          // const TitleBasicSmall(title: 'Booking'),
          // PaperCard(
          //     content: Padding(
          //         padding: const EdgeInsets.all(8.0),
          //         child: Column(children: [
          //           ListTile(
          //             leading: const Icon(Icons.person_4_rounded),
          //             title: const Text('Booking Passenger'),
          //             trailing: const Icon(Icons.arrow_forward_ios, size: 12),
          //             onTap: () {
          //               Get.toNamed(AppLink.bookingStep1);
          //             },
          //           ),
          //           const LineList(),
          //           ListTile(
          //             leading: const Icon(Icons.business_center_rounded),
          //             title: const Text('Booking Facility'),
          //             trailing: const Icon(Icons.arrow_forward_ios, size: 12),
          //             onTap: () {
          //               Get.toNamed(AppLink.bookingStep2);
          //             },
          //           ),
          //           const LineList(),
          //           ListTile(
          //             leading: const Icon(Icons.check_box_outlined),
          //             title: const Text('Booking Checkout'),
          //             trailing: const Icon(Icons.arrow_forward_ios, size: 12),
          //             onTap: () {
          //               Get.toNamed(AppLink.bookingStep3);
          //             },
          //           ),
          //           const LineList(),
          //           ListTile(
          //             leading: const Icon(Icons.person_add),
          //             title: const Text('Booking Add Passengger'),
          //             trailing: const Icon(Icons.arrow_forward_ios, size: 12),
          //             onTap: () {
          //               Get.toNamed(AppLink.addPassengger);
          //             },
          //           ),
          //         ]))),
          // const VSpace(),

          // /// PAYMENT
          // const TitleBasicSmall(title: 'Payment'),
          // PaperCard(
          //     content: Padding(
          //         padding: const EdgeInsets.all(8.0),
          //         child: Column(children: [
          //           ListTile(
          //             leading: const Icon(Icons.monetization_on_outlined),
          //             title: const Text('Payment'),
          //             trailing: const Icon(Icons.arrow_forward_ios, size: 12),
          //             onTap: () {
          //               Get.toNamed(AppLink.payment);
          //             },
          //           ),
          //           const LineList(),
          //           ListTile(
          //             leading: const Icon(Icons.credit_card),
          //             title: const Text('Payment Credit Card'),
          //             trailing: const Icon(Icons.arrow_forward_ios, size: 12),
          //             onTap: () {
          //               Get.toNamed(AppLink.paymentCc);
          //             },
          //           ),
          //           const LineList(),
          //           ListTile(
          //             leading: const Icon(Icons.wallet),
          //             title: const Text('Payment E-Wallet'),
          //             trailing: const Icon(Icons.arrow_forward_ios, size: 12),
          //             onTap: () {
          //               Get.toNamed(AppLink.paymentEWallet);
          //             },
          //           ),
          //           const LineList(),
          //           ListTile(
          //             leading: const Icon(Icons.account_balance),
          //             title: const Text('Payment Transfer'),
          //             trailing: const Icon(Icons.arrow_forward_ios, size: 12),
          //             onTap: () {
          //               Get.toNamed(AppLink.paymentTransfer);
          //             },
          //           ),
          //           const LineList(),
          //           ListTile(
          //             leading: const Icon(Icons.contacts_rounded),
          //             title: const Text('Payment Virtual Account'),
          //             trailing: const Icon(Icons.arrow_forward_ios, size: 12),
          //             onTap: () {
          //               Get.toNamed(AppLink.paymentVac);
          //             },
          //           ),
          //           const LineList(),
          //           ListTile(
          //             leading: const Icon(Icons.check_circle_outline),
          //             title: const Text('Payment Status'),
          //             trailing: const Icon(Icons.arrow_forward_ios, size: 12),
          //             onTap: () {
          //               Get.toNamed(AppLink.paymentStatus);
          //             },
          //           ),
          //         ]))),
          // const VSpace(),

          // /// TICKET
          // const TitleBasicSmall(title: 'Ticket'),
          // PaperCard(
          //     content: Padding(
          //         padding: const EdgeInsets.all(8.0),
          //         child: Column(children: [
          //           ListTile(
          //             leading: const Icon(Icons.airplane_ticket),
          //             title: const Text('My Ticket'),
          //             trailing: const Icon(Icons.arrow_forward_ios, size: 12),
          //             onTap: () {
          //               Get.toNamed(AppLink.myTicket);
          //             },
          //           ),
          //           const LineList(),
          //           ListTile(
          //             leading: const Icon(Icons.airplane_ticket_outlined),
          //             title: const Text('Ticket Detail'),
          //             trailing: const Icon(Icons.arrow_forward_ios, size: 12),
          //             onTap: () {
          //               Get.toNamed(AppLink.ticketDetail);
          //             },
          //           ),
          //           const LineList(),
          //           ListTile(
          //             leading: const Icon(Icons.history),
          //             title: const Text('Transaction History'),
          //             trailing: const Icon(Icons.arrow_forward_ios, size: 12),
          //             onTap: () {
          //               Get.toNamed(AppLink.orderHistory);
          //             },
          //           ),
          //           const LineList(),
          //           ListTile(
          //             leading: const Icon(Icons.money),
          //             title: const Text('E-Ticket'),
          //             trailing: const Icon(Icons.arrow_forward_ios, size: 12),
          //             onTap: () {
          //               Get.toNamed(AppLink.eTicket);
          //             },
          //           ),
          //         ]))),
          // const VSpace(),

          // /// PROMO
          // const TitleBasicSmall(title: 'Promo'),
          // PaperCard(
          //     content: Padding(
          //         padding: const EdgeInsets.all(8.0),
          //         child: Column(children: [
          //           ListTile(
          //             leading: const Icon(Icons.campaign),
          //             title: const Text('Promo'),
          //             trailing: const Icon(Icons.arrow_forward_ios, size: 12),
          //             onTap: () {
          //               Get.toNamed(AppLink.promo);
          //             },
          //           ),
          //           const LineList(),
          //           ListTile(
          //             leading: const Icon(Icons.campaign_outlined),
          //             title: const Text('Promo Detail'),
          //             trailing: const Icon(Icons.arrow_forward_ios, size: 12),
          //             onTap: () {
          //               Get.toNamed(AppLink.promoDetail);
          //             },
          //           ),
          //           const LineList(),
          //           ListTile(
          //             leading: const Icon(Icons.discount),
          //             title: const Text('Voucher Detail'),
          //             trailing: const Icon(Icons.arrow_forward_ios, size: 12),
          //             onTap: () {
          //               Get.toNamed(AppLink.voucherDetail);
          //             },
          //           ),
          //         ]))),
          // const VSpace(),

          // /// UI LIST
          // const TitleBasicSmall(title: 'UI List'),
          // PaperCard(
          //     content: Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Column(children: [
          //     ListTile(
          //       leading: const Icon(Icons.ads_click),
          //       title: const Text('Buttons'),
          //       trailing: const Icon(Icons.arrow_forward_ios, size: 12),
          //       onTap: () {
          //         Get.toNamed(AppLink.buttonCollection);
          //       },
          //     ),
          //     const LineList(),
          //     ListTile(
          //       leading: const Icon(Icons.rounded_corner),
          //       title: const Text('Shadow and Border Radius'),
          //       trailing: const Icon(Icons.arrow_forward_ios, size: 12),
          //       onTap: () {
          //         Get.toNamed(AppLink.shadowRoundedCollection);
          //       },
          //     ),
          //     const LineList(),
          //     ListTile(
          //       leading: const Icon(Icons.abc),
          //       title: const Text('Typography'),
          //       trailing: const Icon(Icons.arrow_forward_ios, size: 12),
          //       onTap: () {
          //         Get.toNamed(AppLink.typographyCollection);
          //       },
          //     ),
          //     const LineList(),
          //     ListTile(
          //       leading: const Icon(Icons.palette_outlined),
          //       title: const Text('Colors and Gradient'),
          //       trailing: const Icon(Icons.arrow_forward_ios, size: 12),
          //       onTap: () {
          //         Get.toNamed(AppLink.colorCollection);
          //       },
          //     ),
          //     const LineList(),
          //     ListTile(
          //       leading: const Icon(Icons.format_list_bulleted),
          //       title: const Text('Form Input'),
          //       trailing: const Icon(Icons.arrow_forward_ios, size: 12),
          //       onTap: () {
          //         Get.toNamed(AppLink.formSample);
          //       },
          //     ),
          //     const LineList(),
          //     ListTile(
          //       leading: const Icon(Icons.collections_outlined),
          //       title: const Text('Card Collection'),
          //       trailing: const Icon(Icons.arrow_forward_ios, size: 12),
          //       onTap: () {
          //         Get.toNamed(AppLink.cardCollection);
          //       },
          //     ),
          //   ]),
          // )),
          // const VSpace(),

          /// FOOTER
          SizedBox(
            height: 50,
            child: FilledButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(localization.logout),
                      content: Text(localization.logoutDesc),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(localization.no),
                        ),
                        FilledButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _logout();
                          },
                          child: Text(localization.yes),
                        ),
                      ],
                    ),
                  );
                  // ignore: avoid_print
                  print("logout clicked");
                },
                style: FilledButton.styleFrom(backgroundColor: Colors.red),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(localization.logout.toUpperCase()),
                  SizedBox(width: 4),
                  Icon(Icons.exit_to_app)
                ])),
          ),
          const VSpace(),
          Center(
              child: Text('${branding.name} Version: ${branding.version}',
                  style: ThemeText.caption)),
          const VSpaceBig(),
        ]);
  }
}
