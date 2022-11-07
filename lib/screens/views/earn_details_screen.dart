import 'dart:async';
import 'dart:developer' as devtools show log;

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:intl/intl.dart';
import 'package:lix/app/color_select.dart';
import 'package:lix/app/image_assets.dart';
import 'package:lix/locator.dart';
import 'package:lix/models/buy_offer_success.dart';
import 'package:lix/models/country_phone_model.dart';
import 'package:lix/models/custom_exception.dart';
import 'package:lix/models/offer_model.dart';
import 'package:lix/models/task_link.dart';
import 'package:lix/models/task_model.dart';
import 'package:lix/models/user.dart';
import 'package:lix/models/wallet_details.dart';
import 'package:lix/screens/views/bottom_tabs/home_screen_styles.dart';
import 'package:lix/screens/views/dashboard.dart';
import 'package:lix/screens/widgets/ExpandableItem.dart';
import 'package:lix/screens/widgets/claim_coupondialog.dart';
import 'package:lix/screens/widgets/claim_task_dialog.dart';
import 'package:lix/screens/widgets/expandable_card.dart';
import 'package:lix/screens/widgets/submit_button.dart';
import 'package:lix/screens/widgets/task_proof_dialog.dart';
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
  String selectedCountry = "";
  List<CountryPhone> countries = [];
  APIService apiService = locator<APIService>();
  SnackBarService snackBarService = locator<SnackBarService>();
  late User user = locator<HelperService>().getCurrentUser()!;
  bool isTask = true;
  Widget? qrImage;
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

  ImageProvider getOfferAvatar(OfferModel? offer) {
    if (offer?.createdByOrganisation?.avatar != null) {
      return NetworkImage(
        APIService().imagesPath + (offer?.createdByOrganisation?.avatar ?? ''),
      );
    }
    return const AssetImage("assets/images/ic_home_1.png");
  }

  ImageProvider getTaskAvatar(TaskModel? taskModel) {
    if (taskModel != null) {
      return NetworkImage(taskModel.avatar ?? '');
    }
    return const AssetImage("assets/icons/ic_home_1.png");
  }

  ImageProvider getTaskImage(TaskModel? taskModel) {
    if (taskModel != null && taskModel.avatar!.contains('http')) {
      return NetworkImage(taskModel.avatar ?? '');
    }
    return const AssetImage("assets/images/no-img.png");
  }

  ImageProvider provideOfferImage(OfferModel? offer) {
    if (offer?.offerImage != null &&
        (offer?.offerImage ?? '').contains('http')) {
      return NetworkImage(
        offer?.offerImage! ?? '',
      );
    }
    return const AssetImage("assets/images/ic_home_2.png");
  }

  initialize() async {
    try {
      showLoading();
      List<WalletDetails> allWallets = await apiService.getUserBalance(user);
      if (allWallets.isNotEmpty) {
        setState(() {
          wallets = allWallets;
          lixWallet = allWallets.singleWhere(
            (e) => e.customCurrencyId == 2,
          );
        });
      }
      hideLoading();
    } on CustomException catch (e) {
      devtools.log('$e');
      hideLoading();
    } catch (e) {
      devtools.log('$e');
      hideLoading();
    }
  }

  @override
  void initState() {
    initialize();
    if (widget.taskLink != null) {
      taskLinkModel = widget.taskLink;
      task = widget.taskLink!.task;
      isTask = true;
    } else {
      offerModel = widget.offerModel;
      initOfferModel();
      isTask = false;
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  initOfferModel() async {
    List<CountryPhone> allCountries = await apiService.getAllPhoneCountries();
    final split = offerModel?.supportedCountries.toString().split(',');
    String country = "";
    for (int i = 0; i < split!.length; i++) {
      var countryArray = allCountries.where(
        (element) => element.id.toString() == split[i],
      );
      if (countryArray.isNotEmpty) {
        var countryObj = countryArray.first;
        if (i == 0) {
          country = (countryObj.name ?? '');
        } else {
          country = "$country, ${countryObj.name ?? ''}";
        }
      }
    }
    setState(() {
      selectedCountry = country;
    });
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
                        image: coverImage(),
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
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 4,
                                  color: Colors.black.withOpacity(.2),
                                  spreadRadius: 2,
                                  offset: const Offset(2, 4),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4.0),
                              child: Image(
                                height: 50,
                                width: 50,
                                image: logoImage(),
                                fit: BoxFit.cover,
                              ),
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
                        showCurrentBalanceIfAny(),
                        taskRewardOrFee(),
                        const SizedBox(height: 32),
                        ExpandableItem(
                          title: "About this deal",
                          childTitle: isTask
                              ? (task!.description ?? '')
                              : (offerModel!.instructions ?? ''),
                        ),
                        if (selectedCountry != "")
                          ExpandableItem(
                            title: "Locations",
                            childTitle: selectedCountry,
                          ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ],
              ),
            ),
      bottomSheet: showClaimButtonIfEligible(),
    );
  }

  ImageProvider coverImage() {
    if (isTask) {
      return getTaskImage(task);
    } else {
      return provideOfferImage(offerModel);
    }
  }

  ImageProvider logoImage() {
    if (isTask) {
      if (task!.avatar != null) {
        return NetworkImage(task!.avatar!);
      }
      return const AssetImage("assets/images/ic_home_1.png");
    }
    return getOfferAvatar(offerModel);
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
      if (taskLinkModel!.task!.proofType == "nothing") {
        submitTaskWithoutImage("");
      } else {
        showProofDialog();
      }
    } else {
      claimOffer();
    }
  }

  onSubmitProof(imagePath, codeReceived) {
    submitTask(imagePath, codeReceived);
  }

  showProofDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return TaskProofDialog(
          onSubmit: onSubmitProof,
          proofType: taskLinkModel!.task!.proofType ?? 'text',
        );
      },
    );
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

        await showDialog(
          context: context,
          builder: (context) {
            return ClaimCouponDialog(
              buyOfferSuccess: offerSuccess,
              shareAction: () async {
                // share the coupon code
                ShareResult result = await Share.shareWithResult(
                  subject: shareSubject(offerSuccess),
                  shareDescription(offerSuccess),
                );

                if (result.status == ShareResultStatus.success) {
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                  creditSocialShareBonus();
                }
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
      devtools.log('$e');
      hideLoading();
      ScaffoldMessenger.of(context).showSnackBar(
        snackBarService.showSnackBarWithString(
          'Unable to claim this offer...',
        ),
      );
    }
  }

  Future submitTask(imagePath, codeReceived) async {
    try {
      showLoading();
      Map<String, dynamic> response = await apiService.submitTaskMultipart(
        user,
        task!.id.toString(),
        imagePath,
        codeReceived,
      );

      if (response['success'] != null && response['success']) {
        dynamic response = await showDialog(
          context: context,
          builder: (context) {
            return ClaimTaskDialog(
              task: task!,
              reward: task!.coinsPerAction.toString(),
              fullLink: taskLinkModel!.fullLink!,
            );
          },
        );

        if (response != null && (response['response'] as String).isNotEmpty) {
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

        initialize();
      } else {
        devtools.log(response.toString());
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          snackBarService.showSnackBarWithString(
            response['message'] ?? 'Unable to claim this task...',
          ),
        );
      }
      hideLoading();
    } on CustomException catch (e) {
      devtools.log(e.toString());
      hideLoading();
      ScaffoldMessenger.of(context).showSnackBar(
        snackBarService.showSnackBarWithString(
          e.message,
        ),
      );
    } catch (e) {
      devtools.log(e.toString());
      hideLoading();
      ScaffoldMessenger.of(context).showSnackBar(
        snackBarService.showSnackBarWithString(
          'Unable to claim this task...',
        ),
      );
    }
  }

  Widget showCurrentBalanceIfAny() {
    if (isTask) {
      return Container();
    }

    return Column(
      children: [
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
            leadingIcon: ImageAssets.dollarFilled,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Future submitTaskWithoutImage(codeReceived) async {
    try {
      showLoading();
      Map<String, dynamic> response = await apiService.submitTaskPost(
          user, task!.id.toString(), codeReceived);

      if (response['success'] != null && response['success']) {
        dynamic response = await showDialog(
          context: context,
          builder: (context) {
            return ClaimTaskDialog(
              task: task!,
              reward: task!.coinsPerAction.toString(),
              fullLink: taskLinkModel!.fullLink.toString(),
              qrImage: task!.qrCodeImage,
            );
          },
        );

        if (response != null && (response['response'] as String).isNotEmpty) {
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

        initialize();
      } else {
        devtools.log(response.toString());
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          snackBarService.showSnackBarWithString(
            response['message'] ?? 'Unable to claim this task...',
          ),
        );
      }
      hideLoading();
    } on CustomException catch (e) {
      devtools.log(e.toString());
      hideLoading();
      ScaffoldMessenger.of(context).showSnackBar(
        snackBarService.showSnackBarWithString(
          e.message,
        ),
      );
    } catch (e) {
      devtools.log(e.toString());
      hideLoading();
      ScaffoldMessenger.of(context).showSnackBar(
        snackBarService.showSnackBarWithString(
          'Unable to claim this task...',
        ),
      );
    }
  }

  Widget showClaimButtonIfEligible() {
    if (loading) {
      return Container(
        height: 0,
      );
    }

    if ((lixWallet != null &&
            int.parse(lixWallet!.balance!) >= (offerModel?.fee ?? 0)) ||
        isTask) {
      return Container(
        margin: const EdgeInsets.only(left: 16, right: 16),
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
        child: SubmitButton(
          onTap: claim,
          text: isTask ? "Claim Reward" : "Buy coupon",
          disabled: false,
          color: Colors.black,
        ),
      );
    } else {
      return Container(
        margin: const EdgeInsets.only(left: 16, right: 16),
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
        child: SubmitButton(
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const Dashboard(
                  index: 2,
                ),
              ),
            );
          },
          text: "Earn LIX",
          disabled: false,
          color: Colors.black,
        ),
      );
    }
  }

  creditSocialShareBonus() async {
    try {
      // ok user shared coupon successfully.
      // credit 5 lix in user's account.
      String response = await apiService.creditSocialShareBonus(user);
      if (response.runtimeType == String) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          snackBarService.showSnackBarWithString(
            response,
            type: SnackBarType.success,
          ),
        );
      }
    } on CustomException catch (e) {
      devtools.log('$e'); // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        snackBarService.showSnackBarWithString(
          e.message,
        ),
      );
    } catch (e) {
      devtools.log('$e');
    }
  }

  String shareSubject(BuyOfferSuccess offer) {
    if (offer.coupon != null && offer.coupon!.description != null) {
      return offer.coupon!.description!;
    }

    return 'Coupon Claimed';
  }

  String shareDescription(BuyOfferSuccess offer) {
    if (offer.coupon != null && offer.coupon!.market != null) {
      return offer.coupon!.market!['offer_link'] ?? '';
    }

    return '';
  }
}
