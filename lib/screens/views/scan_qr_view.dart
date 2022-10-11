// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lix/app/image_assets.dart';
import 'package:lix/locator.dart';
import 'package:lix/models/offer_model.dart';
import 'package:lix/models/task_link.dart';
import 'package:lix/models/user.dart';
import 'package:lix/screens/views/bottom_tabs/home_screen_styles.dart';
import 'package:lix/screens/views/earn_details_screen.dart';
import 'package:lix/services/api.dart';
import 'package:lix/services/helper.dart';
import 'package:lix/services/snackbar.dart';

class ScanQrView extends StatefulWidget {
  const ScanQrView({Key? key}) : super(key: key);

  @override
  State<ScanQrView> createState() => _ScanQrViewState();
}

class _ScanQrViewState extends State<ScanQrView> {
  APIService apiService = locator<APIService>();
  HelperService helperService = locator<HelperService>();
  User user = locator<HelperService>().getCurrentUser()!;
  SnackBarService snackBarService = locator<SnackBarService>();
  ScanResult? scanResult;

  @override
  void initState() {
    Timer(
      const Duration(seconds: 1),
      _scan,
    );
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
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "",
          style: textStyleBoldBlack(16),
        ),
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
      ),
    );
  }

  Future<void> _scan() async {
    try {
      final result = await BarcodeScanner.scan(
        options: const ScanOptions(
          strings: {
            'cancel': 'Cancel',
            'flash_on': 'Flash On',
            'flash_off': 'Flash Off',
          },
          autoEnableFlash: false,
          android: AndroidOptions(
            useAutoFocus: true,
          ),
        ),
      );
      setState(() => scanResult = result);

      if (scanResult!.rawContent.contains('http')) {
        // getting offer data...
        dynamic result = await apiService.verifyQRCodeLink(
          scanResult!.rawContent,
          user,
        );
        if (result['success'] != null && result['success']) {
          if (result['data'] != null &&
              result['data']['link_type'] != null &&
              result['data']['link_type'] == 'task') {
            TaskLinkModel tlModel = TaskLinkModel.fromJson(
              result['data']['link'],
            );

            tlModel.fullLink = scanResult!.rawContent;
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => EarnDetailsScreen(
                  taskLink: tlModel,
                  offerModel: null,
                ),
              ),
            );
          } else {
            // this is for link type offer
            if (result['data'] != null &&
                result['data']['link_type'] != null &&
                result['data']['link_type'] == 'offer') {
              OfferModel offerModel = OfferModel.fromJson(
                result['data']['offer'],
              );
              offerModel.fullLink = scanResult!.rawContent;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => EarnDetailsScreen(
                    offerModel: offerModel,
                    taskLink: null,
                  ),
                ),
              );
            }
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            snackBarService.showSnackBarWithString(result['message'] ?? ''),
          );
          Navigator.pop(context);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          snackBarService.showSnackBarWithString(
            'Invalid code, please try again.',
            type: SnackBarType.error,
          ),
        );
        Navigator.pop(context);
      }
    } on PlatformException catch (e) {
      setState(() {
        scanResult = ScanResult(
          type: ResultType.Error,
          format: BarcodeFormat.unknown,
          rawContent: e.code == BarcodeScanner.cameraAccessDenied
              ? 'The user did not grant the camera permission!'
              : 'Unknown error: $e',
        );
      });
      Navigator.pop(context);
    }
  }
}
