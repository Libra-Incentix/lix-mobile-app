import 'dart:developer' as devtools show log;
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lix/app/color_select.dart';
import 'package:lix/locator.dart';
import 'package:lix/models/custom_exception.dart';
import 'package:lix/models/notification_model.dart';
import 'package:lix/models/user.dart';
import 'package:lix/screens/views/bottom_tabs/home_screen_styles.dart';
import 'package:lix/services/api.dart';
import 'package:lix/services/helper.dart';
import 'package:lix/services/snackbar.dart';

class NotificationsView extends StatefulWidget {
  const NotificationsView({Key? key}) : super(key: key);

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  APIService apiService = locator<APIService>();
  HelperService helperService = locator<HelperService>();
  SnackBarService snackBarService = locator<SnackBarService>();
  late User user = locator<HelperService>().getCurrentUser()!;
  bool loading = false;

  List<NotificationModel> _notifications = [];

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

  initialize() async {
    try {
      showLoading();
      List<NotificationModel> notifications =
          await apiService.getAllNotifications(user);
      if (notifications.isNotEmpty) {
        setState(() {
          _notifications = notifications;
          _notifications.sort((a, b) {
            if (a.createdAt != null && b.createdAt != null) {
              DateTime aDate = DateTime.parse(a.createdAt!);
              DateTime bDate = DateTime.parse(b.createdAt!);

              return bDate.compareTo(aDate);
            }

            return 1;
          });
        });
      }
      hideLoading();
    } on CustomException catch (e) {
      hideLoading();
      ScaffoldMessenger.of(context).showSnackBar(
        snackBarService.showSnackBarWithString(e.message),
      );
      devtools.log('$e');
    } catch (e) {
      devtools.log('$e');
      hideLoading();
    }
  }

  @override
  void initState() {
    initialize();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
            "My Notification",
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
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _notifications.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () => markNotificationAsRead(_notifications[index]),
                  leading: const Icon(
                    Icons.notifications,
                  ),
                  tileColor: _notifications[index].read!
                      ? Colors.white
                      : ColorSelect.appThemeGrey,
                  title: Padding(
                    padding: const EdgeInsets.only(
                      top: 10,
                      left: 0,
                      bottom: 4,
                    ),
                    child: Text(
                      _notifications[index].title ?? '',
                      style: textStyleBoldBlack(15),
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      _notifications[index].description ?? '',
                      style: customFontRegular(
                        13,
                        ColorSelect.greyDark,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  markNotificationAsRead(NotificationModel notification) async {
    // if not read then mark as read...
    if (!notification.read!) {
      try {
        showLoading();
        await apiService.markNotificationAsRead(user, notification.id!);
        // now update the notification itself.
        setState(() {
          for (var element in _notifications) {
            if (element.id! == notification.id!) {
              element.read = true;
              element.readStatus = 1;
            }
          }
        });
        hideLoading();
      } catch (e) {
        hideLoading();
        devtools.log('$e');
      }
    }
  }
}
