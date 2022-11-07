import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lix/app/color_select.dart';
import 'package:lix/app/image_assets.dart';
import 'package:lix/locator.dart';
import 'package:lix/models/coupon_model.dart';
import 'package:lix/models/custom_exception.dart';
import 'package:lix/models/user.dart';
import 'package:lix/screens/views/bottom_tabs/home_screen_styles.dart';
import 'package:lix/screens/widgets/purchase_coupondialog.dart';
import 'package:lix/services/api.dart';
import 'package:lix/services/helper.dart';
import 'package:lix/services/snackbar.dart';

class MyCouponsView extends StatefulWidget {
  const MyCouponsView({Key? key}) : super(key: key);

  @override
  State<MyCouponsView> createState() => _MyCouponsState();
}

class _MyCouponsState extends State<MyCouponsView> {
  late User user = locator<HelperService>().getCurrentUser()!;
  APIService apiService = locator<APIService>();
  HelperService helperService = locator<HelperService>();

  List<CouponModel> couponsUsed = [];
  List<CouponModel> couponsActive = [];
  List<CouponModel> allCoupons = [];
  bool loading = false;

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
      List<CouponModel> c = await apiService.getMyCoupons(user);
      hideLoading();
      setState(() {
        if (!mounted) return;
        allCoupons = c;
        couponsUsed = [...c]
            .where(
              (element) => element.isUsed == 1 && element.isActive == 0,
            )
            .toList();

        couponsActive = [...c]
            .where(
              (element) => element.isActive == 1 && element.isUsed == 0,
            )
            .toList();
      });
    } on CustomException catch (e) {
      hideLoading();
      ScaffoldMessenger.of(context).showSnackBar(
        locator<SnackBarService>().showSnackBarWithString(
          e.message,
        ),
      );
    } catch (e) {
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
                  image: AssetImage(ImageAssets.arrowBack),
                ),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            );
          },
        ),
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
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
                        onTap: () async {
                          dynamic response = await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return PurchaseCouponDialog(
                                coupon: couponsActive[index],
                              );
                            },
                          );

                          if (response != null &&
                              (response['response'] as String).isNotEmpty) {
                            SnackBarType type = response['type'] == 'error'
                                ? SnackBarType.error
                                : SnackBarType.success;

                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(
                              locator<SnackBarService>().showSnackBarWithString(
                                response['response'],
                                type: type,
                              ),
                            );
                          }
                        },
                        tileColor: Colors.white,
                        title: Padding(
                          padding: const EdgeInsets.only(
                              top: 10, left: 0, bottom: 4),
                          child: Text(
                            couponBenefits(couponsActive[index]),
                            style: textStyleBoldBlack(15),
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Text(
                            getCouponExpiryDate(couponsActive[index]),
                            style: customFontRegular(
                              13,
                              ColorSelect.greyDark,
                            ),
                          ),
                        ),
                        leading: Container(
                          height: 36,
                          width: 36,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: Image.network(
                                couponsActive[index].market!['offer_image'],
                                errorBuilder: (BuildContext context,
                                    Object exception, StackTrace? stackTrace) {
                                  debugPrint("onError B");

                                  return const Image(
                                    image:
                                        AssetImage('assets/images/no-img.png'),
                                  );
                                },
                              ).image,
                            ),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                            border: Border.all(
                              color: ColorSelect.appThemeGrey,
                              width: 2,
                            ),
                          ),
                        ),
                      );
                    }),
                allUsedCoupons(),
              ],
            ),
    );
  }

  Widget allUsedCoupons() {
    if (couponsUsed.isNotEmpty) {
      return Column(
        children: [
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
                onTap: () async {
                  await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return PurchaseCouponDialog(
                        coupon: couponsUsed[index],
                      );
                    },
                  ).then((e) => e ?? '');
                },
                tileColor: Colors.white,
                title: Padding(
                  padding: const EdgeInsets.only(top: 10, left: 0, bottom: 4),
                  child: Text(
                    couponBenefits(
                      couponsUsed[index],
                    ),
                    style: textStyleBoldBlack(15),
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    redeemedDate(couponsUsed[index]),
                    style: customFontRegular(13, ColorSelect.greyDark),
                  ),
                ),
                leading: Container(
                  height: 36,
                  width: 36,
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage('assets/images/no-img.png'),
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(8.0),
                    ),
                    border: Border.all(
                      color: ColorSelect.appThemeGrey,
                      width: 2,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      );
    }

    return Container();
  }

  String couponBenefits(CouponModel coupon) {
    if (coupon.description != null) {
      return coupon.description ?? '';
    }
    return '';
  }

  String couponExpiryDate(CouponModel coupon) {
    if (coupon.market != null) {
      if (coupon.market!['expires_at'] != null) {
        return DateFormat('d, MMM yyyy').format(
          DateTime.parse(coupon.market!['expires_at']),
        );
      }
      return '';
    }
    return '';
  }

  String redeemedDate(CouponModel coupon) {
    if (coupon.usedDate != null && coupon.usedDate!.isNotEmpty) {
      return DateFormat('d, MMM yyyy').format(
        DateTime.parse(coupon.usedDate!),
      );
    }
    return '';
  }

  getCouponExpiryDate(CouponModel coupon) {
    if (coupon.market != null && coupon.market!['expires_at'] != null) {
      return "Expiry date : ${couponExpiryDate(coupon)}";
    }
    return '';
  }
}
