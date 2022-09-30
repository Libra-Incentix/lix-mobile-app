import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:lix/app/color_select.dart';
import 'package:lix/app/image_assets.dart';
import 'package:lix/locator.dart';
import 'package:lix/screens/views/bottom_tabs/home_screen_styles.dart';
import 'package:lix/screens/views/dashboard.dart';
import 'package:lix/screens/widgets/loader.dart';
import 'package:lix/screens/widgets/submit_button.dart';
import 'package:lix/services/api.dart';
import 'package:lix/services/helper.dart';
import 'package:lix/services/snackbar.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';

class VerifyOTPView extends StatefulWidget {
  final String emailController; //if you have multiple values add here
  VerifyOTPView({required this.emailController, Key? key}) : super(key: key);

  @override
  State<VerifyOTPView> createState() => _VerifyOTPViewState();
}

class _VerifyOTPViewState extends State<VerifyOTPView> {
  OtpFieldController otpController = OtpFieldController();
  HelperService helperService = locator<HelperService>();
  APIService apiServices = locator<APIService>();

  bool pinEntered = false;

  @override
  Widget build(BuildContext context) {
      double width = MediaQuery.of(context).size.width;
      var media = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text("Verify Email", style: textStyleBoldBlack(16)),
        leading: Builder(
          builder: (BuildContext context) {
            return GestureDetector(
              child: Container(
                padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                child: const Image(image: AssetImage(ImageAssets.arrowBack)),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            );
          },
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(media.width * 0.02),
        //padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text("Please enter the PIN code you recieved in the email",
                style: textStyleRegularBlack(14)),
            const SizedBox(height: 24),
            OTPTextField(
                controller: otpController,
                length: 6,
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                textFieldAlignment: MainAxisAlignment.start,
                fieldWidth: 50,
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
                    pinEntered = true;
                  });
                }),
            const SizedBox(height: 24),
            InkWell(
              onTap: () async {
                resendOTP(widget.emailController);
              },
              child: Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Resend New Code",
                  textAlign: TextAlign.left,
                  style: textStyleViewAll(14),
                ),
              ),
            ),
            const SizedBox(height: 36),
            SubmitButton(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Dashboard(),
                  ),
                );
              },
              text: "Verify",
              disabled: false,
              color:
              pinEntered ? ColorSelect.lightBlack : ColorSelect.buttonGrey,
            ),
          ],
        ),
      ),
    );
  }

  resendOTP(String email) async {
    setState(() {
      Loading(context);
    });
    bool resendOTP = await apiServices.resendOTP(email);

     print('XXXXXXXXXXX: ${email}');

    if (resendOTP == true) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        locator<SnackBarService>().showSnackBarWithSuccess(
          'We have sent the OTP code to your email, check your mail inbox',
        ),
      );
    } else {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        locator<SnackBarService>().showSnackBarWithString(
          'Error sending OTP, try again',
        ),
      );
    }
  }
}