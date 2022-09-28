import 'package:flutter/material.dart';
import 'package:lix/app/color_select.dart';
import 'package:lix/app/image_assets.dart';
import 'package:lix/screens/views/bottom_tabs/home_screen_styles.dart';
import 'package:lix/screens/widgets/ExpandableItem.dart';
import 'package:lix/screens/widgets/claim_coupondialog.dart';
import 'package:lix/screens/widgets/submit_button.dart';

class EarnDetailsScreen extends StatefulWidget {
  final dynamic data;
  const EarnDetailsScreen({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  State<EarnDetailsScreen> createState() => _EarnDetailsScreenState();
}

class _EarnDetailsScreenState extends State<EarnDetailsScreen> {
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 215,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/deal_details_bg.png"),
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
                    taskTitle(),
                    style: textStyleMediumBlack(20),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    taskDescription(),
                    style: customFontRegular(14, ColorSelect.lightBlack),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: ColorSelect.appThemeGrey,
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      title: Text("Earn", style: textStyleBoldBlack(16)),
                      minLeadingWidth: 34,
                      leading: const Image(
                        image: AssetImage(ImageAssets.dollarFilled),
                        fit: BoxFit.fitHeight,
                        height: 34,
                        width: 34,
                      ),
                      trailing: Text("${taskReward()} LIX",
                          style: textStyleViewAll(16)),
                    ),
                  ),
                  const SizedBox(height: 32),
                  ExpandableItem(
                    title: "About this deal",
                    childTitle:
                        "Morbi tincidunt lectus non sagittis tincidunt nulla nec metus at nunc dignissim placerat.",
                  ),
                  ExpandableItem(
                    title: "Terms & conditions",
                    childTitle: "Lorem ipsum is simply dummy text.",
                  ),
                  const SizedBox(height: 32),
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

  String taskTitle() {
    if (widget.data != null) {
      if (widget.data['link'] != null && widget.data['link']['task'] != null) {
        return widget.data['link']['task']['title'];
      }
    }
    return "Texas De Brazil";
  }

  String taskDescription() {
    if (widget.data != null) {
      if (widget.data['link'] != null && widget.data['link']['task'] != null) {
        return widget.data['link']['task']['description'];
      }
    }
    return "Spend 500 AED and above and earn 20 LIX";
  }

  String taskReward() {
    if (widget.data != null) {
      if (widget.data['link'] != null && widget.data['link']['task'] != null) {
        return widget.data['link']['task']['coins_per_action'].toString();
      }
    }
    return '0';
  }
}
