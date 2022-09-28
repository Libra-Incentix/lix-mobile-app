import 'package:flutter/material.dart';
import 'package:lix/app/color_select.dart';
import 'package:lix/app/image_assets.dart';

enum SnackBarType {
  error,
  success,
}

class SnackBarService {
  showSnackBarWithString(
    String message, {
    int duration = 5,
    SnackBarType type = SnackBarType.error,
  }) {
    Color bgColor = ColorSelect.alertOrange;
    if (type == SnackBarType.success) {
      bgColor = ColorSelect.successGreen;
    }
    return SnackBar(
      behavior: SnackBarBehavior.floating,
      elevation: 4,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Image(
            image: AssetImage(
              ImageAssets.checkBlack,
            ),
            width: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
      duration: Duration(
        seconds: duration,
      ),
      backgroundColor: bgColor,
    );
  }

  showSnackBarWithWidget(
    Widget content, {
    int duration = 5,
    SnackBarType type = SnackBarType.error,
  }) {
    Color bgColor = ColorSelect.alertOrange;
    if (type == SnackBarType.success) {
      bgColor = ColorSelect.successGreen;
    }

    return SnackBar(
      content: content,
      duration: Duration(
        seconds: duration,
      ),
      backgroundColor: bgColor,
    );
  }
}
