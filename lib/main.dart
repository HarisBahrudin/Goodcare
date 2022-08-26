import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:goodcare/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // ignore: await_only_futures
  await EasyLocalization.ensureInitialized;

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final SharedPreferences pref = await _prefs;
  String xbhs = pref.getString("xbhs") ?? 'en_US';
  print("Bahasa diload "+xbhs);

  runApp(EasyLocalization(
    supportedLocales: [
      Locale('id'),
      Locale('en', 'US')
    ],
    path: 'assets/translations',
    // startLocale: const Locale('en_US'),
    // startLocale: const Locale('id'),
    startLocale: Locale(xbhs),
    child: MyApp())
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      title: 'Good Care',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        appBarTheme: AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle.light,
        )
      ),
      locale: context.locale,
      home: Login(),
    );
  }
}

