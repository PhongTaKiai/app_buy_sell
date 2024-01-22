import 'package:app_buy_sell/app_module/app_module.dart';
import 'package:app_buy_sell/screen/splash/splash_page.dart';
import 'package:app_buy_sell/utils/theme/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:koin/koin.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  startKoin((app) {
    app.modules(List.of([
      Modules.viewModelModule,
    ]));
  });
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme().theme,
      debugShowCheckedModeBanner: false,
      home: const SplashPage(),
    );
  }
}