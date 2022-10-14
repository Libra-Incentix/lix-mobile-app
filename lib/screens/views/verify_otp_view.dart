// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:lix/app/color_select.dart';
import 'package:lix/app/image_assets.dart';
import 'package:lix/locator.dart';
import 'package:lix/models/custom_exception.dart';
import 'package:lix/models/user.dart';
import 'package:lix/screens/views/bottom_tabs/home_screen_styles.dart';
import 'package:lix/screens/views/dashboard.dart';
import 'package:lix/screens/widgets/countdown_timer.dart';
import 'package:lix/screens/widgets/submit_button.dart';
import 'package:lix/services/api.dart';
import 'package:lix/services/helper.dart';
import 'package:lix/services/snackbar.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';

class VerifyOTPView extends StatefulWidget {
  final String email;
  const VerifyOTPView({
    Key? key,
    required this.email,
  }) : super(key: key);

  @override
  State<VerifyOTPView> createState() => _VerifyOTPViewState();
}

class _VerifyOTPViewState extends State<VerifyOTPView> {
  late String email = widget.email;

  OtpFieldController otpController = OtpFieldController();
  HelperService helperService = locator<HelperService>();
  APIService apiService = locator<APIService>();
  SnackBarService snackBarService = locator<SnackBarService>();
  Timer? resendTimer;

  bool pinEntered = false;
  bool loading = false;
  bool showResend = false;
  String otpValue = '';

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

  submitOTP() async {
    try {
      showLoading();
      User user = await apiService.userVerifyOTP(email, otpValue);
      user.email = email;
      hideLoading();
      await helperService.saveUserDetails(user);
      // user is saved, now navigate to dashboard page.
      // pop until last...
      Navigator.popUntil(context, (route) => false);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const Dashboard(
            index: 0,
          ),
        ),
      );
    } on CustomException catch (e) {
      hideLoading();
      ScaffoldMessenger.of(context).showSnackBar(
        snackBarService.showSnackBarWithString(e.message),
      );
      log('$e');
    } catch (e) {
      hideLoading();
      ScaffoldMessenger.of(context).showSnackBar(
        snackBarService.showSnackBarWithString(
          helperService.defaultErrorMessage,
        ),
      );
      log('$e');
    } finally {
      setState(() {
        pinEntered = false;
      });
    }
  }

  resendOTP() async {
    try {
      showLoading();
      dynamic response = await apiService.userResendOTP(email);
      inspect(response);
      setState(() {
        showResend = false;
      });
      hideLoading();
    } on CustomException catch (e) {
      log('$e');
      hideLoading();
    } catch (e) {
      hideLoading();
      log('$e');
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    resendTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Verify Email",
          style: textStyleBoldBlack(16),
        ),
        leading: Builder(
          builder: (BuildContext context) {
            return GestureDetector(
              child: Container(
                padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                child: const Image(
                  image: AssetImage(
                    ImageAssets.arrowBack,
                  ),
                ),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            );
          },
        ),
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      "Please enter the PIN code you received in the email",
                      style: textStyleRegularBlack(14),
                    ),
                  ),
                  const SizedBox(height: 24),
                  OTPTextField(
                    controller: otpController,
                    length: 6,
                    width: MediaQuery.of(context).size.width,
                    textFieldAlignment: MainAxisAlignment.center,
                    fieldWidth: 40,
                    fieldStyle: FieldStyle.box,
                    outlineBorderRadius: 8,
                    spaceBetween: 16,
                    otpFieldStyle: OtpFieldStyle(
                      borderColor: ColorSelect.appThemeGrey,
                      backgroundColor: ColorSelect.appThemeGrey,
                      focusBorderColor: Colors.black,
                    ),
                    style: textStyleRegularBlack(14),
                    onChanged: (pin) {
                      if (pin.length < 6) {
                        setState(() {
                          pinEntered = false;
                        });
                      }
                    },
                    onCompleted: (pin) {
                      setState(() {
                        otpValue = pin;
                        pinEntered = true;
                      });
                    },
                  ),
                  const SizedBox(height: 24),
                  showResend
                      ? GestureDetector(
                          onTap: resendOTP,
                          behavior: HitTestBehavior.translucent,
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Resend New Code",
                              textAlign: TextAlign.left,
                              style: textStyleViewAll(14),
                            ),
                          ),
                        )
                      : Container(
                          alignment: Alignment.centerLeft,
                          child: CountdownTimer(
                            resendText: 'Resend OTP in',
                            maxSeconds: 60,
                            action: () {
                              setState(() {
                                showResend = true;
                              });
                            },
                          ),
                        ),
                  const SizedBox(height: 36),
                  SubmitButton(
                    onTap: submitOTP,
                    text: "Verify",
                    disabled: false,
                    color: pinEntered
                        ? ColorSelect.lightBlack
                        : ColorSelect.buttonGrey,
                  ),
                ],
              ),
            ),
    );
  }
}
