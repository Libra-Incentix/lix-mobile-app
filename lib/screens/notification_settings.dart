import 'dart:developer' as devtools show log;

import 'package:flutter/material.dart';
import 'package:lix/app/color_select.dart';
import 'package:lix/locator.dart';
import 'package:lix/models/custom_exception.dart';
import 'package:lix/models/user.dart';
import 'package:lix/screens/views/bottom_tabs/home_screen_styles.dart';
import 'dart:io' show Platform;

import 'package:lix/services/api.dart';
import 'package:lix/services/helper.dart';
import 'package:lix/services/snackbar.dart';

class NotificationSettings extends StatefulWidget {
  const NotificationSettings({Key? key}) : super(key: key);

  @override
  State<NotificationSettings> createState() => _NotificationSettingsState();
}

class _NotificationSettingsState extends State<NotificationSettings> {
  APIService apiService = locator<APIService>();
  HelperService helperService = locator<HelperService>();
  late User user = locator<HelperService>().getCurrentUser()!;
  bool emailEnabled = true;
  bool pushEnabled = true;
  bool smsEnabled = true;

  void toggleSwitch(String type, bool value) {
    switch (type) {
      case 'email':
        setState(() {
          emailEnabled = value;
        });
        updateSwitchValue(type, emailEnabled);
        break;
      case 'push':
        setState(() {
          pushEnabled = value;
        });
        updateSwitchValue(type, pushEnabled);
        break;
      case 'sms':
        setState(() {
          smsEnabled = value;
        });
        updateSwitchValue(type, smsEnabled);
        break;
      default:
        break;
    }
  }

  updateSwitchValue(String type, bool enabled) async {
    int action = enabled ? 1 : 0;
    try {
      await apiService.enableDisableNotifications(
        user,
        type,
        action,
      );
    } on CustomException catch (e) {
      devtools.log('$e');
      ScaffoldMessenger.of(context).showSnackBar(
        locator<SnackBarService>().showSnackBarWithString(
          e.message,
        ),
      );
    } catch (e) {
      devtools.log('$e');
    }
  }

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
                topRight: Radius.circular(25),
              ),
              color: Colors.white,
            ),
          ),
          elevation: 0,
          title: Text(
            "Notifications",
            style: textStyleBoldBlack(16),
          ),
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
              child: Text(
                "Get daily information",
                style: customFontRegular(
                  13,
                  ColorSelect.greyDark,
                ),
              ),
            ),
            trailing: Switch(
              onChanged: (bool value) => toggleSwitch('email', value),
              value: emailEnabled,
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
              child: Text(
                "Get update on the latest deals",
                style: customFontRegular(
                  13,
                  ColorSelect.greyDark,
                ),
              ),
            ),
            trailing: Switch(
              onChanged: (bool value) => toggleSwitch('push', value),
              value: pushEnabled,
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
                "SMS notification",
                style: textStyleBoldBlack(15),
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                "Get update via SMS",
                style: customFontRegular(
                  13,
                  ColorSelect.greyDark,
                ),
              ),
            ),
            trailing: Switch(
              onChanged: (bool value) => toggleSwitch('sms', value),
              value: smsEnabled,
              activeColor: Colors.white,
              activeTrackColor: Colors.black,
              inactiveThumbColor: Colors.white,
              inactiveTrackColor: ColorSelect.buttonGrey,
            ),
          ),
        ],
      ),
    );
  }
}
