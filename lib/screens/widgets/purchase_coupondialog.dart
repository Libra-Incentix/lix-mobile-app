import 'dart:convert';
import 'dart:developer' as devtools show log, inspect;

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
import 'package:lix/services/snackbar.dart';
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
  final TextEditingController staffMemberInputController =
      TextEditingController();
  bool showQrCode = false;
  bool showBarCode = false;
  bool loading = false;
  String displayedMessage = '';
  bool showSuccessMessage = false;
  bool showErrorMessage = false;

  @override
  dispose() {
    staffMemberInputController.dispose();
    super.dispose();
  }

  onTextChange(String value) {
    setState(() {
      staffMemberInputController.text = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0.0,
      backgroundColor: Colors.white,
      // insetPadding: const EdgeInsets.all(20),
      child: dialogContent(context),
    );
  }

  Widget dialogContent(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0.0),
      child: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
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
                                  transform:
                                      Matrix4.translationValues(1.8, 1.0, 0.0),
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
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      showQrCode = !showQrCode;
                                      showBarCode = false;
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 15,
                                      horizontal: 6,
                                    ),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: isQRCodeButtonActive(),
                                    ),
                                    child: const Text(
                                      'Show QR Code',
                                      overflow: TextOverflow.ellipsis,
                                      textScaleFactor: 1.0,
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      showBarCode = !showBarCode;
                                      showQrCode = false;
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 15,
                                      horizontal: 6,
                                    ),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: isBarCodeButtonActive(),
                                    ),
                                    child: const Text(
                                      "Show Barcode",
                                      overflow: TextOverflow.ellipsis,
                                      textScaleFactor: 1.0,
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        showQrOrBarcodeImage(),
                        coupon.isUsed == 1
                            ? Container()
                            : Container(
                                margin: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: inputField(
                                        "Staff member ID",
                                        staffMemberInputController,
                                        true,
                                        context,
                                        onTextChange,
                                        TextInputType.name,
                                      ),
                                    ),
                                    Container(
                                      margin:
                                          const EdgeInsets.fromLTRB(4, 0, 4, 0),
                                      child: SubmitButton(
                                        onTap: () {
                                          if (staffMemberInputController
                                              .text.isNotEmpty) {
                                            approveCoupon();
                                          } else {
                                            setState(() {
                                              displayedMessage =
                                                  'Please enter a staff member id for verification.';
                                              showErrorMessage = true;
                                              showSuccessMessage = false;
                                            });
                                          }
                                        },
                                        text: "Verify",
                                        color: ColorSelect.lightBlack,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                        showErrorMessage
                            ? Container(
                                margin: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                                child: Text(
                                  displayedMessage,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.red,
                                  ),
                                ),
                              )
                            : Container(),
                        showSuccessMessage
                            ? Container(
                                margin: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                                child: Text(
                                  displayedMessage,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.green,
                                  ),
                                ),
                              )
                            : Container(),
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
    // if (coupon.isUsed == 1) {
    //   return Container();
    // }
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
    ShareResult result = await Share.shareWithResult(
      subject: shareSubject(),
      shareDescription(),
    );

    if (result.status == ShareResultStatus.success) {
      creditSocialShareBonus();
    }
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

  showLoading() {
    setState(() {
      if (!mounted) return;
      loading = true;
    });
  }

  hideLoading() {
    setState(() {
      if (!mounted) return;
      loading = false;
    });
  }

  resetErrorMessage() {
    setState(() {
      showErrorMessage = false;
      displayedMessage = '';
    });
  }

  Future approveCoupon() async {
    resetErrorMessage();
    String couponCode = coupon.coupon!;
    int organizationId = coupon.market!['created_by_organisation']['id'] ?? 0;
    String staffMemberId = staffMemberInputController.text;

    try {
      showLoading();
      dynamic response = await apiService.approveCouponByStaff(
        user,
        couponCode,
        organizationId.toString(),
        staffMemberId,
      );
      hideLoading();

      if (response) {
        setState(() {
          showErrorMessage = false;
          showSuccessMessage = true;
          displayedMessage = "Coupon was successfully marked as used";
        });
      }
    } on CustomException catch (e) {
      devtools.log('$e');
      hideLoading();
      setState(() {
        showErrorMessage = true;
        showSuccessMessage = false;
        displayedMessage = e.message;
      });
    } catch (e) {
      devtools.log('$e');
      hideLoading();
    }
  }
}
