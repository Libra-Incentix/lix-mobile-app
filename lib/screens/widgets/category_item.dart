// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:lix/app/color_select.dart';
import 'package:lix/screens/views/bottom_tabs/home_screen_styles.dart';

class CategoryItem extends StatefulWidget {
  Function onTap;
  var text = "";
  var selected = false;
  var itemIndex = 0;
  CategoryItem({
    Key? key,
    required this.onTap,
    required this.text,
    required this.selected,
    required this.itemIndex,
  }) : super(key: key);

  @override
  State<CategoryItem> createState() => _CategoryItemState();
}

class _CategoryItemState extends State<CategoryItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          widget.onTap(widget.itemIndex);
        },
        child: Container(
          height: 36,
          margin: const EdgeInsets.fromLTRB(0, 0, 8, 0),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
          decoration: BoxDecoration(
            color: widget.selected ? Colors.black : ColorSelect.appThemeGrey,
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
              Text(widget.text,
                  style: widget.selected
                      ? buttonTextBold()
                      : textStyleBoldBlack(12)),
            ],
          ),
        ));
  }
}
