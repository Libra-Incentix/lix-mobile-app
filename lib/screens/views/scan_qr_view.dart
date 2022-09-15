import 'package:flutter/material.dart';
import 'package:lix/app/image_assets.dart';
import 'package:lix/screens/views/bottom_tabs/home_screen_styles.dart';
import 'package:lix/screens/views/earn_details_screen.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanQrView extends StatefulWidget {
  const ScanQrView({Key? key}) : super(key: key);

  @override
  State<ScanQrView> createState() => _ScanQrViewState();
}

class _ScanQrViewState extends State<ScanQrView> {
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text("My Coupons", style: textStyleBoldBlack(16)),
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
      body: MobileScanner(
        allowDuplicates: false,
        controller: MobileScannerController(
          facing: CameraFacing.back,
          torchEnabled: true,
        ),
        onDetect: (barcode, args) {
          if (barcode.rawValue == null) {
            debugPrint('Failed to scan Barcode');
          } else {
            final String url =
                barcode.rawValue != null ? barcode.rawValue! : '';
            debugPrint('Barcode found! $url');
            if (url.isNotEmpty) {
              // code is not empty, extracting the id...
              String code = url.split('/get/').last;
              debugPrint('Barcode found! $code');
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => EarnDetailsScreen(
                    code: code,
                  ),
                ),
              );
            }
          }
        },
      ),
    );
  }
}
