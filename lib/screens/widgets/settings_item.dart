// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:lix/app/color_select.dart';
import 'package:lix/screens/views/bottom_tabs/home_screen_styles.dart';

class SettingsItem extends StatefulWidget {
  Function onTap;
  var text = "";
  var icon = "";
  SettingsItem(
      {Key? key, required this.onTap, required this.icon, required this.text})
      : super(key: key);

  @override
  State<SettingsItem> createState() => _SettingsItemState();
}

class _SettingsItemState extends State<SettingsItem> {
  get child => null;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap();
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(18, 4, 18, 0),
        decoration: const BoxDecoration(
          border: Border(
              bottom: BorderSide(width: 2, color: ColorSelect.appThemeGrey)),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          title: Text(widget.text, style: textStyleBoldBlack(16)),
          minLeadingWidth: 34,
          leading: Image(
            image: AssetImage(widget.icon),
            fit: BoxFit.fitHeight,
            height: 34,
            width: 34,
          ),
          trailing: const Icon(
            Icons.chevron_right,
            color: Colors.black,
            size: 32.0,
          ),
        ),
      ),
    );
  }
}
