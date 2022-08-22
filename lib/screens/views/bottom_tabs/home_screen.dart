import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lix/app/image_assets.dart';
import 'package:lix/screens/views/bottom_tabs/home_screen_styles.dart';
import 'package:lix/screens/views/earn_details_screen.dart';
import 'package:lix/screens/views/notifications_view.dart';
import 'package:lix/screens/widgets/earn_with_lix.dart';
import 'package:lix/screens/widgets/exclusive_deals.dart';
import 'package:lix/screens/widgets/recommended_deals.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var productList = [
    {"name": "Nike.com", "picture": "assets/images/nike_img.png", "price": 99},
    {
      "name": "Bobbi Brown",
      "picture": "assets/images/bobbi_img.png",
      "price": 99
    },
    {
      "name": "Blooming Dales",
      "picture": "assets/images/nike_img.png",
      "price": 99
    },
    {"name": "Watchbox", "picture": "assets/images/bobbi_img.png", "price": 99}
  ];
  var dealsList = [
    {
      "name": "Watchbox",
      "picture": "assets/images/ic_home_1.png",
      "logo": "assets/icons/ic_brand_1.png",
      "desc": "Superior Watchmaking Service"
    },
    {
      "name": "Bloomingdales",
      "picture": "assets/images/ic_home_2.png",
      "logo": "assets/icons/ic_brand_2.png",
      "desc": "Get the latest offers of Bloomingdales"
    },
  ];
  final earningList = [
    {
      "name": "Share offer and earn 20 LIX",
      "reward": "20 LIX",
      "picture": "assets/icons/earn_1.png"
    },
    {
      "name": "Complete your profile and get 30 LIX",
      "reward": "20 LIX",
      "picture": "assets/icons/earn_2.png"
    }
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                CupertinoPageRoute(
                  fullscreenDialog: true,
                  builder: (context) => const NotificationsView(),
                ),
              );
            },
            icon: Image.asset(
              ImageAssets.notificationBell,
              height: 20,
              width: 20,
            ),
          ),
        ],
        centerTitle: true,
        title: const Text(
          "Earn & redeem points",
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
              fontFamily: 'Inter'),
        ),
      ),
      body: ListView(
        children: [
          // Top container with qr code image and scan button
          Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            height: 140,
            decoration: BoxDecoration(
                image: const DecorationImage(
                    image: AssetImage("assets/images/app_bg_home.png"),
                    fit: BoxFit.fitWidth),
                borderRadius: BorderRadius.circular(6)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  width: 96,
                  height: 120,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/qr_phone.png"),
                        fit: BoxFit.fill),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Scan & Earn', style: textStyleMedium(20)),
                    const SizedBox(height: 4),
                    Text(
                      'Scan barcode to claim rewards',
                      style: textStyleRegular(12),
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                          alignment: Alignment.center,
                          height: 36,
                          width: 144,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Colors.white, width: 1),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Image(
                                  height: 12,
                                  width: 12,
                                  image: AssetImage(
                                      "assets/icons/qr_button_left.png")),
                              const SizedBox(width: 8),
                              Text('Scan now', style: buttonTextBold()),
                            ],
                          )),
                    )
                  ],
                ),
              ],
            ),
          ),

          // ----------Show Exclusive Details---------- //
          ExclusiveDeals(onTap: () {}, productsList: productList),
          RecommendedDeals(
              onTap: () {}, productsList: dealsList, viewAllOption: true),
          EarnWithLix(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const EarnDetailsScreen()),
                );
              },
              productsList: earningList)
        ],
      ),
    );
  }
}
