import 'package:flutter/material.dart';
import 'package:lix/app/color_select.dart';
import 'package:lix/app/image_assets.dart';
import 'package:lix/screens/views/bottom_tabs/home_screen_styles.dart';
import 'package:lix/screens/widgets/submit_button.dart';

class ClaimCouponDialog extends StatefulWidget {
  const ClaimCouponDialog({Key? key}) : super(key: key);

  @override
  State<ClaimCouponDialog> createState() => _ClaimCouponDialogState();
}

class _ClaimCouponDialogState extends State<ClaimCouponDialog> {
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
                  "Congratulation!",
                  style: textStyleBoldBlack(24),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  "20 LIX is credited to your wallet",
                  style: textStyleRegularBlack(14),
                  textAlign: TextAlign.center,
                ),
                Container(
                  color: ColorSelect.appThemeGrey,
                  margin: const EdgeInsets.all(24),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        "Earn extra 10 LIX",
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
                                  'Share this task with your friends and earn extra',
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
