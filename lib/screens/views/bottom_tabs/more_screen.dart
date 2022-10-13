import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lix/app/color_select.dart';
import 'package:lix/locator.dart';
import 'package:intl/intl.dart';
import 'package:lix/models/custom_exception.dart';
import 'package:lix/models/user.dart';
import 'package:lix/models/wallet_details.dart';
import 'package:lix/screens/views/bottom_tabs/home_screen_styles.dart';
import 'package:lix/screens/views/dashboard.dart';
import 'package:lix/screens/views/my_coupons_view.dart';
import 'package:lix/screens/views/my_profile_view.dart';
import 'package:lix/screens/views/my_trans_screen.dart';
import 'package:lix/screens/views/settings_screen.dart';
import 'package:lix/screens/widgets/settings_item.dart';
import 'package:lix/services/api.dart';
import 'package:lix/services/helper.dart';
import 'package:collection/collection.dart';
import 'package:url_launcher/url_launcher.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({Key? key}) : super(key: key);

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  APIService apiService = locator<APIService>();
  HelperService helperService = locator<HelperService>();
  late User user = locator<HelperService>().getCurrentUser()!;
  List<WalletDetails> wallets = [];
  WalletDetails? lixWallet;
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
      List<WalletDetails> allWallets = await apiService.getUserBalance(user);
      if (allWallets.isNotEmpty) {
        setState(() {
          wallets = allWallets;
          lixWallet = allWallets.singleWhereOrNull(
            (e) => e.customCurrencyId == 2,
          );
        });
      }
      hideLoading();
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: loading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: 215,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/intro_bg.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            user.name ?? '',
                            style: textStyleRegular(16),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "${NumberFormat("###,###", "en_US").format(int.parse(lixWallet?.balance ?? '0'))} LIX",
                            style: textStyleMedium(24),
                          ),
                          const SizedBox(height: 14),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const MyTransScreen(),
                                    ),
                                  );
                                },
                                child: Text(
                                  "    View transactions history",
                                  style: textStyleViewAll(13),
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.keyboard_arrow_right,
                                color: ColorSelect.appThemeOrange,
                                size: 24.0,
                              ),
                            ],
                          ),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                    ListView(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: <Widget>[
                        SettingsItem(
                          onTap: openFundWallet,
                          icon: "assets/icons/ic_fund_wallet.png",
                          text: "Fund wallet",
                        ),
                        SettingsItem(
                          onTap: openFundWalletTransfer,
                          icon: "assets/icons/ic_transfer_fund.png",
                          text: "Transfer Fund",
                        ),
                        SettingsItem(
                          onTap: openFundWalletWithdraw,
                          icon: "assets/icons/ic_withdraw.png",
                          text: "Withdraw Fund",
                        ),
                        Container(
                          color: ColorSelect.appThemeGrey,
                          padding: const EdgeInsets.fromLTRB(16, 16, 0, 8),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Additional",
                            style: textStyleRegularBlack(12),
                          ),
                        ),
                        SettingsItem(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MyCouponsView(),
                              ),
                            );
                          },
                          icon: "assets/icons/ic_coupons.png",
                          text: "My Coupons",
                        ),
                        SettingsItem(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MyProfileView(),
                              ),
                            );
                          },
                          icon: "assets/icons/ic_my_profile.png",
                          text: "My Profile",
                        ),
                        SettingsItem(
                          onTap: redirectToHome,
                          icon: "assets/icons/ic_market.png",
                          text: "Marketplace",
                        ),
                        SettingsItem(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SettingsScreen(),
                              ),
                            );
                          },
                          icon: "assets/icons/ic_settings.png",
                          text: "Settings",
                        ),
                      ],
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  openFundWalletWithdraw() async {
    try {
      showLoading();
      String link = await apiService.getWalletFundsWithdrawLink(
        user,
        lixWallet!.id!,
      );
      hideLoading();
      if ((link.contains('http://') || link.contains('https://'))) {
        Uri url = Uri.parse(link);
        if (await canLaunchUrl(url)) {
          await launchUrl(url);
        }
      }
    } on CustomException catch (e) {
      log('$e');
      hideLoading();
    } catch (e) {
      log('$e');
      hideLoading();
    }
  }

  openFundWalletTransfer() async {
    try {
      showLoading();
      String link = await apiService.getWalletFundsTransferLink(
        user,
        lixWallet!.id!,
      );

      hideLoading();
      if ((link.contains('http://') || link.contains('https://'))) {
        Uri url = Uri.parse(link);
        if (await canLaunchUrl(url)) {
          await launchUrl(url);
        }
      }
    } on CustomException catch (e) {
      log('$e');
      hideLoading();
    } catch (e) {
      log('$e');
      hideLoading();
    }
  }

  openFundWallet() async {
    try {
      showLoading();
      String link = await apiService.getWalletFundsLink(
        user,
        lixWallet!.id!,
      );
      hideLoading();
      if ((link.contains('http://') || link.contains('https://'))) {
        Uri url = Uri.parse(link);
        if (await canLaunchUrl(url)) {
          await launchUrl(url);
        }
      }
    } on CustomException catch (e) {
      log('$e');
      hideLoading();
    } catch (e) {
      log('$e');
      hideLoading();
    }
  }

  void redirectToHome() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) {
          return const Dashboard();
        },
      ),
    );
  }
}
