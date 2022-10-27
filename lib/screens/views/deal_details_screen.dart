import 'package:flutter/material.dart';
import 'package:lix/app/color_select.dart';
import 'package:lix/app/image_assets.dart';
import 'package:lix/locator.dart';
import 'package:lix/models/country_phone_model.dart';
import 'package:lix/models/deal_coupon_model.dart';
import 'package:lix/models/market_offer_model.dart';
import 'package:lix/models/user.dart';
import 'package:intl/intl.dart';
import 'package:lix/models/wallet_details.dart';
import 'package:lix/screens/views/bottom_tabs/home_screen_styles.dart';
import 'package:lix/screens/widgets/ExpandableItem.dart';
import 'package:lix/screens/widgets/expandable_card.dart';
import 'package:lix/screens/widgets/purchase_coupondialog.dart';
import 'package:lix/screens/widgets/radio_tile.dart';
import 'package:lix/screens/widgets/submit_button.dart';
import 'package:lix/services/api.dart';
import 'package:lix/services/snackbar.dart';

import '../../services/helper.dart';

class DealDetailsScreen extends StatefulWidget {
  final MarketOffer? marketOffer;

  const DealDetailsScreen({Key? key, required this.marketOffer})
      : super(key: key);

  @override
  State<DealDetailsScreen> createState() => _DealDetailsScreenState();
}

class _DealDetailsScreenState extends State<DealDetailsScreen> {
  MarketOffer? marketOffer;
  APIService apiService = locator<APIService>();
  SnackBarService snackBarService = locator<SnackBarService>();
  late User user = locator<HelperService>().getCurrentUser()!;
  List<WalletDetails> wallets = [];
  WalletDetails? lixWallet;
  bool loading = false;
  String selectedCountry = "";
  List<CountryPhone> countries = [];
  final List<DealCouponModel> couponOffers = [
    DealCouponModel(
      title: "Get 10% discount on new collection items",
      checked: true,
      couponAmount: "20 LIX",
      reducedAmount: "20 LIX",
      hasOffer: false,
    ),
    DealCouponModel(
      title: "Get 20% discount on winter collection",
      checked: false,
      couponAmount: "40 LIX",
      reducedAmount: "20 LIX",
      hasOffer: true,
    ),
    DealCouponModel(
      title: "Buy one get one half price",
      checked: false,
      couponAmount: "20 LIX",
      reducedAmount: "20 LIX",
      hasOffer: false,
    ),
  ];

  ImageProvider provideLogoImage(MarketOffer? offer) {
    if (offer?.organisation?.avatar != null) {
      return NetworkImage(
        APIService().imagesPath + (offer?.organisation?.avatar ?? ''),
      );
    }
    return const AssetImage("assets/icons/ic_brand_1.png");
  }

  ImageProvider provideDealImage(MarketOffer? offer) {
    if (offer?.offerImage != null &&
        (offer?.offerImage ?? '').contains('http')) {
      return NetworkImage(
        offer?.offerImage! ?? '',
      );
    }
    return const AssetImage("assets/images/ic_home_2.png");
  }

  @override
  void initState() {
    if (widget.marketOffer != null) {
      marketOffer = widget.marketOffer;
      initialize();
    }
    super.initState();
  }

  initialize() async {
    try {
      List<WalletDetails> allWallets = await apiService.getUserBalance(user);
      List<CountryPhone> allCountries = await apiService.getAllPhoneCountries();

      if (allWallets.isNotEmpty) {
        setState(() {
          wallets = allWallets;
          countries = allCountries;
          lixWallet = allWallets.singleWhere(
            (e) => e.customCurrencyId == 2,
          );
        });
      }

      final split = marketOffer?.supportedCountries.toString().split(',');
      String country = "";
      for (int i = 0; i < split!.length; i++) {
        var countryObj = allCountries
            .where((element) => element.id.toString() == split[i])
            .first;
        if (i == 0) {
          country = (countryObj.name ?? '');
        } else {
          country = "$country, ${countryObj.name ?? ''}";
        }
      }
      setState(() {
        selectedCountry = country;
      });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 215,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: provideDealImage(marketOffer),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: 16.0,
                    bottom: 130.0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      height: 42,
                      width: 42,
                      child: IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(
                          Icons.close,
                          size: 24,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 10.0,
                    bottom: 10.0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4.0),
                      child: Image(
                          height: 50,
                          width: 50,
                          image: provideLogoImage(marketOffer),
                          fit: BoxFit.cover),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    marketOffer?.organisation?.name ?? '',
                    style: textStyleMediumBlack(20),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    marketOffer?.benefit,
                    style: customFontRegular(14, ColorSelect.lightBlack),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.fromLTRB(16, 0, 12, 0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: ColorSelect.appThemeGrey,
                    ),
                    child: ExpandableCard(
                        title: "Current balance",
                        childTitle: "10 LIX",
                        subtitle:
                            "${NumberFormat("###,###", "en_US").format(int.parse(lixWallet?.balance ?? '0'))} LIX",
                        leadingIcon: ImageAssets.dollarFilled),
                  ),
                  const SizedBox(height: 20),
                  // ListView.builder(
                  //     padding: const EdgeInsets.only(top: 0.0),
                  //     scrollDirection: Axis.vertical,
                  //     shrinkWrap: true,
                  //     physics: const NeverScrollableScrollPhysics(),
                  //     itemCount: couponOffers.length,
                  //     itemBuilder: (context, index) {
                  //       return RadioTile(
                  //           onTap: () {}, listItem: couponOffers[index]);
                  //     }),
                  ExpandableItem(
                    title: "About this deal",
                    childTitle: marketOffer?.instructions ?? '',
                  ),
                  Container(
                      height: 1,
                      width: MediaQuery.of(context).size.width,
                      color: ColorSelect.appThemeGrey),
                  // ExpandableItem(
                  //   title: "How to use",
                  //   childTitle: marketOffer?.instructions ?? '',
                  // ),
                  Container(
                      height: 1,
                      width: MediaQuery.of(context).size.width,
                      color: ColorSelect.appThemeGrey),
                  if (selectedCountry != "")
                    ExpandableItem(
                      title: "Locations",
                      childTitle: selectedCountry,
                    ),
                  Container(
                      height: 1,
                      width: MediaQuery.of(context).size.width,
                      color: ColorSelect.appThemeGrey),
                  // ExpandableItem(
                  //   title: "Terms & conditions",
                  //   childTitle: "Lorem ipsum is simply dummy text.",
                  // ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        margin: const EdgeInsets.only(left: 16, right: 16),
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
        child: SubmitButton(
          onTap: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const PurchaseCouponDialog(
                    title: "Watchbox coupon",
                  );
                });
          },
          text: "Buy Coupon",
          disabled: false,
          color: Colors.black,
        ),
      ),
    );
  }
}
