// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:lix/app/color_select.dart';
import 'package:lix/app/image_assets.dart';
import 'package:lix/models/deal_coupon_model.dart';
import 'package:lix/screens/views/bottom_tabs/home_screen_styles.dart';

class RadioTile extends StatefulWidget {
  Function onTap;
  late DealCouponModel listItem;
  var text = "";
  RadioTile({
    Key? key,
    required this.onTap,
    required this.listItem,
  }) : super(key: key);

  @override
  State<RadioTile> createState() => _RadioTileState();
}

class _RadioTileState extends State<RadioTile> {
  get child => null;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap();
      },
      child: Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.fromLTRB(0, 16, 0, 0),
          padding: const EdgeInsets.fromLTRB(6, 0, 6, 16),
          decoration: const BoxDecoration(
            border: Border(
                bottom: BorderSide(width: 2, color: ColorSelect.appThemeGrey)),
          ),
          child: Row(
            children: [
              Image(
                image: AssetImage(widget.listItem.checked
                    ? ImageAssets.radioCheck
                    : ImageAssets.radioUnheck),
                fit: BoxFit.contain,
                height: 20,
                width: 20,
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.listItem.title, style: textStyleBoldBlack(14)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      if (widget.listItem.hasOffer)
                        Text(
                          widget.listItem.reducedAmount,
                          style: textStyleLine(12),
                        ),
                      if (widget.listItem.hasOffer)
                        const SizedBox(
                          width: 8,
                        ),
                      Text(
                        widget.listItem.couponAmount,
                        style: textStyleViewAll(16),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          )),
    );
  }
}
