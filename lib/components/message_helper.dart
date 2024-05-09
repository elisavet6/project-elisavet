import 'package:flutter/material.dart';

class ShowMessageHelper {
  static showMessage({required BuildContext context, required String text}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18.0,
        ),
      ),
      backgroundColor: Colors.red,
    ));
  }
}
