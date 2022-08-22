// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:lix/app/color_select.dart';
import 'package:lix/screens/views/bottom_tabs/home_screen_styles.dart';

class RecommendedDeals extends StatefulWidget {
  Function onTap;
  var productsList = [];
  var viewAllOption = true;
  RecommendedDeals(
      {Key? key,
      required this.onTap,
      required this.productsList,
      required this.viewAllOption})
      : super(key: key);

  @override
  State<RecommendedDeals> createState() => _RecommendedDealsState();
}

class _RecommendedDealsState extends State<RecommendedDeals> {
  double getTopMargin() {
    if (widget.viewAllOption) {
      return 16;
    } else {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.fromLTRB(16, getTopMargin(), 16, 0),
      child: Column(
        children: [
          if (widget.viewAllOption) const SizedBox(height: 12),
          if (widget.viewAllOption)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Recommended', style: textStyleBoldBlack(16)),
                Text('View All', style: textStyleViewAll(12)),
              ],
            ),
          Container(
              margin: const EdgeInsets.fromLTRB(0, 12, 0, 0),
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.productsList.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        widget.onTap();
                      },
                      child: Container(
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.fromLTRB(16, 0, 0, 16),
                              height: 160,
                              alignment: Alignment.bottomLeft,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(widget.productsList[index]
                                            ["picture"]
                                        .toString()),
                                    fit: BoxFit.fitWidth),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4.0),
                                child: Image(
                                    height: 50,
                                    width: 50,
                                    image: AssetImage(widget.productsList[index]
                                            ["logo"]
                                        .toString()),
                                    fit: BoxFit.cover),
                              ),
                            ),
                            Container(
                                height: 70,
                                margin: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                                decoration: const BoxDecoration(
                                    color: ColorSelect.appThemeGrey,
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(4),
                                        bottomRight: Radius.circular(4))),
                                width: MediaQuery.of(context).size.width,
                                padding:
                                    const EdgeInsets.fromLTRB(16, 12, 0, 12),
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        widget.productsList[index]["name"]
                                            .toString(),
                                        style: textStyleBoldBlack(16)),
                                    const SizedBox(height: 4),
                                    Text(
                                        widget.productsList[index]["desc"]
                                            .toString(),
                                        style: textStyleRegularBlack(14)),
                                  ],
                                )),
                          ],
                        ),
                      ),
                    );
                  }))
        ],
      ),
    );
  }
}
