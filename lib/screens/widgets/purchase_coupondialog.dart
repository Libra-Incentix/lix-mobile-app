import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:developer' as devtools show log;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lix/app/color_select.dart';
import 'package:lix/app/image_assets.dart';
import 'package:lix/locator.dart';
import 'package:lix/models/coupon_model.dart';
import 'package:lix/models/custom_exception.dart';
import 'package:lix/models/user.dart';
import 'package:lix/screens/views/bottom_tabs/home_screen_styles.dart';
import 'package:lix/screens/widgets/input_field.dart';
import 'package:lix/screens/widgets/submit_button.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:lix/services/api.dart';
import 'package:lix/services/helper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class PurchaseCouponDialog extends StatefulWidget {
  final CouponModel coupon;

  const PurchaseCouponDialog({
    Key? key,
    required this.coupon,
  }) : super(key: key);

  @override
  State<PurchaseCouponDialog> createState() => _PurchaseCouponDialogState();
}

class _PurchaseCouponDialogState extends State<PurchaseCouponDialog> {
  late CouponModel coupon = widget.coupon;
  late User user = locator<HelperService>().getCurrentUser()!;
  HelperService helperService = locator<HelperService>();
  APIService apiService = locator<APIService>();
  final TextEditingController _confirmInputController = TextEditingController();
  bool showQrCode = false;
  bool showBarCode = false;

  onTextChange(String value) {
    setState(() {
      _confirmInputController.text = value;
    });
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
      margin: const EdgeInsets.symmetric(horizontal: 0.0),
      child: SingleChildScrollView(
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
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                    ),
                    child: Text(
                      coupon.description ?? '',
                      style: textStyleBoldBlack(24),
                      textAlign: TextAlign.center,
                    ),
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
                              coupon.coupon!,
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
                              child: GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () async {
                                  await Clipboard.setData(
                                    ClipboardData(
                                      text: coupon.coupon,
                                    ),
                                  );
                                },
                                child: Text(
                                  'copy',
                                  style: textStyleRegular(12),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      top: 0,
                      bottom: 12,
                      left: 24,
                      right: 24,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SubmitButton(
                          onTap: () {
                            setState(() {
                              showQrCode = !showQrCode;
                              showBarCode = false;
                            });
                          },
                          text: "Show QR Code",
                          color: isQRCodeButtonActive(),
                        ),
                        const SizedBox(width: 10),
                        SubmitButton(
                          onTap: () {
                            setState(() {
                              showBarCode = !showBarCode;
                              showQrCode = false;
                            });
                          },
                          text: "Show Barcode",
                          color: isBarCodeButtonActive(),
                        ),
                      ],
                    ),
                  ),
                  showQrOrBarcodeImage(),
                  Container(
                    margin: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: inputField(
                            "Staff member ID",
                            _confirmInputController,
                            false,
                            context,
                            onTextChange,
                            TextInputType.name,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                          child: SubmitButton(
                            onTap: () {},
                            text: "Verify",
                            color: ColorSelect.lightBlack,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
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
                              fontWeight: FontWeight.w400,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text:
                                    'Share this discount offer with your friends and earn',
                              ),
                              TextSpan(
                                text: ' 5 LIX',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: ColorSelect.appThemeOrange,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        showShareNowButton(),
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
      ),
    );
  }

  Widget showShareNowButton() {
    if (coupon.isUsed == 1 && coupon.isActive == 0) {
      return Container();
    }
    return SubmitButton(
      onTap: shareCouponCode,
      text: "Share Now",
      color: ColorSelect.lightBlack,
    );
  }

  Widget showQrOrBarcodeImage() {
    if (showQrCode || showBarCode) {
      return Container(
        margin: const EdgeInsets.only(
          bottom: 20,
        ),
        child: Image.memory(
          base64Decode(
            showQrCode ? coupon.couponQRCode! : coupon.couponBarcode!,
          ),
        ),
      );
    }
    return Container();
  }

  bool doesSharingCodeAvailable() {
    if (showQrCode && coupon.couponQRCode != null) {
      return true;
    }

    if (showBarCode && coupon.couponBarcode != null) {
      return true;
    }

    return false;
  }

  String sharingCode() {
    if (showQrCode && coupon.couponQRCode != null) {
      return coupon.couponQRCode!;
    }

    if (showBarCode && coupon.couponBarcode != null) {
      return coupon.couponBarcode!;
    }

    return '';
  }

  shareCouponCode() async {
    // if (doesSharingCodeAvailable()) {
    //   Timer(
    //     const Duration(seconds: 1),
    //     () async {
    //       try {
    //         Uint8List byteData;
    //         byteData = const Base64Decoder().convert(
    //           sharingCode().isNotEmpty ? sharingCode() : '',
    //         );
    //         Uint8List pngBytes = byteData.buffer.asUint8List();

    //         final tempDir = await getTemporaryDirectory();
    //         final file = await File('${tempDir.path}/image.png').create();
    //         await file.writeAsBytes(pngBytes);

    //         ShareResult result = await Share.shareFilesWithResult(
    //           ['${tempDir.path}/image.png'],
    //           subject: shareSubject(),
    //           text: shareDescription(),
    //         );

    //         if (result.status == ShareResultStatus.success) {
    //           creditSocialShareBonus();
    //         }
    //         return;
    //       } catch (e) {
    //         devtools.log(e.toString());
    //       }
    //     },
    //   );
    // } else {
    ShareResult result = await Share.shareWithResult(
      subject: shareSubject(),
      shareDescription(),
    );

    if (result.status == ShareResultStatus.success) {
      creditSocialShareBonus();
    }
    // }
  }

  creditSocialShareBonus() async {
    try {
      // ok user shared coupon successfully.
      // credit 5 lix in user's account.
      String response = await apiService.creditSocialShareBonus(user);
      if (response.runtimeType == String) {
        // ignore: use_build_context_synchronously
        Navigator.pop(context, {
          "response": response,
          "type": "success",
        });
      }
    } on CustomException catch (e) {
      devtools.log('$e');
      Navigator.pop(context, {
        "response": e.message,
        "type": "error",
      });
    } catch (e) {
      devtools.log('$e');
    }
  }

  String shareSubject() {
    return coupon.description ?? 'Coupon Claimed';
  }

  String shareDescription() {
    if (coupon.market != null) {
      return coupon.market!['offer_link'] ?? '';
    }
    return '';
  }

  Color isQRCodeButtonActive() {
    if (showQrCode) {
      return ColorSelect.lightBlack.withOpacity(.5);
    }

    return ColorSelect.lightBlack;
  }

  Color isBarCodeButtonActive() {
    if (showBarCode) {
      return ColorSelect.lightBlack.withOpacity(.5);
    }

    return ColorSelect.lightBlack;
  }
}
