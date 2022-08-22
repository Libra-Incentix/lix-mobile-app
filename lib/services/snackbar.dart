import 'package:flutter/material.dart';
import 'package:lix/app/color_select.dart';

class SnackBarService {
  showSnackBarWithString(
    String message, {
    int duration = 5,
  }) {
    return SnackBar(
      content: Text(
        message,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
      duration: Duration(
        seconds: duration,
      ),
      backgroundColor: ColorSelect.appThemeOrange,
    );
  }

  showSnackBarWithWidget(
    Widget content, {
    int duration = 5,
  }) {
    return SnackBar(
      content: content,
      duration: Duration(
        seconds: duration,
      ),
      backgroundColor: ColorSelect.appThemeOrange,
    );
  }
}
