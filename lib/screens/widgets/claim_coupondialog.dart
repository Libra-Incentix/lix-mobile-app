import 'package:flutter/material.dart';
import 'package:lix/app/color_select.dart';
import 'package:lix/app/image_assets.dart';
import 'package:lix/models/buy_offer_success.dart';
import 'package:lix/screens/views/bottom_tabs/home_screen_styles.dart';
import 'package:lix/screens/widgets/submit_button.dart';
import 'package:flutter/services.dart';

class ClaimCouponDialog extends StatefulWidget {
  final BuyOfferSuccess buyOfferSuccess;
  final Function shareAction;
  const ClaimCouponDialog({
    Key? key,
    required this.buyOfferSuccess,
    required this.shareAction,
  }) : super(key: key);

  @override
  State<ClaimCouponDialog> createState() => _ClaimCouponDialogState();
}

class _ClaimCouponDialogState extends State<ClaimCouponDialog> {
  late BuyOfferSuccess buyOfferSuccess = widget.buyOfferSuccess;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

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
                Image.asset(
                  ImageAssets.greenCheckFill,
                  height: 36,
                  width: 36,
                ),
                const SizedBox(height: 8),
                Text(
                  "Congratulation!",
                  style: textStyleBoldBlack(24),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "You've successfully claimed coupon by spending ${buyOfferSuccess.amount} ${buyOfferSuccess.currency}",
                    style: textStyleRegularBlack(14),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  color: ColorSelect.appThemeGrey,
                  margin: const EdgeInsets.all(24),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        "Here is your coupon code",
                        style: textStyleMediumBlack(16),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: const TextStyle(
                                color: Color.fromARGB(255, 3, 3, 3),
                                fontSize: 14,
                                fontFamily: 'Intern',
                                height: 1.7,
                                fontWeight: FontWeight.w400,
                              ),
                              children: <TextSpan>[
                                const TextSpan(
                                  text: '',
                                ),
                                TextSpan(
                                  text: '${buyOfferSuccess.coupon}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: ColorSelect.appThemeOrange,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              await Clipboard.setData(
                                  ClipboardData(text: buyOfferSuccess.coupon));
                            },
                            icon: const Icon(
                              Icons.copy,
                              size: 20,
                              color: Colors.black,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 6),
                      SubmitButton(
                        onTap: widget.shareAction,
                        text: "Share Now",
                        color: ColorSelect.lightBlack,
                      )
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
