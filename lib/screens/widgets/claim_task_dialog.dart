import 'dart:async';
import 'dart:convert';
import 'dart:developer' as devtools show log;
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lix/app/color_select.dart';
import 'package:lix/app/image_assets.dart';
import 'package:lix/locator.dart';
import 'package:lix/models/custom_exception.dart';
import 'package:lix/models/task_model.dart';
import 'package:lix/models/user.dart';
import 'package:lix/screens/views/bottom_tabs/home_screen_styles.dart';
import 'package:lix/screens/widgets/submit_button.dart';
import 'package:lix/services/api.dart';
import 'package:lix/services/helper.dart';
import 'package:lix/services/snackbar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

class ClaimTaskDialog extends StatefulWidget {
  final TaskModel task;
  final String reward;
  final String fullLink;
  final String? qrImage;
  const ClaimTaskDialog({
    Key? key,
    required this.reward,
    required this.fullLink,
    required this.task,
    this.qrImage,
  }) : super(key: key);

  @override
  State<ClaimTaskDialog> createState() => _ClaimTaskDialogState();
}

class _ClaimTaskDialogState extends State<ClaimTaskDialog> {
  late TaskModel task = widget.task;
  late String reward = widget.reward;
  late User user = locator<HelperService>().getCurrentUser()!;
  HelperService helperService = locator<HelperService>();
  APIService apiService = locator<APIService>();
  SnackBarService snackBarService = locator<SnackBarService>();
  GlobalKey globalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0.0,
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.all(20),
      child: dialogContent(context),
    );
  }

  Widget dialogContent(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 0.0, right: 0.0),
      child: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(height: 40),
                Image.asset(
                  ImageAssets.greenCheckFill,
                  height: 36,
                  width: 36,
                ),
                const SizedBox(height: 8),
                Text(
                  "Congratulation!",
                  style: textStyleBoldBlack(24),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  "$reward LIX is credited to your wallet",
                  style: textStyleRegularBlack(14),
                  textAlign: TextAlign.center,
                ),
                Container(
                  color: ColorSelect.appThemeGrey,
                  margin: const EdgeInsets.all(24),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        "Earn extra 5 LIX",
                        style: textStyleMediumBlack(16),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      RichText(
                        textAlign: TextAlign.center,
                        text: const TextSpan(
                          style: TextStyle(
                            color: Color.fromARGB(255, 3, 3, 3),
                            fontSize: 14,
                            fontFamily: 'Intern',
                            height: 1.7,
                            fontWeight: FontWeight.w400,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text:
                                  'Share this task with your friends and earn extra',
                            ),
                            TextSpan(
                              text: ' 5 LIX',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: ColorSelect.appThemeOrange,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (widget.fullLink != 'null')
                        RepaintBoundary(
                          key: globalKey,
                          child: QrImage(
                            data: widget.fullLink,
                            size: 300,
                            backgroundColor: Colors.white,
                          ),
                        ),
                      if (widget.qrImage!.isNotEmpty &&
                          widget.qrImage! != 'null')
                        Image.memory(
                          const Base64Decoder().convert(widget.qrImage ?? ''),
                          height: 300,
                          width: 300,
                        ),
                      const SizedBox(height: 12),
                      SubmitButton(
                        onTap: saveAndShareQR,
                        text: "Share Now",
                        color: ColorSelect.lightBlack,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.close,
                size: 24,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  saveAndShareQR() async {
    if (widget.fullLink != 'null') {
      Timer(
        const Duration(seconds: 1),
        () async {
          try {
            dynamic boundary = globalKey.currentContext!.findRenderObject();
            var image = await boundary.toImage();
            ByteData byteData = await image.toByteData(
              format: ImageByteFormat.png,
            );
            Uint8List pngBytes = byteData.buffer.asUint8List();

            final tempDir = await getTemporaryDirectory();
            final file = await File('${tempDir.path}/image.png').create();
            await file.writeAsBytes(pngBytes);

            ShareResult result = await Share.shareFilesWithResult(
              ['${tempDir.path}/image.png'],
              subject: shareSubject(),
              text: shareDescription(),
            );

            if (result.status == ShareResultStatus.success) {
              creditSocialShareBonus();
            }
          } catch (e) {
            devtools.log(e.toString());
          }
        },
      );
    } else if (widget.qrImage != '') {
      Timer(
        const Duration(seconds: 1),
        () async {
          try {
            Uint8List byteData;
            byteData = const Base64Decoder().convert(widget.qrImage ?? '');
            Uint8List pngBytes = byteData.buffer.asUint8List();

            final tempDir = await getTemporaryDirectory();
            final file = await File('${tempDir.path}/image.png').create();
            await file.writeAsBytes(pngBytes);

            ShareResult result = await Share.shareFilesWithResult(
              ['${tempDir.path}/image.png'],
              subject: shareSubject(),
              text: shareDescription(),
            );

            if (result.status == ShareResultStatus.success) {
              creditSocialShareBonus();
            }
          } catch (e) {
            devtools.log(e.toString());
          }
        },
      );
    }
  }

  creditSocialShareBonus() async {
    try {
      // ok user shared coupon successfully.
      // credit 5 lix in user's account.
      String response = await apiService.creditSocialShareBonus(user);
      if (response.runtimeType == String) {
        // ignore: use_build_context_synchronously
        Navigator.pop(context, {
          "response": response,
          "type": "success",
        });
      }
    } on CustomException catch (e) {
      devtools.log('$e');
      // ignore: use_build_context_synchronously
      Navigator.pop(context, {
        "response": e.message,
        "type": "error",
      });
    } catch (e) {
      devtools.log('$e');
    }
  }

  String shareSubject() {
    return task.title ?? 'Coupon Claimed';
  }

  String shareDescription() {
    if (task.description != null) {
      return task.description ?? '';
    }
    return '';
  }
}
