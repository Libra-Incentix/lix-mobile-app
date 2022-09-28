import 'package:flutter/material.dart';
import 'package:lix/app/color_select.dart';
import 'package:lix/models/category_model.dart';
import 'package:lix/screens/views/bottom_tabs/home_screen_styles.dart';

class CategoryItem extends StatefulWidget {
  final Category category;
  final Function onTap;
  const CategoryItem({
    Key? key,
    required this.onTap,
    required this.category,
  }) : super(key: key);

  @override
  State<CategoryItem> createState() => _CategoryItemState();
}

class _CategoryItemState extends State<CategoryItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap(widget.category);
      },
      child: Container(
        height: 36,
        margin: const EdgeInsets.fromLTRB(0, 0, 8, 0),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
        decoration: BoxDecoration(
          color: widget.category.selected!
              ? Colors.black
              : ColorSelect.appThemeGrey,
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
              widget.category.name!,
              style: widget.category.selected!
                  ? buttonTextBold()
                  : textStyleBoldBlack(12),
            ),
          ],
        ),
      ),
    );
  }
}
