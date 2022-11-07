// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class SubmitButton extends StatefulWidget {
  Function onTap;
  var text = "";
  Color color;
  var disabled = false;

  SubmitButton({
    Key? key,
    required this.onTap,
    required this.text,
    required this.color,
    this.disabled = false,
  }) : super(key: key);

  @override
  State<SubmitButton> createState() => _SubmitButtonState();
}

class _SubmitButtonState extends State<SubmitButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap();
      },
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(
            4,
          ),
          border: Border.all(
            color: Colors.white,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.text,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: "Inter",
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
