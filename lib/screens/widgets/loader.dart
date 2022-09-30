import 'package:flutter/material.dart';
import 'package:lix/app/color_select.dart';
import 'package:nb_utils/nb_utils.dart';

Loading(BuildContext context) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: context.scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        contentPadding: EdgeInsets.all(0.0),
        content: Padding(
          padding: EdgeInsets.only(top: 20, bottom: 20),
          child: Row(
            children: [
              16.width,
              CircularProgressIndicator(
                backgroundColor: Color(0xffD6D6D6),
                strokeWidth: 4,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blueGrey),
              ),
              16.width,
              Text(
                "Please Wait....",
                style: primaryTextStyle(color: ColorSelect.deepblue),
              ),
            ],
          ),
        ),
      );
    },
  );
}
