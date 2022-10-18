import 'package:flutter/material.dart';
import 'package:lix/app/image_assets.dart';
import 'package:lix/locator.dart';
import 'package:lix/models/user.dart';
import 'package:lix/screens/views/login_view.dart';
import 'package:lix/screens/widgets/settings_item.dart';
import 'package:lix/services/api.dart';
import 'package:lix/services/helper.dart';
import 'package:lix/services/snackbar.dart';

class PrivacySettingsScreen extends StatefulWidget {
  PrivacySettingsScreen({Key? key}) : super(key: key);

  @override
  State<PrivacySettingsScreen> createState() => _PrivacySettingsScreenState();
}

class _PrivacySettingsScreenState extends State<PrivacySettingsScreen> {
  late User user = locator<HelperService>().getCurrentUser()!;
  HelperService helperService = locator<HelperService>();
  APIService apiService = locator<APIService>();
  SnackBarService snackBarService = locator<SnackBarService>();

  bool loading = false;
  showLoading() {
    if (!mounted) return;
    setState(() {
      loading = true;
    });
  }

  hideLoading() {
    if (!mounted) return;
    setState(() {
      loading = false;
    });
  }

  showAlertDialog(BuildContext context) {
    BuildContext dialogContext = context;
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("No"),
      onPressed: () {
        Navigator.pop(dialogContext, false);
      },
    );
    Widget continueButton = TextButton(
      child: const Text("Yes"),
      onPressed: () {
        Navigator.pop(dialogContext, true);
        deleteUserAccount(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Delete account"),
      content: const Text("Are you sure you want to delete this account?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext childContext) {
        dialogContext = childContext;
        return alert;
      },
    );
  }

  Future deleteUserAccount(BuildContext context) async {
    try {
      showLoading();
      Map<String, dynamic> response = await apiService.deleteUserAccount(user);
      hideLoading();

      if (response['success'] != null && response['success']) {
        locator<HelperService>().logout();
        logoutUser();
        print(response.toString());
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          snackBarService.showSnackBarWithString(
            response['message'] ?? 'Unable to delete account!',
          ),
        );
      }
    } catch (e) {
      hideLoading();
      ScaffoldMessenger.of(context).showSnackBar(
        snackBarService.showSnackBarWithString(
          'Unable to delete account...',
        ),
      );
    }
  }

  void logoutUser() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: ((context) => const LoginView()),
      ),
      (route) => false,
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
        title: const Text(
          "Privacy",
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
              fontFamily: 'Inter'),
        ),
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
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              shrinkWrap: true,
              children: <Widget>[
                SettingsItem(
                  onTap: () {},
                  icon: ImageAssets.settingIconPrivacy,
                  text: "Read privacy statement",
                ),
                SettingsItem(
                  onTap: () {
                    showAlertDialog(context);
                  },
                  icon: ImageAssets.icDeleteAccount,
                  text: "Delete account",
                ),
              ],
            ),
    );
  }
}
