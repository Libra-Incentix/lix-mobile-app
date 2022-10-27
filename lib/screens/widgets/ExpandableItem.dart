// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:lix/screens/views/bottom_tabs/home_screen_styles.dart';

class ExpandableItem extends StatefulWidget {
  var title = "";
  var childTitle = "";
  ExpandableItem({
    Key? key,
    required this.title,
    required this.childTitle,
  }) : super(key: key);

  @override
  State<ExpandableItem> createState() => _ExpandableItemState();
}

class _ExpandableItemState extends State<ExpandableItem> {
  getChildTitle() {
    return HtmlWidget(widget.childTitle, textStyle: expandableText(14));
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.all(0),
        childrenPadding: const EdgeInsets.fromLTRB(0, 0, 0, 6),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        expandedAlignment: Alignment.topLeft,
        maintainState: true,
        collapsedIconColor: Colors.black,
        iconColor: Colors.black,
        title: Text(
          widget.title,
          style: textStyleBoldBlack(16),
        ),
        children: <Widget>[getChildTitle()],
      ),
    );
  }
}
