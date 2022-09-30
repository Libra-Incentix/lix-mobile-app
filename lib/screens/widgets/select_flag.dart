// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:lix/app/color_select.dart';
import 'package:lix/screens/views/bottom_tabs/home_screen_styles.dart';

class SelectFlag extends StatefulWidget {
  Function onTap;
  var text = "";
  String icon = "";
  var isSelected = false;
  SelectFlag({
    Key? key,
    required this.onTap,
    required this.icon,
    required this.text,
    required this.isSelected,
  }) : super(key: key);

  @override
  State<SelectFlag> createState() => _SelectFlagState();
}

class _SelectFlagState extends State<SelectFlag> {
  get child => null;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(18, 4, 18, 0),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 2,
            color: ColorSelect.appThemeGrey,
          ),
        ),
      ),
      child: ListTile(
        onTap: () {
          widget.onTap(widget.text);
        },
        contentPadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        title: Text(
          widget.text,
          style: textStyleBoldBlack(16),
        ),
        leading: FadeInImage.assetNetwork(
          placeholder: 'https://dummyimage.com/30x20/a1630d/fff.png&text=Country',
          image:'https://dummyimage.com/30x20/a1630d/fff.png',
        ),
        minLeadingWidth: 30,
        trailing: widget.isSelected
            ? const Icon(
                Icons.check,
                color: Colors.black,
                size: 24.0,
              )
            : null,
      ),
    );
  }
}
