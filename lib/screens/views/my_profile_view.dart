import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lix/app/color_select.dart';
import 'package:lix/app/image_assets.dart';
import 'package:lix/locator.dart';
import 'package:lix/models/country_phone_model.dart';
import 'package:lix/models/custom_exception.dart';
import 'package:lix/models/user.dart';
import 'package:lix/screens/views/bottom_tabs/home_screen_styles.dart';
import 'package:lix/screens/widgets/country_phone_selector.dart';
import 'package:lix/screens/widgets/input_field.dart';
import 'package:lix/screens/widgets/submit_button.dart';
import 'package:lix/screens/widgets/validate_text.dart';
import 'package:lix/services/api.dart';
import 'package:lix/services/helper.dart';
import 'package:lix/services/snackbar.dart';

class MyProfileView extends StatefulWidget {
  const MyProfileView({Key? key}) : super(key: key);

  @override
  State<MyProfileView> createState() => _MyProfileViewState();
}

class _MyProfileViewState extends State<MyProfileView> {
  late User user = locator<HelperService>().getCurrentUser()!;
  User? profileUser;
  APIService apiService = locator<APIService>();
  HelperService helperService = locator<HelperService>();
  bool loading = false;
  bool validationFailed = false;
  bool phoneLengthError = false;
  bool passwordMatchedFailed = false;
  bool passwordValidationFailed = false;
  bool changePasswordOpened = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _searchCountryController =
      TextEditingController();

  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();

  List<String> genders = ['male', 'female', 'other'];
  CountryPhone? selectedCountry;
  List<CountryPhone> countries = [];

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

  initialize() async {
    try {
      showLoading();
      // List<CountryPhone> allCountries = await apiService.getAllPhoneCountries();
      User u = await apiService.retrieveUserProfile(user);
      setState(() {
        if (!mounted) return;
        // countries = allCountries;
        profileUser = u;
        profileUser!.email = user.email;
        userImageUrl = profileUser!.avatar!;
        _nameController.text = profileUser!.name!;
        _emailController.text = profileUser!.email!;
        _phoneController.text = profileUser!.phone!;
        if (profileUser!.dateOfBirth != null) {
          _dobController.text = profileUser!.dateOfBirth!;
        }

        if (profileUser!.gender != null && profileUser!.gender!.isNotEmpty) {
          _genderController.text = profileUser!.gender!;
        }
      });
      hideLoading();
    } on CustomException catch (e) {
      hideLoading();
      log('$e');
    } catch (e) {
      hideLoading();
      log('$e');
    }
  }

