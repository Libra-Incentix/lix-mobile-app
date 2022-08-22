import 'package:flutter/material.dart';
import 'package:lix/app/image_assets.dart';
import 'package:lix/screens/views/bottom_tabs/home_screen_styles.dart';

Widget customAppBar(String title, BuildContext context) {
  return AppBar(
    backgroundColor: Colors.white,
    elevation: 0,
    centerTitle: true,
    title: Text(title, style: textStyleBoldBlack(16)),
    leading: Builder(
      builder: (BuildContext context) {
        return GestureDetector(
          child: Container(
            padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
            child: const Image(image: AssetImage(ImageAssets.arrowBack)),
          ),
          onTap: () {
            Navigator.pop(context);
          },
        );
      },
    ),
  );
}
