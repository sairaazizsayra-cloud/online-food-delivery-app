import 'package:flutter/material.dart';

class AppNav {
  static Future<T?> to<T>(BuildContext context, Widget page) {
    return Navigator.push<T>(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  static void offAll(BuildContext context, Widget page) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => page),
      (_) => false,
    );
  }

  static void replace(BuildContext context, Widget page) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }
}
