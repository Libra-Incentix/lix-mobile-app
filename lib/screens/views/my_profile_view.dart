import 'package:flutter/material.dart';
import 'package:lix/app/color_select.dart';
import 'package:lix/app/image_assets.dart';
import 'package:lix/locator.dart';
import 'package:lix/models/country_model.dart';
import 'package:lix/models/custom_exception.dart';
import 'package:lix/models/user.dart';
import 'package:lix/screens/views/bottom_tabs/home_screen_styles.dart';
import 'package:lix/screens/widgets/input_field.dart';
import 'package:lix/services/api.dart';
import 'package:lix/services/helper.dart';

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

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _searchCountryController =
      TextEditingController();

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
      User u = await apiService.retrieveUserProfile(user);
      setState(() {
        if (!mounted) return;
        profileUser = u;
        _nameController.text = profileUser!.name!;
        _emailController.text = profileUser!.email!;
        _phoneController.text = profileUser!.phone!;
      });
      hideLoading();
    } on CustomException catch (e) {
      hideLoading();
    } catch (e) {
      hideLoading();
    }
  }

  @override
  void initState() {
    initialize();
    super.initState();
  }

  // void showCountryModal(
  //   BuildContext context,
  //   List<Country> countryList,
  // ) {
  //   showModalBottomSheet(
  //       isScrollControlled: true,
  //       shape: const RoundedRectangleBorder(
  //         borderRadius: BorderRadius.all(Radius.circular(10.0)),
  //       ),
  //       context: context,
  //       builder: (context) {
  //         return StatefulBuilder(
  //             builder: (BuildContext context, StateSetter setState) {
  //           return Container(
  //             height: MediaQuery.of(context).size.height - 80,
  //             color: Colors.transparent,
  //             child: Container(
  //                 decoration: const BoxDecoration(
  //                   color: Colors.white,
  //                   borderRadius: BorderRadius.only(
  //                       topLeft: Radius.circular(20.0),
  //                       topRight: Radius.circular(20.0)),
  //                 ),
  //                 child: Column(
  //                   children: [
  //                     const SizedBox(
  //                       height: 6,
  //                     ),
  //                     customAppBar("Select Country", context),
  //                     const SizedBox(
  //                       height: 6,
  //                     ),
  //                     Container(
  //                       height: 46,
  //                       padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
  //                       child: inputField("Search", _searchCountryController,
  //                           false, context, () {}, TextInputType.text,
  //                           showPrefix: true),
  //                     ),
  //                     const SizedBox(
  //                       height: 10,
  //                     ),
  //                     Expanded(
  //                       flex: 1,
  //                       child: ListView.builder(
  //                           itemCount: countryList.length,
  //                           itemBuilder: (context, index) {
  //                             return SelectFlag(
  //                                 onTap: (countryName) {
  //                                   setState(() {
  //                                     selectedCountry = countryName;
  //                                   });
  //                                 },
  //                                 icon: countryList[index]["countryFlag"]
  //                                     .toString(),
  //                                 text: countryList[index]["countryName"]
  //                                     .toString(),
  //                                 isSelected: countryList[index]["countryName"]
  //                                         .toString() ==
  //                                     selectedCountry);
  //                           }),
  //                     ),
  //                     Container(
  //                       padding: const EdgeInsets.all(10),
  //                       child: SubmitButton(
  //                           onTap: () {
  //                             Navigator.pop(context);
  //                           },
  //                           text: "Change Country",
  //                           disabled: false,
  //                           color: Colors.black),
  //                     ),
  //                     const SizedBox(height: 20),
  //                   ],
  //                 )),
  //           );
  //         });
  //       });
  // }

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
                onTap: () {
                  Navigator.of(context).pop();
                },
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
                    const CircleAvatar(
                      radius: 50.0,
                      backgroundImage:
                          AssetImage('assets/icons/profile_user.png'),
                      backgroundColor: Colors.transparent,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Edit",
                      style: textStyleViewAll(14),
                    ),
                    const SizedBox(height: 24),
                    inputField(
                      "Last Name",
                      _nameController,
                      false,
                      context,
                      () {},
                      TextInputType.name,
                    ),
                    const SizedBox(height: 16),
                    inputField(
                      "Email",
                      _emailController,
                      false,
                      context,
                      () {},
                      TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Theme(
                          data: Theme.of(context)
                              .copyWith(dividerColor: Colors.transparent),
                          child: Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () {
                                // showCountryModal(context, countries);
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    const SizedBox(width: 2),
                                    const Image(
                                      height: 18,
                                      width: 24,
                                      image: AssetImage(ImageAssets.flagUAE),
                                      fit: BoxFit.cover,
                                    ),
                                    Text("+971",
                                        style: textStyleRegularBlack(14)),
                                    const Icon(Icons.keyboard_arrow_down,
                                        size: 20)
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                            flex: 2,
                            child: inputField("Phone number", _phoneController,
                                false, context, () {}, TextInputType.number))
                      ],
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () => {},
                      behavior: HitTestBehavior.translucent,
                      child: Container(
                        height: 50,
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(
                          left: 8,
                        ),
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(
                          color: ColorSelect.appThemeGrey,
                          borderRadius: BorderRadius.all(
                            Radius.circular(8),
                          ),
                        ),
                        child: const Text('Date Of Birth'),
                      ),
                    ),
                    inputField(
                      "Date of Birth",
                      _dobController,
                      false,
                      context,
                      () {},
                      TextInputType.text,
                      onTap: openDatePicker,
                    ),
                    ExpansionTile(
                      tilePadding: EdgeInsets.fromLTRB(
                          0, 0, MediaQuery.of(context).size.width / 2.2, 0),
                      childrenPadding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 0),
                      expandedCrossAxisAlignment: CrossAxisAlignment.start,
                      expandedAlignment: Alignment.topLeft,
                      maintainState: true,
                      collapsedIconColor: ColorSelect.appThemeOrange,
                      iconColor: ColorSelect.appThemeOrange,
                      title: Text(
                        "Change password",
                        style: textStyleViewAll(14),
                      ),
                      children: <Widget>[
                        inputField("Password", _passwordController, true,
                            context, () {}, TextInputType.text),
                        const SizedBox(height: 16),
                        inputField("Confirm Password", _confirmPassController,
                            true, context, () {}, TextInputType.text),
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
    DateTime? currentDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime.now(),
    );

    if (currentDate != null) {
      _dobController.text =
          '${currentDate.day}/${currentDate.month}/${currentDate.year}';
    }
  }
}
