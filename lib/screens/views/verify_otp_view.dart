import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:lix/app/color_select.dart';
import 'package:lix/app/image_assets.dart';
import 'package:lix/screens/views/bottom_tabs/home_screen_styles.dart';
import 'package:lix/screens/views/dashboard.dart';
import 'package:lix/screens/widgets/submit_button.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';

class VerifyOTPView extends StatefulWidget {
  const VerifyOTPView({Key? key}) : super(key: key);

  @override
  State<VerifyOTPView> createState() => _VerifyOTPViewState();
}

class _VerifyOTPViewState extends State<VerifyOTPView> {
  OtpFieldController otpController = OtpFieldController();
  bool pinEntered = false;
  @override
  Widget build(BuildContext context) {
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
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text("Please enter the PIN code you recieved in the email",
                style: textStyleRegularBlack(14)),
            const SizedBox(height: 24),
            OTPTextField(
                controller: otpController,
                length: 4,
                width: MediaQuery.of(context).size.width,
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
                  if (pin.length < 4) {
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
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "Resend New Code",
                textAlign: TextAlign.left,
                style: textStyleViewAll(14),
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
}
