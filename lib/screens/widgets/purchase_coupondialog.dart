import 'package:flutter/material.dart';
import 'package:lix/app/color_select.dart';
import 'package:lix/app/image_assets.dart';
import 'package:lix/screens/views/bottom_tabs/home_screen_styles.dart';
import 'package:lix/screens/widgets/submit_button.dart';
import 'package:dotted_border/dotted_border.dart';

class PurchaseCouponDialog extends StatefulWidget {
  final String title;

  const PurchaseCouponDialog({Key? key, required this.title}) : super(key: key);

  @override
  State<PurchaseCouponDialog> createState() => _PurchaseCouponDialogState();
}

class _PurchaseCouponDialogState extends State<PurchaseCouponDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0.0,
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.all(20),
      child: dialogContent(context),
    );
  }

  Widget dialogContent(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 0.0, right: 0.0),
      child: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(height: 40),
                Image.asset(ImageAssets.greenCheckFill, height: 36, width: 36),
                const SizedBox(height: 8),
                Text(
                  widget.title,
                  style: textStyleBoldBlack(24),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  "Coupon successfully purchased",
                  style: textStyleRegularBlack(14),
                  textAlign: TextAlign.center,
                ),
                Container(
                  margin: const EdgeInsets.all(24),
                  child: DottedBorder(
                      borderType: BorderType.RRect,
                      radius: const Radius.circular(2),
                      dashPattern: const [8, 8],
                      strokeWidth: 1,
                      child: Column(
                        children: [
                          const SizedBox(height: 18),
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              'WBNEW',
                              style: textStyleBoldBlack(18),
                            ),
                          ),
                          Container(
                            transform: Matrix4.translationValues(1.8, 1.0, 0.0),
                            alignment: Alignment.centerRight,
                            child: Container(
                              alignment: Alignment.center,
                              height: 23,
                              width: 44,
                              decoration: const BoxDecoration(
                                color: ColorSelect.lightBlack,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(2),
                                ),
                              ),
                              child: Text('copy', style: textStyleRegular(12)),
                            ),
                          )
                        ],
                      )),
                ),
                Container(
                  color: ColorSelect.appThemeGrey,
                  margin: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        "Share & Earn",
                        style: textStyleMediumBlack(16),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      RichText(
                        textAlign: TextAlign.center,
                        text: const TextSpan(
                          style: TextStyle(
                              color: Color.fromARGB(255, 3, 3, 3),
                              fontSize: 14,
                              fontFamily: 'Intern',
                              height: 1.7,
                              fontWeight: FontWeight.w400),
                          children: <TextSpan>[
                            TextSpan(
                              text:
                                  'Share this discount offer with your friends and earn',
                            ),
                            TextSpan(
                                text: ' 10 LIX',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: ColorSelect.appThemeOrange)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      SubmitButton(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          text: "Share Now",
                          color: ColorSelect.lightBlack)
                      //
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.close,
                size: 24,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
