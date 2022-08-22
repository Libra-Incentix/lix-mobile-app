// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:lix/screens/views/bottom_tabs/home_screen_styles.dart';

class ImageButton extends StatefulWidget {
  Function onTap;
  var text = "";
  var disabled = false;
  var buttonIcon = "";
  ImageButton({
    Key? key,
    required this.onTap,
    required this.text,
    required this.buttonIcon,
    this.disabled = false,
  }) : super(key: key);

  @override
  State<ImageButton> createState() => _ImageButtonState();
}

class _ImageButtonState extends State<ImageButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          widget.onTap();
        },
        child: Ink(
          height: 50,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(
              4,
            ),
            border: Border.all(
              color: Colors.black,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                width: 16,
                height: 16,
                image: AssetImage(widget.buttonIcon),
              ),
              const SizedBox(width: 6),
              Text(widget.text, style: textStyleBoldBlack(16)),
            ],
          ),
        ));
  }
}
