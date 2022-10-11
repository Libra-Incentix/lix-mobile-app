// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:lix/screens/views/bottom_tabs/home_screen_styles.dart';

class ValidateText extends StatefulWidget {
  var text = "";
  var isVisible = false;
  ValidateText({Key? key, required this.isVisible, required this.text})
      : super(key: key);

  @override
  State<ValidateText> createState() => _ValidateTextState();
}

class _ValidateTextState extends State<ValidateText> {
  @override
  Widget build(BuildContext context) {
    if (widget.isVisible) {
      return Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(top: 4),
        child: Text(
          widget.text,
          style: textStyleValidation(14),
        ),
      );
    } else {
      return Container();
    }
  }
}
