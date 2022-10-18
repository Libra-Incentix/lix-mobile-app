import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lix/app/image_assets.dart';
import 'package:lix/locator.dart';
import 'package:lix/screens/notification_settings.dart';
import 'package:lix/screens/views/login_view.dart';
import 'package:lix/screens/views/privacy_settings_screen.dart';
import 'package:lix/screens/widgets/settings_item.dart';
import 'package:lix/services/helper.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Settings",
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
      body: ListView(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        shrinkWrap: true,
        children: <Widget>[
          SettingsItem(
            onTap: () {
              Navigator.of(context).push(
                CupertinoPageRoute(
                  fullscreenDialog: true,
                  builder: (context) => const NotificationSettings(),
                ),
              );
            },
            icon: ImageAssets.settingIconBell,
            text: "Notifications",
          ),
          // SettingsItem(
          //   onTap: () {},
          //   icon: ImageAssets.settingIconLocation,
          //   text: "Location",
          // ),
          SettingsItem(
            onTap: () {},
            icon: ImageAssets.settingIconTerms,
            text: "Terms & conditions",
          ),
          SettingsItem(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PrivacySettingsScreen(),
                ),
              );
            },
            icon: ImageAssets.settingIconPrivacy,
            text: "Privacy",
          ),
          SettingsItem(
            onTap: () {
              locator<HelperService>().logout();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: ((context) => const LoginView()),
                ),
                (route) => false,
              );
            },
            icon: ImageAssets.settingIconLogout,
            text: "Logout",
          ),
        ],
      ),
    );
  }
}
