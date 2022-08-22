import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lix/app/color_select.dart';
import 'package:lix/app/image_assets.dart';
import 'package:lix/models/notification_model.dart';
import 'package:lix/screens/views/bottom_tabs/home_screen_styles.dart';

class NotificationsView extends StatefulWidget {
  const NotificationsView({Key? key}) : super(key: key);

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  final List<NotificationModel> _notifications = [
    NotificationModel(
        title: "20 LIXX credit to your wallet",
        desc: "Congrats! you have recieved 20 LIXX to your wallet",
        imgPath: "assets/icons/ic_notlist_1.png",
        read: false),
    NotificationModel(
        title: "New! Klarna deals",
        desc: "Check the latest deals added by Klarna",
        imgPath: "assets/icons/ic_notlist_2.png",
        read: true),
    NotificationModel(
        title: "Transfer successfully",
        desc: "You successfully transfer 10 LIX to Dave",
        imgPath: "assets/icons/ic_notlist_3.png",
        read: true),
    NotificationModel(
        title: "Welcome to LIX",
        desc: "We are delighted to have you around as customer",
        imgPath: "assets/icons/ic_notlist_4.png",
        read: true),
  ];
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
            title: Text("My Notification", style: textStyleBoldBlack(16)),
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
        body: ListView.builder(
            itemCount: _notifications.length,
            itemBuilder: (context, index) {
              return ListTile(
                tileColor: _notifications[index].read
                    ? Colors.white
                    : ColorSelect.appThemeGrey,
                title: Padding(
                  padding: const EdgeInsets.only(top: 10, left: 0, bottom: 4),
                  child: Text(
                    _notifications[index].title,
                    style: textStyleBoldBlack(15),
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(_notifications[index].desc,
                      style: customFontRegular(13, ColorSelect.greyDark)),
                ),
                leading: Image(
                  image: AssetImage(_notifications[index].imgPath),
                  fit: BoxFit.fitHeight,
                  height: 36,
                  width: 36,
                ),
              );
            }));
  }
}
