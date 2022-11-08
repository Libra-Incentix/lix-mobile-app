import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lix/app/image_assets.dart';
import 'package:lix/locator.dart';
import 'package:lix/models/custom_exception.dart';
import 'package:lix/models/market_offer_model.dart';
import 'package:lix/models/notification_model.dart';
import 'package:lix/models/offer_model.dart';
import 'package:lix/models/task_link.dart';
import 'package:lix/models/task_model.dart';
import 'package:lix/models/user.dart';
import 'package:lix/screens/views/bottom_tabs/home_screen_styles.dart';
import 'package:lix/screens/views/dashboard.dart';
import 'package:lix/screens/views/deal_details_screen.dart';
import 'package:lix/screens/views/earn_details_screen.dart';
import 'package:lix/screens/views/notifications_view.dart';
import 'package:lix/screens/views/scan_qr_view.dart';
import 'package:lix/screens/widgets/earn_with_lix.dart';
import 'package:lix/screens/widgets/exclusive_deals.dart';
import 'package:lix/screens/widgets/recommended_deals.dart';
import 'package:lix/services/api.dart';
import 'package:lix/services/helper.dart';
import 'package:lix/services/snackbar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool loading = false;
  APIService apiService = locator<APIService>();
  HelperService helperService = locator<HelperService>();
  late User user = locator<HelperService>().getCurrentUser()!;
  List<MarketOffer> allOffers = [];
  List<TaskModel> allTasks = [];
  int taskNeeded = 2;
  int notificationCounts = 0;

  showLoading() {
    setState(() {
      if (!mounted) return;
      loading = true;
    });
  }

  hideLoading() {
    setState(() {
      if (!mounted) return;
      loading = false;
    });
  }

  initialize() async {
    try {
      showLoading();
      List<MarketOffer> offers = await apiService.allRecommendedDeals(user);
      final Map<dynamic, dynamic> tasksMap =
          await apiService.getGlobalTasks(user, 1);
      List<TaskModel> tasks = tasksMap['tasks'];
      List<NotificationModel> notifications =
          await apiService.getAllNotifications(user);
      hideLoading();
      int maxTasks = tasks.length > taskNeeded ? taskNeeded : tasks.length;
      setState(() {
        if (!mounted) return;
        allOffers = offers.getRange(0, 3).toList();
        allTasks = tasks.getRange(0, maxTasks).toList();
        notificationCounts =
            notifications.where((element) => !element.read!).toList().length;
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                CupertinoPageRoute(
                  fullscreenDialog: true,
                  builder: (context) => const NotificationsView(),
                ),
              );
            },
            icon: Stack(
              children: [
                Image.asset(
                  ImageAssets.notificationBell,
                  height: 25,
                  width: 25,
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: notificationCounts > 0
                      ? Container(
                          padding: const EdgeInsets.all(1),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            notificationCounts.toString(),
                            style: const TextStyle(
                              fontSize: 13,
                            ),
                          ),
                        )
                      : Container(),
                ),
              ],
            ),
          ),
        ],
        centerTitle: true,
        title: const Text(
          "Earn & redeem points",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
            fontFamily: 'Inter',
          ),
        ),
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Text(
                    'Hi ${user.name ?? ""}, Earn & redeem LIX',
                    textScaleFactor: 1.0,
                    style: textStyleMediumBlack(22),
                  ),
                ),
                // Top container with qr code image and scan button
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  height: 140,
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: AssetImage("assets/images/app_bg_home.png"),
                      fit: BoxFit.fitWidth,
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        width: 96,
                        height: 120,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/images/qr_phone.png"),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Scan & Earn',
                            style: textStyleMedium(20),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Scan barcode to claim rewards',
                            style: textStyleRegular(12),
                          ),
                          const SizedBox(height: 16),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ScanQrView(),
                                ),
                              );
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 36,
                              width: 144,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Image(
                                    height: 12,
                                    width: 12,
                                    image: AssetImage(
                                      "assets/icons/qr_button_left.png",
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Scan now',
                                    style: buttonTextBold(),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),

                // ----------Hidden Exclusive Details---------- //
                // ExclusiveDeals(
                //   onTap: () {},
                //   productsList: allOffers,
                // ),
                RecommendedDeals(
                  viewAllAction: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return const Dashboard(
                            index: 1,
                          );
                        },
                      ),
                    );
                  },
                  onTap: (MarketOffer offer) {
                    OfferModel offerModel = OfferModel.fromMarkerOffer(offer);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EarnDetailsScreen(
                          offerModel: offerModel,
                          taskLink: null,
                        ),
                      ),
                    );
                  },
                  productsList: allOffers,
                  viewAllOption: true,
                ),
                EarnWithLix(
                  viewAllAction: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return const Dashboard(
                            index: 2,
                          );
                        },
                      ),
                    );
                  },
                  onTap: (TaskModel task) {
                    // first creating task link model...
                    TaskLinkModel taskLinkModel = TaskLinkModel(
                      task: task,
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EarnDetailsScreen(
                          taskLink: taskLinkModel,
                          offerModel: null,
                        ),
                      ),
                    );
                  },
                  allTasks: allTasks,
                )
              ],
            ),
    );
  }
}
