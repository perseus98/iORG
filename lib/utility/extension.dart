import 'dart:ui';

import 'package:flutter/material.dart';

extension mOwnColor on ColorScheme {
  Color get success => const Color(0xFF28a745);

  Color get info => const Color(0xFF17a2b8);

  Color get warning => const Color(0xFFffc107);

  Color get danger => const Color(0xFFdc3545);

  Color get mySixtyNineColor => const Color.fromARGB(255, 105, 105, 105);

  Color get myAccentColor => const Color.fromARGB(255, 135, 119, 172);
}

extension myOwnTextTheme on TextTheme {
  TextStyle get error => const TextStyle(
      decoration: TextDecoration.lineThrough,
      fontSize: 20.0,
      color: Colors.blue,
      fontWeight: FontWeight.bold);

  TextStyle get myLinkBodyTextStyle => const TextStyle(
      color: Colors.white, fontSize: 13.0, fontWeight: FontWeight.bold);

  TextStyle get myLinkTextStyle => const TextStyle(
        color: Colors.blue,
      );

  TextStyle get subBodyTitle => const TextStyle(
        color: Colors.white,
        fontSize: 13.0,
        fontWeight: FontWeight.bold,
      );
}
