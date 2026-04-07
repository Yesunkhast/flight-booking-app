import 'package:firebase_core/firebase_core.dart';
import 'package:flight_app/app/bindings.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flight_app/app/service.dart';
import 'package:flight_app/app/constants/app_const.dart';
import 'package:flight_app/app/app_routes.dart';
import 'package:flight_app/l10n/app_localizations.dart';
import 'package:flight_app/ui/themes/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'firebase_options.dart';
import 'dart:async';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // await Future.delayed(const Duration(seconds: 2));

  await Get.putAsync<LocalizationService>(
    () async => await LocalizationService().init(),
  );

  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  // final RxString _themeMode = 'auto'.obs;

  @override
  Widget build(BuildContext context) {
    // print(Firebase.apps);

    final localizationService = Get.find<LocalizationService>();
    return Obx(
      () => GetMaterialApp(
        initialBinding: AppBindings(),
        title: branding.name,
        debugShowCheckedModeBanner: false,
        locale: Locale(localizationService.locale.value),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        themeMode: ThemeMode.system,
        theme: lightColorScheme,
        darkTheme: darkColorScheme,
        initialRoute: '/splash',
        getPages: appRoutes,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(boldText: false),
          child: child!,
        ),
      ),
    );
  }
}
