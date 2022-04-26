import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:string_extensions/string_extensions.dart';

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

  static String joinListToString(List<String> types) {
    return types.join(', ').toTitleCase!;
  }

  static String formatPokemonId(int id) {
    //* this code will duplicate '0' by the remainder times;
    String duplicateO = '0' * (4 - (id.toString().length));
    // concatenation to give the format '#0001'
    return '#' + duplicateO + id.toString();
  }
}
