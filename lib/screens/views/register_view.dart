import 'package:flutter/material.dart';
import 'package:lix/app/color_select.dart';
import 'package:lix/app/image_assets.dart';
import 'package:lix/screens/views/bottom_tabs/home_screen_styles.dart';
import 'package:lix/screens/views/verify_otp_view.dart';
import 'package:lix/screens/widgets/custom_appbar.dart';
import 'package:lix/screens/widgets/input_field.dart';
import 'package:lix/screens/widgets/select_flag.dart';
import 'package:lix/screens/widgets/submit_button.dart';
import 'package:lix/screens/widgets/validate_text.dart';

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
  final TextEditingController _searchCountryController =
      TextEditingController();
  var validationFailed = false;
  var selectedCountry = "United Arab Emirates";
  var countryList = [
    {
      "id": 1,
      "countryName": "Saudi Arabia",
      "countryFlag": ImageAssets.flagSaudi,
      "isSelected": false
    },
    {
      "id": 2,
      "countryName": "United Arab Emirates",
      "countryFlag": ImageAssets.flagUAE,
      "isSelected": true
    }
  ];
  void validateAndMove() {
    if (_firstNameController.text.isEmpty ||
        _lastNameController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPassController.text.isEmpty) {
      setState(() {
        validationFailed = true;
      });
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const VerifyOTPView()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const VerifyOTPView()),
      );
    }
  }

  void showCountryModal(
    BuildContext context,
    List<Map<String, Object>> countryList,
  ) {
    showModalBottomSheet(
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Container(
              height: MediaQuery.of(context).size.height - 80,
              color: Colors.transparent,
              child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0)),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 6,
                      ),
                      customAppBar("Select Country", context),
                      const SizedBox(
                        height: 6,
                      ),
                      Container(
                        height: 46,
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                        child: inputField("Search", _searchCountryController,
                            false, context, onChanged, TextInputType.text,
                            showPrefix: true),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        flex: 1,
                        child: ListView.builder(
                            itemCount: countryList.length,
                            itemBuilder: (context, index) {
                              return SelectFlag(
                                  onTap: (countryName) {
                                    setState(() {
                                      selectedCountry = countryName;
                                    });
                                  },
                                  icon: countryList[index]["countryFlag"]
                                      .toString(),
                                  text: countryList[index]["countryName"]
                                      .toString(),
                                  isSelected: countryList[index]["countryName"]
                                          .toString() ==
                                      selectedCountry);
                            }),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: SubmitButton(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            text: "Change Country",
                            disabled: false,
                            color: Colors.black),
                      ),
                      const SizedBox(height: 20),
                    ],
                  )),
            );
          });
        });
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
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                inputField("First Name", _firstNameController, false, context,
                    onChanged, TextInputType.name),
                ValidateText(
                  isVisible:
                      _firstNameController.text.isEmpty && validationFailed,
                  text: "Please enter your first name",
                ),
                const SizedBox(height: 16),
                inputField("Last Name", _lastNameController, false, context,
                    onChanged, TextInputType.name),
                ValidateText(
                  isVisible:
                      _lastNameController.text.isEmpty && validationFailed,
                  text: "Please enter your last name",
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: () {
                          showCountryModal(context, countryList);
                        },
                        child: Container(
                          alignment: Alignment.centerRight,
                          height: 50,
                          width: 76,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: ColorSelect.appThemeGrey,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const SizedBox(width: 2),
                              const Image(
                                height: 18,
                                width: 24,
                                image: AssetImage(ImageAssets.flagUAE),
                                fit: BoxFit.cover,
                              ),
                              Text("+971", style: textStyleRegularBlack(14)),
                              const Icon(Icons.keyboard_arrow_down, size: 20)
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                        flex: 2,
                        child: inputField("Phone number", _phoneController,
                            false, context, onChanged, TextInputType.number))
                  ],
                ),
                ValidateText(
                  isVisible: _phoneController.text.isEmpty && validationFailed,
                  text: "Please enter your phone number",
                ),
                const SizedBox(height: 16),
                inputField("Password", _passwordController, true, context,
                    onChanged, TextInputType.text),
                ValidateText(
                  isVisible:
                      _passwordController.text.isEmpty && validationFailed,
                  text: "Please enter your password",
                ),
                const SizedBox(height: 16),
                inputField("Confirm Password", _confirmPassController, true,
                    context, onChanged, TextInputType.text),
                ValidateText(
                  isVisible:
                      _confirmPassController.text.isEmpty && validationFailed,
                  text: "Please enter confirm password",
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
