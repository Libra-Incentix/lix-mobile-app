// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:lix/app/color_select.dart';
import 'package:lix/screens/views/bottom_tabs/home_screen_styles.dart';

class EarnWithLix extends StatefulWidget {
  Function onTap;
  var productsList = [];
  EarnWithLix({Key? key, required this.onTap, required this.productsList})
      : super(key: key);

  @override
  State<EarnWithLix> createState() => _EarnWithLixState();
}

class _EarnWithLixState extends State<EarnWithLix> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Earn with LIX', style: textStyleBoldBlack(16)),
              Text('View All', style: textStyleViewAll(12)),
            ],
          ),
          Container(
              margin: const EdgeInsets.fromLTRB(0, 12, 0, 0),
              height: 166.0,
              child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.productsList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      contentPadding: const EdgeInsets.all(0),
                      title: Padding(
                        padding: const EdgeInsets.only(bottom: 3.0),
                        child: Text(widget.productsList[index]["name"],
                            style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                                fontFamily: 'Inter')),
                      ),
                      subtitle: Text(widget.productsList[index]["reward"],
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: ColorSelect.appThemeOrange,
                              fontFamily: 'Inter')),
                      leading: Image(
                        image:
                            AssetImage(widget.productsList[index]["picture"]),
                        fit: BoxFit.fitHeight,
                        height: 50,
                        width: 50,
                      ),
                    );
                  })),
        ],
      ),
    );
  }
}