  updateProfile() async {
    if (_nameController.text.isEmpty) {
      setState(() {
        validationFailed = true;
      });
      return;
    }

    if (_phoneController.text.isEmpty) {
      // || selectedCountry == null
      setState(() {
        validationFailed = true;
      });
      return;
    }

    if (_dobController.text.isEmpty) {
      setState(() {
        validationFailed = true;
      });
      return;
    }

    // if (_phoneController.text.length < phoneMinLength ||
    //     _phoneController.text.length > phoneMaxLength) {
    //   setState(() {
    //     validationFailed = true;
    //     phoneLengthError = true;
    //   });
    //   return;
    // }

    // all validation passed
    setState(() {
      validationFailed = false;
      // phoneLengthError = false;
    });

    try {
      showLoading();
      // assigning all the updated variables...
      profileUser!.name = _nameController.text;
      profileUser!.phone = _phoneController.text;
      profileUser!.dateOfBirth = _dobController.text;
      profileUser!.gender = _genderController.text;

      // adding token on the same data as well.
      profileUser!.userToken = user.userToken;

      Map<String, dynamic> response =
          await apiService.updateUserProfile(profileUser!, imagePath);
      hideLoading();

      if (response['success'] != null) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          locator<SnackBarService>().showSnackBarWithString(
            response['message'] ?? '',
            type:
                response['success'] ? SnackBarType.success : SnackBarType.error,
          ),
        );

        // first create a temp user...
        User tUser = User.fromJson(response['data']);

        // now update the data for the user...
        tUser.name = tUser.name;
        tUser.phone = tUser.phone;
        tUser.gender = tUser.gender;
        user.dateOfBirth = tUser.dateOfBirth;

        // now save the updated user details...
        await helperService.saveUserDetails(user);

        // now move user back...
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      }
    } catch (e) {
      hideLoading();
      log('$e');
    }
  }

  String imagePath = "";
  String imageName = "";
  String codeReceived = "";
  String userImageUrl = "";
  File? image;
  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      setState(() => {imagePath = image.path, imageName = image.name});
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  @override
  void initState() {
    initialize();
    super.initState();
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _passwordController.dispose();
    _confirmPassController.dispose();
    super.dispose();
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
                  });
                },
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text("My Profile", style: textStyleBoldBlack(16)),
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
        actions: [
          Center(
            child: Container(
              padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
              child: GestureDetector(
                onTap: updateProfile,
                child: Text(
                  'Save',
                  style: textStyleMediumBlack(14),
                ),
              ),
            ),
          )
        ],
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50.0,
                      backgroundColor: Colors.transparent,
                      child: ClipOval(
                        child: (imagePath != "")
                            ? Image.file(
                                File(imagePath),
                                height: 100.0,
                                width: 100.0,
                                fit: BoxFit.cover,
                              )
                            : (userImageUrl != ""
                                ? Image.network(
                                    apiService.imagesPath +
                                        profileUser!.avatar!,
                                    height: 100.0,
                                    width: 100.0,
                                    fit: BoxFit.cover,
                                  )
                                : Image.asset(
                                    'assets/images/avatar.png',
                                    height: 100.0,
                                    width: 100.0,
                                    fit: BoxFit.cover,
                                  )),
                      ),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        pickImage();
                      },
                      child: Text(
                        "Edit",
                        style: textStyleViewAll(14),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // gender field...
                    genderField(),
                    const SizedBox(height: 16),
                    inputField(
                      "Name",
                      _nameController,
                      false,
                      context,
                      simpleOnChanged,
                      TextInputType.name,
                    ),
                    ValidateText(
                      isVisible:
                          _nameController.text.isEmpty && validationFailed,
                      text: "Please enter your name",
                    ),
                    const SizedBox(height: 16),
                    inputField(
                      "Email",
                      _emailController,
                      false,
                      context,
                      simpleOnChanged,
                      TextInputType.emailAddress,
                      isEnabled: false,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        // Theme(
                        //   data: Theme.of(context).copyWith(
                        //     dividerColor: Colors.transparent,
                        //   ),
                        //   child: Expanded(
                        //     flex: 1,
                        //     child: GestureDetector(
                        //       onTap: () {
                        //         showCountryModal(context, countries);
                        //       },
                        //       child: selectedCountry != null
                        //           ? Container(
                        //               alignment: Alignment.centerRight,
                        //               height: 50,
                        //               width: 76,
                        //               decoration: BoxDecoration(
                        //                 borderRadius: BorderRadius.circular(8),
                        //                 color: ColorSelect.appThemeGrey,
                        //               ),
                        //               child: Row(
                        //                 mainAxisAlignment:
                        //                     MainAxisAlignment.spaceEvenly,
                        //                 children: [
                        //                   const SizedBox(width: 2),
                        //                   Image(
                        //                     height: 18,
                        //                     width: 24,
                        //                     image: AssetImage(
                        //                       selectedCountry!.flag!,
                        //                     ),
                        //                     fit: BoxFit.cover,
                        //                   ),
                        //                   Text(
                        //                     selectedCountry!.dialCode!,
                        //                     style: textStyleRegularBlack(14),
                        //                   ),
                        //                   const Icon(
                        //                     Icons.keyboard_arrow_down,
                        //                     size: 20,
                        //                   ),
                        //                 ],
                        //               ),
                        //             )
                        //           : Container(
                        //               alignment: Alignment.centerRight,
                        //               height: 50,
                        //               width: 76,
                        //               decoration: BoxDecoration(
                        //                 borderRadius: BorderRadius.circular(8),
                        //                 color: ColorSelect.appThemeGrey,
                        //               ),
                        //               child: Row(
                        //                 mainAxisAlignment:
                        //                     MainAxisAlignment.spaceEvenly,
                        //                 children: [
                        //                   const SizedBox(width: 2),
                        //                   Expanded(
                        //                     child: Text(
                        //                       'Select Country',
                        //                       style: textStyleRegularBlack(14),
                        //                     ),
                        //                   ),
                        //                   const Icon(
                        //                     Icons.keyboard_arrow_down,
                        //                     size: 20,
                        //                   ),
                        //                 ],
                        //               ),
                        //             ),
                        //     ),
                        //   ),
                        // ),
                        // const SizedBox(width: 10),
                        Expanded(
                          flex: 2,
                          child: inputField(
                            "Phone number",
                            _phoneController,
                            false,
                            context,
                            simpleOnChanged,
                            TextInputType.number,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 16),
                    inputField(
                      "Date of Birth",
                      _dobController,
                      false,
                      context,
                      simpleOnChanged,
                      TextInputType.text,
                      onTap: openDatePicker,
                    ),
                    ValidateText(
                      isVisible:
                          _dobController.text.isEmpty && validationFailed,
                      text: "Please enter your dob",
                    ),
                    ExpansionTile(
                      tilePadding: EdgeInsets.fromLTRB(
                          0, 0, MediaQuery.of(context).size.width / 2.2, 0),
                      childrenPadding: EdgeInsets.zero,
                      expandedCrossAxisAlignment: CrossAxisAlignment.start,
                      expandedAlignment: Alignment.topLeft,
                      maintainState: true,
                      collapsedIconColor: ColorSelect.appThemeOrange,
                      iconColor: ColorSelect.appThemeOrange,
                      initiallyExpanded: changePasswordOpened,
                      onExpansionChanged: (value) {
                        setState(() {
                          changePasswordOpened = value;
                        });
                      },
                      title: Text(
                        "Change password",
                        style: textStyleViewAll(14),
                      ),
                      children: <Widget>[
                        const SizedBox(height: 5),
                        inputField(
                          "Current Password",
                          _oldPasswordController,
                          true,
                          context,
                          simpleOnChanged,
                          TextInputType.text,
                        ),
                        ValidateText(
                          isVisible: _oldPasswordController.text.isEmpty &&
                              passwordValidationFailed,
                          text: "Please enter your old password.",
                        ),
                        const SizedBox(height: 16),
                        inputField(
                          "New Password",
                          _passwordController,
                          true,
                          context,
                          simpleOnChanged,
                          TextInputType.text,
                        ),
                        ValidateText(
                          isVisible: _passwordController.text.isEmpty &&
                              passwordValidationFailed,
                          text: "Please enter your new password.",
                        ),
                        const SizedBox(height: 16),
                        inputField(
                          "Confirm Password",
                          _confirmPassController,
                          true,
                          context,
                          simpleOnChanged,
                          TextInputType.text,
                        ),
                        ValidateText(
                          isVisible: _confirmPassController.text.isEmpty &&
                              passwordValidationFailed,
                          text: "Please confirm your new password.",
                        ),
                        ValidateText(
                          isVisible: _confirmPassController.text.isNotEmpty &&
                              passwordMatchedFailed,
                          text:
                              "New password and confirm password are not same.",
                        ),
                        const SizedBox(height: 16),
                        SubmitButton(
                          onTap: updateNewPassword,
                          text: 'Change',
                          color: ColorSelect.lightBlack,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
    );
  }

  openDatePicker() async {
    DateTime initialDate = _dobController.text.isNotEmpty
        ? DateTime.parse(_dobController.text)
        : DateTime.now();
    DateTime? currentDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1960),
      lastDate: DateTime.now(),
    );

    if (currentDate != null) {
      _dobController.text =
          '${currentDate.year}-${currentDate.month.toString().padLeft(2, '0')}-${currentDate.day.toString().padLeft(2, '0')}';
      debugPrint(_dobController.text);
    }
  }

  genderField() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 50,
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField(
          icon: const Icon(
            Icons.keyboard_arrow_down,
          ),
          iconSize: 22,
          value: _genderController.text,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            filled: true,
            fillColor: ColorSelect.appThemeGrey,
            labelText: 'Gender',
            labelStyle: const TextStyle(
              fontSize: 14,
              color: ColorSelect.greyDark,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: (profileUser!.gender != null &&
                        profileUser!.gender!.isNotEmpty)
                    ? ColorSelect.appThemeGrey
                    : Colors.black,
                width: 0.6,
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(8),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: (profileUser!.gender != null &&
                        profileUser!.gender!.isNotEmpty)
                    ? ColorSelect.appThemeGrey
                    : Colors.black,
                width: 0.6,
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(8),
              ),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
            ),
          ),
          onChanged: (dynamic g) {
            _genderController.text = g;
          },
          items: genders.map((e) {
            return DropdownMenuItem(
              value: e,
              child: Text(e),
            );
          }).toList(),
        ),
      ),
    );
  }

  simpleOnChanged(String fieldName, String value) {
    // this is for current password.
    if (fieldName == 'Current Password' ||
        fieldName == 'New Password' ||
        fieldName == 'Confirm Password') {
      if (value.isEmpty) {
        setState(() {
          passwordValidationFailed = true;
        });
      } else {
        setState(() {
          passwordValidationFailed = false;
        });
      }
    }

    if (fieldName == 'New Password' || fieldName == 'Confirm Password') {
      if (_passwordController.text != _confirmPassController.text) {
        setState(() {
          passwordMatchedFailed = true;
        });
      } else {
        setState(() {
          passwordMatchedFailed = false;
        });
      }
    }
  }

  updateNewPassword() async {
    try {
      showLoading();
      bool changed = await apiService.changePassword(
        user,
        _oldPasswordController.text,
        _passwordController.text,
        _confirmPassController.text,
      );
      hideLoading();
      if (changed) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          locator<SnackBarService>().showSnackBarWithString(
            'Your password is changed successfully.',
            type: SnackBarType.success,
          ),
        );
      }
    } on CustomException catch (e) {
      log('$e');
      hideLoading();
      ScaffoldMessenger.of(context).showSnackBar(
        locator<SnackBarService>().showSnackBarWithString(
          e.message,
        ),
      );
    } catch (e) {
      log('$e');
      hideLoading();
    }
  }
}
