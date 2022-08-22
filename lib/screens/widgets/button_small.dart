// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class ButtonSmall extends StatefulWidget {
  Function onTap;
  var text = "";
  Color color;
  Color borderColor;
  TextStyle textStyle;
  var disabled = false;

  ButtonSmall({
    Key? key,
    required this.onTap,
    required this.text,
    required this.color,
    required this.borderColor,
    required this.textStyle,
    this.disabled = false,
  }) : super(key: key);

  @override
  State<ButtonSmall> createState() => _ButtonSmallState();
}

class _ButtonSmallState extends State<ButtonSmall> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          widget.onTap();
        },
        child: Container(
          alignment: Alignment.center,
          height: 38,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.circular(
              4,
            ),
            border: Border.all(
              color: widget.borderColor,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(widget.text, style: widget.textStyle),
            ],
          ),
        ));
  }
}
