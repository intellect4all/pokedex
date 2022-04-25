import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HelperFunctions {
  static setStatusBarDarkTheme() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.dark,
      // this will change the brightness of the icons
      statusBarColor: Colors.transparent,
      // or any color you want
      systemNavigationBarIconBrightness:
          Brightness.dark, //navigation bar icons' color
    ));
  }

  static setStatusBarToLightTheme() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.light,
      // this will change the brightness of the icons
      statusBarColor: Colors.transparent,
      // or any color you want
      systemNavigationBarIconBrightness:
          Brightness.light, //navigation bar icons' color
    ));
  }
}
