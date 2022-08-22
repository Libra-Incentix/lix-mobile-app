import 'package:flutter/material.dart';
import 'package:lix/app/color_select.dart';
import 'package:lix/app/image_assets.dart';
import 'package:lix/screens/views/bottom_tabs/home_screen_styles.dart';
import 'package:lix/screens/views/register_view.dart';
import 'package:lix/screens/widgets/custom_appbar.dart';
import 'package:lix/screens/widgets/image_button.dart';
import 'package:lix/screens/widgets/input_field.dart';
import 'package:lix/screens/widgets/submit_button.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _emailController = TextEditingController();
  var canSubmitForm = false;

  bool isEmailValid(String email) {
    return RegExp(
            r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
        .hasMatch(email);
  }

  onChanged(String fieldName, String value) {
    setState(() {
      canSubmitForm = isEmailValid(value);
    });
  }

  void moveLoginOrRegister() {
    // if (canSubmitForm) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RegisterView(
          email: _emailController.text,
        ),
      ),
    );
    //}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: customAppBar("Login or Register", context)),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              inputField("Email", _emailController, false, context, onChanged,
                  TextInputType.emailAddress),
              const SizedBox(height: 24),
              SubmitButton(
                onTap: () {
                  moveLoginOrRegister();
                },
                text: "Continue",
                disabled: false,
                color: canSubmitForm
                    ? ColorSelect.lightBlack
                    : ColorSelect.buttonGrey,
              ),
              const SizedBox(height: 40),
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
              ImageButton(
                onTap: () {},
                text: 'Continue with Apple',
                buttonIcon: ImageAssets.appleLogoButton,
              ),
              const SizedBox(height: 16),
              ImageButton(
                onTap: () {},
                text: 'Continue with Google',
                buttonIcon: ImageAssets.googleLogoButton,
              ),
              const SizedBox(height: 16),
              ImageButton(
                onTap: () {},
                text: 'Continue with Facebook',
                buttonIcon: ImageAssets.fbLogoButton,
              )
            ],
          ),
        ),
      ),
    );
  }
}
