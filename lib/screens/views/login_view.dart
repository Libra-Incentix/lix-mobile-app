// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:lix/app/color_select.dart';
import 'package:lix/app/image_assets.dart';
import 'package:lix/locator.dart';
import 'package:lix/models/custom_exception.dart';
import 'package:lix/screens/views/bottom_tabs/home_screen_styles.dart';
import 'package:lix/screens/views/register_view.dart';
import 'package:lix/screens/views/verify_otp_view.dart';
import 'package:lix/screens/widgets/custom_appbar.dart';
import 'package:lix/screens/widgets/image_button.dart';
import 'package:lix/screens/widgets/input_field.dart';
import 'package:lix/screens/widgets/submit_button.dart';
import 'package:lix/screens/widgets/validate_text.dart';
import 'package:lix/services/api.dart';
import 'package:lix/services/helper.dart';
import 'package:lix/services/snackbar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  HelperService helperService = locator<HelperService>();
  APIService apiServices = locator<APIService>();
  SnackBarService snackBarService = locator<SnackBarService>();

  bool isFormInvalid = false;
  bool canSubmitForm = false;
  bool loading = false;
  bool isRegistered = false;

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    // Optional clientId
    clientId:
        '68859954393-1h6a8thjnh8615bgt1ukiquv1piengem.apps.googleusercontent.com',
    scopes: <String>[
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  showLoading() {
    setState(() {
      loading = true;
    });
  }

  hideLoading() {
    setState(() {
      loading = false;
    });
  }

  bool isEmailValid(String email) {
    return RegExp(
            r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
        .hasMatch(email);
  }

  onChanged(String fieldName, String value) {
    if (fieldName == 'Email') {
      if (value.isEmpty || !isEmailValid(value)) {
        setState(() {
          canSubmitForm = false;
        });
      } else {
        setState(() {
          canSubmitForm = true;
        });
      }
    }
    if (fieldName == 'Password') {
      if (value.isEmpty) {
        setState(() {
          canSubmitForm = false;
        });
      } else {
        setState(() {
          canSubmitForm = true;
        });
      }
    }
  }

  void moveLoginOrRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RegisterView(
          email: _emailController.text,
        ),
      ),
    );
  }

  Future<void> loginWithGoogle() async {
    GoogleSignInAccount? user = await _googleSignIn.signIn();
    if (user?.email != null) {
      _emailController.text = user?.email ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: customAppBar("Login or Register", context),
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    inputField(
                      "Email",
                      _emailController,
                      false,
                      context,
                      onChanged,
                      TextInputType.emailAddress,
                    ),
                    ValidateText(
                      isVisible: _emailController.text.isEmpty && isFormInvalid,
                      text: "Please enter a valid email id",
                    ),
                    const SizedBox(height: 24),
                    isRegistered
                        ? Column(
                            children: [
                              inputField(
                                'Password',
                                _passwordController,
                                true,
                                context,
                                onChanged,
                                TextInputType.text,
                              ),
                              ValidateText(
                                isVisible: _passwordController.text.isEmpty &&
                                    isFormInvalid,
                                text: "Please enter your password",
                              ),
                              const SizedBox(height: 24),
                            ],
                          )
                        : Container(),
                    SubmitButton(
                      onTap: login,
                      text: loginButtonText(),
                      disabled: false,
                      color: canSubmitForm
                          ? ColorSelect.lightBlack
                          : ColorSelect.buttonGrey,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () async {
                            Uri url = Uri.parse(
                                'http://app2.libraincentix.com/password/reset');

                            bool canLaunch = await canLaunchUrl(url);

                            if (canLaunch) {
                              launchUrl(url);
                            }
                          },
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 2.5,
                          height: 1,
                          color: Colors.black,
                        ),
                        Text(
                          "OR",
                          style: textStyleBoldBlack(14),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 2.5,
                          height: 1,
                          color: Colors.black,
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    // ImageButton(
                    //   onTap: () {},
                    //   text: 'Continue with Apple',
                    //   buttonIcon: ImageAssets.appleLogoButton,
                    // ),
                    // const SizedBox(height: 16),
                    ImageButton(
                      onTap: () {
                        loginWithGoogle();
                      },
                      text: 'Continue with Google',
                      buttonIcon: ImageAssets.googleLogoButton,
                    ),
                    // const SizedBox(height: 16),
                    // ImageButton(
                    //   onTap: () {},
                    //   text: 'Continue with Facebook',
                    //   buttonIcon: ImageAssets.fbLogoButton,
                    // )
                  ],
                ),
              ),
            ),
    );
  }

  login() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text;

    if (email.isEmpty || !isEmailValid(email)) {
      setState(() {
        isFormInvalid = true;
      });
      return;
    }

    if (isRegistered) {
      if (password.isEmpty) {
        setState(() {
          isFormInvalid = true;
        });
        return;
      }
    }

    setState(() {
      isFormInvalid = false;
    });

    try {
      showLoading();
      if (isRegistered) {
        Map<String, dynamic> response =
            await apiServices.login(email, password);

        ScaffoldMessenger.of(context).showSnackBar(
          snackBarService.showSnackBarWithString(
            response['message'],
            type: (response['success'] ?? false)
                ? SnackBarType.success
                : SnackBarType.error,
          ),
        );

        if (response['success']) {
          // ignore: use_build_context_synchronously
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VerifyOTPView(
                email: email,
              ),
            ),
          );
        }
      } else {
        Map<String, dynamic> response =
            await apiServices.isEmailRegistered(email);

        setState(() {
          if (!mounted) return;
          isRegistered = response['success'] ?? false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          snackBarService.showSnackBarWithString(
            response['message'],
            type: isRegistered ? SnackBarType.success : SnackBarType.error,
          ),
        );

        if (!isRegistered) {
          moveLoginOrRegister();
        }
      }
      hideLoading();
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
    }
  }

  loginButtonText() {
    if (isRegistered) {
      return 'Login';
    }
    return 'Continue';
  }
}
