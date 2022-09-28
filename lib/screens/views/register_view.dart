import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:lix/app/color_select.dart';
import 'package:lix/app/image_assets.dart';
import 'package:lix/locator.dart';
import 'package:lix/models/country_phone_model.dart';
import 'package:lix/models/custom_exception.dart';
import 'package:lix/models/user.dart';
import 'package:lix/screens/views/bottom_tabs/home_screen_styles.dart';
import 'package:lix/screens/views/dashboard.dart';
import 'package:lix/screens/views/verify_otp_view.dart';
import 'package:lix/screens/widgets/country_phone_selector.dart';
import 'package:lix/screens/widgets/input_field.dart';
import 'package:lix/screens/widgets/submit_button.dart';
import 'package:lix/screens/widgets/validate_text.dart';
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
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  APIService apiService = locator<APIService>();
  SnackBarService snackBarService = locator<SnackBarService>();
  bool loading = false;
  bool validationFailed = false;
  bool phoneLengthError = false;
  bool passwordMatchedFailed = false;
  CountryPhone? selectedCountry;
  List<CountryPhone> countries = [];
  int phoneMinLength = 10;
  int phoneMaxLength = 10;

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
    if (_nameController.text.isEmpty) {
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

    if (_phoneController.text.length < phoneMinLength ||
        _phoneController.text.length > phoneMaxLength) {
      setState(() {
        validationFailed = true;
        phoneLengthError = true;
      });
      return;
    }

    // all validation passed
    setState(() {
      validationFailed = false;
      phoneLengthError = false;
    });

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
      phoneLengthError = false;
    });

    try {
      showLoading();
      String fullName = _nameController.text.trim();
      String phoneNo =
          '${selectedCountry!.dialCode}${_phoneController.text.trim()}';
      String password = _passwordController.text;

      Map<String, dynamic> response = await apiService.register(
        fullName,
        email,
        phoneNo,
        password,
      );

      // user is registered auto login to the app...
      Map<String, dynamic> lResponse = await apiService.login(email, password);
      hideLoading();

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        snackBarService.showSnackBarWithString(
          lResponse['message'] ?? '',
          type: (lResponse['success'] ?? false)
              ? SnackBarType.success
              : SnackBarType.error,
        ),
      );

      if (lResponse['success']) {
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
    List<CountryPhone> countryList,
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
                onChanged: (CountryPhone country) {
                  setState(() {
                    selectedCountry = country;
                    phoneMinLength = country.dialMinLength ?? 10;
                    phoneMaxLength = country.dialMaxLength ?? 10;
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

  initialize() async {
    try {
      List<CountryPhone> allCountries = await apiService.getAllPhoneCountries();
      if (allCountries.isNotEmpty) {
        if (!mounted) return;
        countries = allCountries;
      }
    } catch (e) {
      log('$e');
    }
  }

  @override
  void initState() {
    initialize();
    super.initState();
  }

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
                        "Name",
                        _nameController,
                        false,
                        context,
                        onChanged,
                        TextInputType.name,
                      ),
                      ValidateText(
                        isVisible:
                            _nameController.text.isEmpty && validationFailed,
                        text: "Please enter your name",
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
                                          Image.network(
                                            selectedCountry!.flag!,
                                            height: 18,
                                            width: 24,
                                            fit: BoxFit.cover,
                                            cacheHeight: 24,
                                            cacheWidth: 24,
                                          ),
                                          Text(
                                            selectedCountry!.dialCode!,
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
                              maxLength: phoneMaxLength,
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
                      const SizedBox(height: 4),
                      ValidateText(
                        isVisible: phoneLengthError && validationFailed,
                        text: "Please enter a valid phone number",
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
                      inputField(
                        "Confirm Password",
                        _confirmPassController,
                        true,
                        context,
                        onChanged,
                        TextInputType.text,
                      ),
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
