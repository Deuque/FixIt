import 'package:fix_it/locator.dart';
import 'package:fix_it/play_area.dart';
import 'package:fix_it/util/styles.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: appName,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: primary,
          accentColor: primary,
          scaffoldBackgroundColor: background,
          fontFamily: proximaFont
        ),
        home: PlayArea());
  }
}
