import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:lix/app/color_select.dart';
import 'package:lix/app/image_assets.dart';
import 'package:lix/locator.dart';
import 'package:lix/models/buy_offer_success.dart';
import 'package:lix/models/custom_exception.dart';
import 'package:lix/models/offer_model.dart';
import 'package:lix/models/task_link.dart';
import 'package:lix/models/task_model.dart';
import 'package:lix/models/user.dart';
import 'package:lix/screens/views/bottom_tabs/home_screen_styles.dart';
import 'package:lix/screens/widgets/ExpandableItem.dart';
import 'package:lix/screens/widgets/claim_coupondialog.dart';
import 'package:lix/screens/widgets/claim_task_dialog.dart';
import 'package:lix/screens/widgets/submit_button.dart';
import 'package:lix/services/api.dart';
import 'package:lix/services/helper.dart';
import 'package:lix/services/snackbar.dart';
import 'package:share_plus/share_plus.dart';

class EarnDetailsScreen extends StatefulWidget {
  final TaskLinkModel? taskLink;
  final OfferModel? offerModel;
  const EarnDetailsScreen({
    Key? key,
    required this.taskLink,
    required this.offerModel,
  }) : super(key: key);

  @override
  State<EarnDetailsScreen> createState() => _EarnDetailsScreenState();
}

class _EarnDetailsScreenState extends State<EarnDetailsScreen> {
  TaskLinkModel? taskLinkModel;
  TaskModel? task;
  OfferModel? offerModel;
  APIService apiService = locator<APIService>();
  SnackBarService snackBarService = locator<SnackBarService>();
  late User user = locator<HelperService>().getCurrentUser()!;
  bool isTask = true;
  Widget? qrImage;
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

  @override
  void initState() {
    if (widget.taskLink != null) {
      taskLinkModel = widget.taskLink;
      task = widget.taskLink!.task;
      isTask = true;
    } else {
      offerModel = widget.offerModel;
      isTask = false;
    }
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
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 215,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: offerImage(),
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
                              fit: BoxFit.cover,
                            ),
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
                        taskDescription(),
                        const SizedBox(height: 24),
                        taskRewardOrFee(),
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
      bottomSheet: loading
          ? Container(height: 0)
          : Container(
              margin: const EdgeInsets.only(left: 16, right: 16),
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
              child: SubmitButton(
                onTap: claim,
                text: "Claim Reward",
                disabled: false,
                color: Colors.black,
              ),
            ),
    );
  }

  ImageProvider offerImage() {
    if (isTask) {
      return const AssetImage("assets/images/deal_details_bg.png");
    } else {
      return const AssetImage("assets/images/deal_details_bg.png");
    }
  }

  Widget taskRewardOrFee() {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: ColorSelect.appThemeGrey,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        title: Text(
          isTask ? "Earn" : "Fee",
          style: textStyleBoldBlack(16),
        ),
        minLeadingWidth: 34,
        leading: const Image(
          image: AssetImage(ImageAssets.dollarFilled),
          fit: BoxFit.fitHeight,
          height: 34,
          width: 34,
        ),
        trailing: Text(
          "${taskReward()} LIX",
          style: textStyleViewAll(16),
        ),
      ),
    );
  }

  String taskTitle() {
    if (isTask) {
      return task!.title ?? '';
    } else {
      return offerModel!.benefit ?? '';
    }
  }

  Widget taskDescription() {
    if (isTask) {
      return HtmlWidget(
        task!.description ?? '',
        textStyle: customFontRegular(
          14,
          ColorSelect.lightBlack,
        ),
      );
    } else {
      return HtmlWidget(
        offerModel!.instructions ?? '',
        textStyle: customFontRegular(
          14,
          ColorSelect.lightBlack,
        ),
      );
    }
  }

  String taskReward() {
    if (isTask) {
      return task!.coinsPerAction.toString();
    } else {
      return offerModel!.fee.toString();
    }
  }

  claim() {
    if (isTask) {
      submitTask();
    } else {
      claimOffer();
    }
  }

  Future claimOffer() async {
    try {
      showLoading();
      Map<String, dynamic> response = await apiService.buyOffer(
        user,
        offerModel!.id!.toString(),
      );
      hideLoading();

      if (response['success'] != null && response['success']) {
        BuyOfferSuccess offerSuccess = BuyOfferSuccess.fromJson(
          response['data'],
        );

        showDialog(
          context: context,
          builder: (context) {
            return ClaimCouponDialog(
              buyOfferSuccess: offerSuccess,
              shareAction: () async {
                // share the coupon code
                await Share.share(
                  'Hey I claimed a coupon on LIV, here is the code: "${offerSuccess.coupon}"',
                  subject: 'Coupon Claimed',
                );
              },
            );
          },
        );
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          snackBarService.showSnackBarWithString(
            response['message'] ?? 'Unable to claim this coupon...',
          ),
        );
      }
    } on CustomException catch (e) {
      hideLoading();
      ScaffoldMessenger.of(context).showSnackBar(
        snackBarService.showSnackBarWithString(
          e.message,
        ),
      );
    } catch (e) {
      log('$e');
      hideLoading();
      ScaffoldMessenger.of(context).showSnackBar(
        snackBarService.showSnackBarWithString(
          'Unable to claim this offer...',
        ),
      );
    }
  }

  Future submitTask() async {
    try {
      showLoading();
      Map<String, dynamic> response = await apiService.submitTask(
        user,
        task!.id.toString(),
        taskLinkModel!.id!.toString(),
      );

      if (response['success'] != null && response['success']) {
        showDialog(
          context: context,
          builder: (context) {
            return ClaimTaskDialog(
              reward: task!.coinsPerAction.toString(),
              fullLink: taskLinkModel!.fullLink!,
            );
          },
        );
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          snackBarService.showSnackBarWithString(
            response['message'] ?? 'Unable to claim this task...',
          ),
        );
      }
      hideLoading();
    } on CustomException catch (e) {
      hideLoading();
      ScaffoldMessenger.of(context).showSnackBar(
        snackBarService.showSnackBarWithString(
          e.message,
        ),
      );
    } catch (e) {
      log('$e');
      hideLoading();
      ScaffoldMessenger.of(context).showSnackBar(
        snackBarService.showSnackBarWithString(
          'Unable to claim this task...',
        ),
      );
    }
  }
}
