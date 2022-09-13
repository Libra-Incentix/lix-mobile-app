import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:lix/app/color_select.dart';
import 'package:lix/app/image_assets.dart';
import 'package:lix/locator.dart';
import 'package:lix/models/country_model.dart';
import 'package:lix/models/custom_exception.dart';
import 'package:lix/models/user.dart';
import 'package:lix/screens/views/bottom_tabs/home_screen_styles.dart';
import 'package:lix/screens/views/dashboard.dart';
import 'package:lix/screens/widgets/country_phone_selector.dart';
import 'package:lix/screens/widgets/input_field.dart';
import 'package:lix/screens/widgets/submit_button.dart';
import 'package:lix/screens/widgets/validate_text.dart';
import 'package:collection/collection.dart';
import 'package:lix/services/api.dart';
import 'package:lix/services/helper.dart';
import 'package:lix/services/snackbar.dart';

class RegisterView extends StatefulWidget {
  final String email;
  const RegisterView({
    Key? key,
    required this.email,
  }) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late String email = widget.email;
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  APIService apiServices = locator<APIService>();
  bool loading = false;
  bool validationFailed = false;
  bool passwordMatchedFailed = false;
  Country? selectedCountry;
  List<Country> countries = [
    Country(
      id: 0,
      name: 'Saudi Arabia',
      flag: ImageAssets.flagSaudi,
      phoneCode: '+966',
    ),
    Country(
      id: 1,
      name: 'United Arab Emirates',
      flag: ImageAssets.flagUAE,
      phoneCode: '+971',
    ),
  ];

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

  Future<void> validateAndMove() async {
    if (_firstNameController.text.isEmpty) {
      setState(() {
        validationFailed = true;
      });
      return;
    }

    if (_lastNameController.text.isEmpty) {
      setState(() {
        validationFailed = true;
      });
      return;
    }

    if (_phoneController.text.isEmpty || selectedCountry == null) {
      setState(() {
        validationFailed = true;
      });
      return;
    }

    if (_passwordController.text.isEmpty ||
        _confirmPassController.text.isEmpty) {
      setState(() {
        validationFailed = true;
      });
      return;
    }

    if (_passwordController.text != _confirmPassController.text) {
      setState(() {
        validationFailed = true;
        passwordMatchedFailed = true;
      });
      return;
    }

    // all validation passed
    setState(() {
      validationFailed = false;
      passwordMatchedFailed = false;
    });

    try {
      showLoading();
      String fullName =
          '${_firstNameController.text.trim()} ${_lastNameController.text.trim()}';
      String phoneNo =
          '${selectedCountry!.phoneCode}${_phoneController.text.trim()}';
      String password = _passwordController.text;

      User user = await apiServices.register(
        fullName,
        email,
        phoneNo,
        password,
      );

      // user is registered auto login to the app...
      user = await apiServices.login(email, password);

      await locator<HelperService>().saveUserDetails(user);
      hideLoading();
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Dashboard()),
      );
    } on CustomException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        locator<SnackBarService>().showSnackBarWithString(
          e.message,
        ),
      );
      hideLoading();
    } catch (e) {
      debugPrint('$e');
      hideLoading();
    }
  }

  void showCountryModal(
    BuildContext context,
    List<Country> countryList,
  ) {
    showModalBottomSheet(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      context: context,
      builder: (context) {
        return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Container(
              height: MediaQuery.of(context).size.height - 80,
              color: Colors.transparent,
              child: CountryPhoneSelector(
                countryList: countryList,
                onChanged: (Country country) {
                  setState(() {
                    selectedCountry = country;
                  });
                },
              ),
            );
          },
        );
      },
    );
  }

  onChanged(String fieldName, String value) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text("Complete Registration", style: textStyleBoldBlack(16)),
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
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: loading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      inputField(
                        "First Name",
                        _firstNameController,
                        false,
                        context,
                        onChanged,
                        TextInputType.name,
                      ),
                      ValidateText(
                        isVisible: _firstNameController.text.isEmpty &&
                            validationFailed,
                        text: "Please enter your first name",
                      ),
                      const SizedBox(height: 16),
                      inputField("Last Name", _lastNameController, false,
                          context, onChanged, TextInputType.name),
                      ValidateText(
                        isVisible: _lastNameController.text.isEmpty &&
                            validationFailed,
                        text: "Please enter your last name",
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () {
                                showCountryModal(context, countries);
                              },
                              child: selectedCountry != null
                                  ? Container(
                                      alignment: Alignment.centerRight,
                                      height: 50,
                                      width: 76,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: ColorSelect.appThemeGrey,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          const SizedBox(width: 2),
                                          Image(
                                            height: 18,
                                            width: 24,
                                            image: AssetImage(
                                              selectedCountry!.flag!,
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                          Text(
                                            selectedCountry!.phoneCode!,
                                            style: textStyleRegularBlack(14),
                                          ),
                                          const Icon(
                                            Icons.keyboard_arrow_down,
                                            size: 20,
                                          ),
                                        ],
                                      ),
                                    )
                                  : Container(
                                      alignment: Alignment.centerRight,
                                      height: 50,
                                      width: 76,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: ColorSelect.appThemeGrey,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          const SizedBox(width: 2),
                                          Expanded(
                                            child: Text(
                                              'Select Country',
                                              style: textStyleRegularBlack(14),
                                            ),
                                          ),
                                          const Icon(
                                            Icons.keyboard_arrow_down,
                                            size: 20,
                                          ),
                                        ],
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 2,
                            child: inputField(
                              "Phone number",
                              _phoneController,
                              false,
                              context,
                              onChanged,
                              TextInputType.number,
                            ),
                          )
                        ],
                      ),
                      ValidateText(
                        isVisible:
                            _phoneController.text.isEmpty && validationFailed,
                        text: "Please enter your phone number",
                      ),
                      const SizedBox(height: 4),
                      ValidateText(
                        isVisible: selectedCountry == null && validationFailed,
                        text: "Select a country code",
                      ),
                      const SizedBox(height: 16),
                      inputField(
                        "Password",
                        _passwordController,
                        true,
                        context,
                        onChanged,
                        TextInputType.text,
                      ),
                      ValidateText(
                        isVisible: _passwordController.text.isEmpty &&
                            validationFailed,
                        text: "Please enter your password",
                      ),
                      const SizedBox(height: 4),
                      ValidateText(
                        isVisible: passwordMatchedFailed && validationFailed,
                        text: "Password and confirm password does not match.",
                      ),
                      const SizedBox(height: 16),
                      inputField("Confirm Password", _confirmPassController,
                          true, context, onChanged, TextInputType.text),
                      ValidateText(
                        isVisible: _confirmPassController.text.isEmpty &&
                            validationFailed,
                        text: "Please enter confirm password",
                      ),
                      const SizedBox(height: 4),
                      ValidateText(
                        isVisible: passwordMatchedFailed && validationFailed,
                        text: "Password and confirm password does not match.",
                      ),
                      const SizedBox(height: 16),
                      const SizedBox(height: 24),
                      SubmitButton(
                        onTap: () {
                          validateAndMove();
                        },
                        text: "Continue",
                        disabled: false,
                        color: Colors.black,
                      ),
                      const SizedBox(height: 24),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "By pressing continue you agree on the",
                              textAlign: TextAlign.left,
                              style: textStyleRegularBlack(14),
                            ),
                            const SizedBox(height: 14),
                            Text(
                              "Terms & conditions",
                              textAlign: TextAlign.left,
                              style: textStyleViewAll(14),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
