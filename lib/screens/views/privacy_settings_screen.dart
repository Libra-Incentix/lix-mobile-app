import 'package:flutter/material.dart';
import 'package:lix/app/image_assets.dart';
import 'package:lix/screens/widgets/settings_item.dart';

class PrivacySettingsScreen extends StatefulWidget {
  const PrivacySettingsScreen({Key? key}) : super(key: key);

  @override
  State<PrivacySettingsScreen> createState() => _PrivacySettingsScreenState();
}

class _PrivacySettingsScreenState extends State<PrivacySettingsScreen> {
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
      body: ListView(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        shrinkWrap: true,
        children: <Widget>[
          SettingsItem(
            onTap: () {},
            icon: ImageAssets.settingIconPrivacy,
            text: "Read privacy statement",
          ),
          SettingsItem(
            onTap: () {},
            icon: ImageAssets.icDeleteAccount,
            text: "Delete account",
          ),
        ],
      ),
    );
  }
}
