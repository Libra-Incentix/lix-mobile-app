import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lix/app/color_select.dart';
import 'package:lix/screens/views/bottom_tabs/home_screen_styles.dart';
import 'package:lix/screens/views/my_coupons_view.dart';
import 'package:lix/screens/views/my_profile_view.dart';
import 'package:lix/screens/views/my_trans_screen.dart';
import 'package:lix/screens/views/settings_screen.dart';
import 'package:lix/screens/widgets/settings_item.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({Key? key}) : super(key: key);

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: SingleChildScrollView(
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
                        "Andrew's balance",
                        style: textStyleRegular(16),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "40 LIX",
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
                                        const MyTransScreen()),
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
                      onTap: () {},
                      icon: "assets/icons/ic_fund_wallet.png",
                      text: "Fund wallet",
                    ),
                    SettingsItem(
                      onTap: () {},
                      icon: "assets/icons/ic_transfer_fund.png",
                      text: "Transfer Fund",
                    ),
                    SettingsItem(
                      onTap: () {},
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
                              builder: (context) => const MyCouponsView()),
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
                              builder: (context) => const MyProfileView()),
                        );
                      },
                      icon: "assets/icons/ic_my_profile.png",
                      text: "My Profile",
                    ),
                    SettingsItem(
                      onTap: () {},
                      icon: "assets/icons/ic_market.png",
                      text: "Marketplace",
                    ),
                    SettingsItem(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SettingsScreen()),
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
        ));
  }
}
