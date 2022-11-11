import 'dart:developer' as devtools show log, inspect;
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lix/app/color_select.dart';
import 'package:lix/app/image_assets.dart';
import 'package:lix/locator.dart';
import 'package:lix/models/buy_offer_success.dart';
import 'package:lix/models/custom_exception.dart';
import 'package:lix/models/user.dart';
import 'package:lix/screens/views/bottom_tabs/home_screen_styles.dart';
import 'package:lix/screens/widgets/input_field.dart';
import 'package:lix/screens/widgets/submit_button.dart';
import 'package:flutter/services.dart';
import 'package:lix/services/api.dart';
import 'package:lix/services/helper.dart';

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
  late User user = locator<HelperService>().getCurrentUser()!;
  APIService apiService = locator<APIService>();
  bool showQrCode = false;
  bool showBarCode = false;
  bool loading = false;
  String displayedMessage = '';
  bool showSuccessMessage = false;
  bool showErrorMessage = false;
  final TextEditingController staffMemberInputController =
      TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
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
      insetPadding: const EdgeInsets.all(20),
      child: dialogContent(context),
    );
  }

  Widget dialogContent(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 0.0, right: 0.0),
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
                                          text:
                                              '${buyOfferSuccess.coupon!.coupon}',
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
                                        ClipboardData(
                                          text: buyOfferSuccess.coupon!.coupon,
                                        ),
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.copy,
                                      size: 20,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(
                                  top: 0,
                                  bottom: 12,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                    const SizedBox(width: 2),
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
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: inputField(
                                  "Staff member ID",
                                  staffMemberInputController,
                                  false,
                                  context,
                                  onTextChange,
                                  TextInputType.name,
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.fromLTRB(4, 0, 4, 0),
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
                          margin: const EdgeInsets.all(24).subtract(
                            const EdgeInsets.only(top: 0),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              SubmitButton(
                                onTap: widget.shareAction,
                                text: "Share Now",
                                color: ColorSelect.lightBlack,
                              ),
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

  Widget showQrOrBarcodeImage() {
    if (showQrCode || showBarCode) {
      return Container(
        margin: const EdgeInsets.only(
          bottom: 10,
        ),
        child: Image.memory(
          base64Decode(
            showQrCode
                ? buyOfferSuccess.coupon!.couponQRCode!
                : buyOfferSuccess.coupon!.couponBarcode!,
          ),
        ),
      );
    }
    return Container();
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
      showSuccessMessage = false;
      displayedMessage = '';
    });
  }

  Future approveCoupon() async {
    // resetErrorMessage();
    String couponCode = buyOfferSuccess.coupon!.coupon!;
    int organizationId =
        buyOfferSuccess.coupon!.market!['created_by_organisation']['id'] ?? 0;
    String staffMemberId = staffMemberInputController.text;

    try {
      showLoading();
      bool response = await apiService.approveCouponByStaff(
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
