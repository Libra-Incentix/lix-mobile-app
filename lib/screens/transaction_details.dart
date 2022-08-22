import 'package:flutter/material.dart';
import 'package:lix/app/color_select.dart';
import 'package:lix/screens/views/bottom_tabs/home_screen_styles.dart';
import 'package:lix/screens/widgets/claim_coupondialog.dart';
import 'package:lix/screens/widgets/submit_button.dart';

class TransactionDetails extends StatefulWidget {
  const TransactionDetails({Key? key}) : super(key: key);

  @override
  State<TransactionDetails> createState() => _TransactionDetailsState();
}

class _TransactionDetailsState extends State<TransactionDetails> {
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
                    "Get 10% discount on new collection items",
                    style: customFontRegular(14, ColorSelect.lightBlack),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Date",
                        style: textStyleBoldBlack(14),
                      ),
                      Text(
                        "Jul, 24 2022",
                        style: textStyleRegularBlack(14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Transaction ID",
                        style: textStyleBoldBlack(14),
                      ),
                      Text(
                        "ABCDEFG",
                        style: textStyleRegularBlack(14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                      height: 2,
                      width: MediaQuery.of(context).size.width,
                      color: ColorSelect.appThemeGrey),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total",
                        style: textStyleBoldBlack(14),
                      ),
                      Text(
                        "-20 LIX",
                        style: textStyleViewAll(14),
                      ),
                    ],
                  ),
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
                  return const ClaimCouponDialog();
                });
          },
          text: "Claim Reward",
          disabled: false,
          color: Colors.black,
        ),
      ),
    );
  }
}
