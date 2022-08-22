import 'package:flutter/material.dart';
import 'package:lix/app/color_select.dart';
import 'package:lix/app/image_assets.dart';
import 'package:lix/models/coupon_model.dart';
import 'package:lix/screens/views/bottom_tabs/home_screen_styles.dart';
import 'package:lix/screens/widgets/purchase_coupondialog.dart';

class MyCouponsView extends StatefulWidget {
  const MyCouponsView({Key? key}) : super(key: key);

  @override
  State<MyCouponsView> createState() => _MyCouponsState();
}

class _MyCouponsState extends State<MyCouponsView> {
  final List<CouponModel> couponsUsed = [
    CouponModel(
      title: "Get 10% discount on new items",
      date: "Jul, 23 2022",
      imgPath: "assets/icons/ic_brand_1.png",
    ),
    CouponModel(
      title: "20% discount on selected items",
      date: "Jul, 23 2022",
      imgPath: "assets/icons/ic_notlist_2.png",
    ),
    CouponModel(
      title: "Buy one get one free",
      date: "Jul, 23 2022",
      imgPath: "assets/icons/ic_brand_3.png",
    ),
  ];

  final List<CouponModel> couponsActive = [
    CouponModel(
      title: "Get 10% discount on new items",
      date: "Jul, 23 2022",
      imgPath: "assets/icons/ic_brand_1.png",
    ),
    CouponModel(
      title: "20% discount on selected items",
      date: "Jul, 23 2022",
      imgPath: "assets/icons/ic_notlist_4.png",
    ),
    CouponModel(
      title: "Buy one get one free",
      date: "Jul, 23 2022",
      imgPath: "assets/icons/ic_brand_2.png",
    ),
  ];
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
        children: [
          Container(
            color: ColorSelect.appThemeGreyLight,
            padding: const EdgeInsets.fromLTRB(16, 16, 0, 8),
            alignment: Alignment.centerLeft,
            child: Text(
              "Active",
              style: textStyleRegularBlack(12),
            ),
          ),
          const SizedBox(height: 4),
          ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: couponsActive.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const PurchaseCouponDialog(
                            title: "Watchbox coupon",
                          );
                        });
                  },
                  tileColor: Colors.white,
                  title: Padding(
                    padding: const EdgeInsets.only(top: 10, left: 0, bottom: 4),
                    child: Text(
                      couponsActive[index].title,
                      style: textStyleBoldBlack(15),
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text("Expiry date : ${couponsActive[index].date}",
                        style: customFontRegular(13, ColorSelect.greyDark)),
                  ),
                  leading: Container(
                    height: 36,
                    width: 36,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage(couponsActive[index].imgPath)),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(8.0)),
                      border: Border.all(
                        color: ColorSelect.appThemeGrey,
                        width: 2,
                      ),
                    ),
                  ),
                );
              }),
          const SizedBox(height: 8),
          Container(
            color: ColorSelect.appThemeGreyLight,
            padding: const EdgeInsets.fromLTRB(16, 16, 0, 8),
            alignment: Alignment.centerLeft,
            child: Text(
              "Redeemed",
              style: textStyleRegularBlack(12),
            ),
          ),
          const SizedBox(height: 4),
          ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: couponsUsed.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const PurchaseCouponDialog(
                            title: "Watchbox coupon",
                          );
                        });
                  },
                  tileColor: Colors.white,
                  title: Padding(
                    padding: const EdgeInsets.only(top: 10, left: 0, bottom: 4),
                    child: Text(
                      couponsUsed[index].title,
                      style: textStyleBoldBlack(15),
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(couponsUsed[index].date,
                        style: customFontRegular(13, ColorSelect.greyDark)),
                  ),
                  leading: Container(
                    height: 36,
                    width: 36,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage(couponsUsed[index].imgPath)),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(8.0)),
                      border: Border.all(
                        color: ColorSelect.appThemeGrey,
                        width: 2,
                      ),
                    ),
                  ),
                );
              }),
        ],
      ),
    );
  }
}
