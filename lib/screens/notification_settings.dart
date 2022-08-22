import 'package:flutter/material.dart';
import 'package:lix/app/color_select.dart';
import 'package:lix/screens/views/bottom_tabs/home_screen_styles.dart';
import 'dart:io' show Platform;

class NotificationSettings extends StatefulWidget {
  const NotificationSettings({Key? key}) : super(key: key);

  @override
  State<NotificationSettings> createState() => _NotificationSettingsState();
}

class _NotificationSettingsState extends State<NotificationSettings> {
  void toggleSwitch(bool value) {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: AppBar(
          centerTitle: true,
          backgroundColor: Colors.black26,
          flexibleSpace: Container(
            margin: EdgeInsets.only(top: Platform.isIOS ? 40 : 0),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25)),
                color: Colors.white),
          ),
          elevation: 0,
          title: Text("Notifications", style: textStyleBoldBlack(16)),
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.close,
                  size: 24,
                  color: Colors.black,
                ),
              );
            },
          ),
        ),
      ),
      body: Column(
        children: [
          ListTile(
            dense: true,
            contentPadding: const EdgeInsets.fromLTRB(20, 0, 16, 0),
            title: Padding(
              padding: const EdgeInsets.only(top: 0, left: 0, bottom: 4),
              child: Text(
                "Email",
                style: textStyleBoldBlack(15),
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text("Get daily information",
                  style: customFontRegular(13, ColorSelect.greyDark)),
            ),
            trailing: Switch(
              onChanged: toggleSwitch,
              value: true,
              activeColor: Colors.white,
              activeTrackColor: Colors.black,
              inactiveThumbColor: Colors.white,
              inactiveTrackColor: ColorSelect.buttonGrey,
            ),
          ),
          ListTile(
              dense: true,
              contentPadding: const EdgeInsets.fromLTRB(20, 0, 16, 0),
              title: Padding(
                padding: const EdgeInsets.only(top: 0, left: 0, bottom: 4),
                child: Text(
                  "Push notification",
                  style: textStyleBoldBlack(15),
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text("Get update on the latest deals",
                    style: customFontRegular(13, ColorSelect.greyDark)),
              ),
              trailing: Switch(
                onChanged: toggleSwitch,
                value: false,
                activeColor: Colors.white,
                activeTrackColor: Colors.black,
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: ColorSelect.buttonGrey,
              ))
        ],
      ),
    );
  }
}
