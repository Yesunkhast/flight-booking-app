import 'package:flight_app/app/controllers.dart';
import 'package:flight_app/app/service.dart';
// import 'package:flight_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:get/route_manager.dart';
// import 'package:get/state_manager.dart';
import 'package:flight_app/constants/app_const.dart';
import 'package:flight_app/app/app_routes.dart';
import 'package:flight_app/ui/themes/theme_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  final RxString _themeMode = 'auto'.obs;
  final RxString _locale = 'en'.obs;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final locationController = Get.put(LocationController());

  // void changeLanguage(String code) {
  //   setState(() {
  //     _locale = Locale(code);
  //   });
  // }

  Future<void> _getThemeStatus() async {
    var mode = _prefs.then((SharedPreferences prefs) {
      return prefs.getString('appTheme') ?? 'auto';
    }).obs;

    _themeMode.value = await mode.value;

    switch (_themeMode.value) {
      case 'dark':
        Get.changeThemeMode(ThemeMode.dark);
        break;
      case 'light':
        Get.changeThemeMode(ThemeMode.light);
        break;
      default:
        break;
    }
  }

  Future<void> _getLocale() async {
    final prefs = await _prefs;
    _locale.value = prefs.getString('appLocale') ?? 'en';
    Get.updateLocale(Locale(_locale.value));
  }

  MainApp({super.key}) {
    locationController.fetchLocation();
    _getThemeStatus();
    _getThemeStatus();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: branding.name,
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      // supportedLocales: LocalizationService.delegate.supportedLocales,
      theme: lightColorScheme,
      darkTheme: darkColorScheme,
      initialRoute: '/',
      getPages: appRoutes,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(boldText: false),
        child: child!,
      ),
    );
  }
}
