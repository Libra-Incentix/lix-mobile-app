import 'package:flutter/material.dart';
import 'package:lix/screens/views/bottom_tabs/home_screen_styles.dart';
import 'package:lix/screens/views/earn_details_screen.dart';

class EarnScreen extends StatefulWidget {
  const EarnScreen({Key? key}) : super(key: key);

  @override
  State<EarnScreen> createState() => _EarnScreenState();
}

class _EarnScreenState extends State<EarnScreen> {
  final titles = [
    "Share offer and earn 20 LIX",
    "Complete your profile and get 30 LIX",
    "Download & register with Bloomingdales app and get 50 LIX",
    "Upload you profile image and get 5 LIX",
    "Redeem a coupon and get 5 LIX",
    "Rate us 5 stars at app store and earn free 2 coupons plus 5 LIX"
  ];
  final subtitles = ["20 LIX", "30 LIX", "50 LIX", "5 LIX", "5LIX", "5LIX"];
  final icons = [
    "assets/icons/earn_1.png",
    "assets/icons/earn_2.png",
    "assets/icons/earn_3.png",
    "assets/icons/earn_4.png",
    "assets/icons/earn_5.png",
    "assets/icons/earn_1.png"
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Earn",
          style: textStyleBoldBlack(16),
        ),
      ),
      body: ListView.builder(
        itemCount: titles.length,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EarnDetailsScreen(code: '0'),
                ),
              );
            },
            title: Padding(
              padding: const EdgeInsets.only(bottom: 3.0),
              child: Text(
                titles[index],
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                  fontFamily: 'Inter',
                ),
              ),
            ),
            subtitle: Text(
              subtitles[index],
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color.fromRGBO(210, 114, 84, 1),
                fontFamily: 'Inter',
              ),
            ),
            leading: Image(
              image: AssetImage(icons[index]),
              fit: BoxFit.fitHeight,
              height: 50,
              width: 50,
            ),
          );
        },
      ),
    );
  }
}
