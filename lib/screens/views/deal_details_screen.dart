import 'package:flutter/material.dart';
import 'package:lix/app/color_select.dart';
import 'package:lix/app/image_assets.dart';
import 'package:lix/models/deal_coupon_model.dart';
import 'package:lix/screens/views/bottom_tabs/home_screen_styles.dart';
import 'package:lix/screens/widgets/ExpandableItem.dart';
import 'package:lix/screens/widgets/expandable_card.dart';
import 'package:lix/screens/widgets/purchase_coupondialog.dart';
import 'package:lix/screens/widgets/radio_tile.dart';
import 'package:lix/screens/widgets/submit_button.dart';

class DealDetailsScreen extends StatefulWidget {
  const DealDetailsScreen({Key? key}) : super(key: key);

  @override
  State<DealDetailsScreen> createState() => _DealDetailsScreenState();
}

class _DealDetailsScreenState extends State<DealDetailsScreen> {
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
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/ic_home_1.png"),
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
                      child: const Image(
                          height: 50,
                          width: 50,
                          image: AssetImage("assets/icons/ic_brand_1.png"),
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
                    "Watchbox",
                    style: textStyleMediumBlack(20),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Claim the latest offers of Watchbox",
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
                        childTitle: "40 LIX",
                        subtitle: "40 LIX",
                        leadingIcon: ImageAssets.dollarFilled),
                  ),
                  const SizedBox(height: 20),
                  ListView.builder(
                      padding: const EdgeInsets.only(top: 0.0),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: couponOffers.length,
                      itemBuilder: (context, index) {
                        return RadioTile(
                            onTap: () {}, listItem: couponOffers[index]);
                      }),
                  ExpandableItem(
                    title: "About this deal",
                    childTitle:
                        "Morbi tincidunt lectus non sagittis tincidunt nulla nec metus at nunc dignissim placerat.",
                  ),
                  Container(
                      height: 1,
                      width: MediaQuery.of(context).size.width,
                      color: ColorSelect.appThemeGrey),
                  ExpandableItem(
                    title: "How to use",
                    childTitle: "Lorem ipsum is simply dummy text.",
                  ),
                  Container(
                      height: 1,
                      width: MediaQuery.of(context).size.width,
                      color: ColorSelect.appThemeGrey),
                  ExpandableItem(
                    title: "Locations",
                    childTitle: "Lorem ipsum is simply dummy text.",
                  ),
                  Container(
                      height: 1,
                      width: MediaQuery.of(context).size.width,
                      color: ColorSelect.appThemeGrey),
                  ExpandableItem(
                    title: "Terms & conditions",
                    childTitle: "Lorem ipsum is simply dummy text.",
                  ),
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
