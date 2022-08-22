// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:lix/app/color_select.dart';
import 'package:lix/screens/views/bottom_tabs/home_screen_styles.dart';
import 'package:lix/screens/widgets/button_small.dart';
import 'package:lix/screens/widgets/submit_button.dart';

class ExpandableCard extends StatefulWidget {
  var title = "";
  var childTitle = "";
  var subtitle = "";
  var leadingIcon = "";
  ExpandableCard({
    Key? key,
    required this.title,
    required this.childTitle,
    required this.subtitle,
    required this.leadingIcon,
  }) : super(key: key);

  @override
  State<ExpandableCard> createState() => _ExpandableCardState();
}

class _ExpandableCardState extends State<ExpandableCard> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.all(0),
        childrenPadding: const EdgeInsets.fromLTRB(0, 0, 0, 14),
        expandedAlignment: Alignment.topLeft,
        maintainState: true,
        collapsedIconColor: Colors.black,
        iconColor: Colors.black,
        title: Align(
          alignment: const Alignment(-1.1, 0),
          child: Text(
            widget.title,
            style: textStyleRegularBlack(12),
          ),
        ),
        subtitle: Align(
          alignment: const Alignment(-1.06, 0),
          child: Text(
            widget.subtitle,
            style: textStyleBoldBlack(16),
          ),
        ),
        leading: Image(
          image: AssetImage(widget.leadingIcon),
          fit: BoxFit.fitHeight,
          height: 38,
          width: 38,
        ),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: ButtonSmall(
                  onTap: () {},
                  text: "Change wallet",
                  color: ColorSelect.appThemeGrey,
                  borderColor: ColorSelect.lightBlack,
                  textStyle: textStyleBoldBlack(13),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ButtonSmall(
                  onTap: () {},
                  text: "Earn LIX",
                  color: ColorSelect.lightBlack,
                  borderColor: ColorSelect.lightBlack,
                  textStyle: textStyleMedium(13),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
