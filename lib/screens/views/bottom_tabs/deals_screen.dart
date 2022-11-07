import 'package:flutter/material.dart';
import 'package:lix/app/image_assets.dart';
import 'package:lix/locator.dart';
import 'package:lix/models/category_model.dart';
import 'package:lix/models/custom_exception.dart';
import 'package:lix/models/market_offer_model.dart';
import 'package:lix/models/offer_model.dart';
import 'package:lix/models/user.dart';
import 'package:lix/screens/views/bottom_tabs/home_screen_styles.dart';
import 'package:lix/screens/views/deal_details_screen.dart';
import 'package:lix/screens/views/earn_details_screen.dart';
import 'package:lix/screens/widgets/category_item.dart';
import 'package:lix/screens/widgets/recommended_deals.dart';
import 'package:lix/services/api.dart';
import 'package:lix/services/helper.dart';
import 'package:lix/services/snackbar.dart';

class DealsScreen extends StatefulWidget {
  const DealsScreen({Key? key}) : super(key: key);

  @override
  State<DealsScreen> createState() => _DealsScreenState();
}

class _DealsScreenState extends State<DealsScreen> {
  bool loading = false;
  bool loadMore = false;
  APIService apiService = locator<APIService>();
  HelperService helperService = locator<HelperService>();
  late User user = locator<HelperService>().getCurrentUser()!;
  SnackBarService snackBarService = locator<SnackBarService>();
  List<MarketOffer> allOffers = [];
  List<MarketOffer> initialOffers = [];
  List<Category> allCategories = [];
  String sortingOrder = 'asc';
  int currentPage = 1;
  int lastPage = 0;
  late ScrollController controller;

  showLoading() {
    setState(() {
      if (!mounted) return;
      loading = currentPage == 1 ? true : false;
      loadMore = true;
    });
  }

  hideLoading() {
    setState(() {
      if (!mounted) return;
      loading = false;
      loadMore = false;
    });
  }

  initialize() async {
    try {
      showLoading();
      // fetching all categories...
      // List<Category> categories = await apiService.getAllCategories(user);

      // first setting all the categories
      setState(() {
        if (!mounted) return;
        // allCategories = categories;
        // allCategories[0].selected = true;
      });

      // fetching all market offers...
      final Map<dynamic, dynamic> responseMap =
          await apiService.allMarketOffers(user, currentPage);
      List<MarketOffer> offers = responseMap['allOffers'];
      // setting all the market offers...
      setState(() {
        if (!mounted) return;
        allOffers = [...allOffers, ...offers];
        initialOffers = [...allOffers, ...offers];
        lastPage = responseMap['last_page'];
        currentPage = responseMap['current_page'];
      });
      hideLoading();
    } on CustomException catch (e) {
      hideLoading();
      ScaffoldMessenger.of(context).showSnackBar(
        snackBarService.showSnackBarWithString(
          e.message,
        ),
      );
    } catch (e) {
      hideLoading();
    }
  }

  @override
  void initState() {
    controller = ScrollController()..addListener(handleScrolling);
    initialize();
    super.initState();
  }

  void handleScrolling() {
    if (controller.offset >= controller.position.maxScrollExtent) {
      if (currentPage != lastPage) {
        setState(() {
          currentPage = currentPage + 1;
        });
        initialize();
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    controller.removeListener(handleScrolling);
  }

  List<MarketOffer> filterRequest(categoryId) {
    return initialOffers
        .where((element) => element.organisation!.categoryId == categoryId)
        .toList();
  }

  filterCategories(categoryId) {
    setState(() {
      allOffers = filterRequest(categoryId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Marketplace",
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
          : SingleChildScrollView(
              controller: controller,
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Marketplace',
                          style: textStyleMediumBlack(24),
                        ),
                        GestureDetector(
                          onTap: sortDeals,
                          child: Row(
                            children: [
                              const Image(
                                image: AssetImage(
                                  ImageAssets.sortArrowIcon,
                                ),
                                height: 16,
                                width: 16,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Sort',
                                style: textStyleViewAll(12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  RecommendedDeals(
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
                    viewAllOption: false,
                  ),
                  if (loadMore)
                    (const CircularProgressIndicator(color: Colors.blue)),
                ],
              ),
            ),
    );
  }

  String provideOrganizationName(MarketOffer offer) {
    if (offer.organisation != null) {
      return offer.organisation!.name ?? '';
    }
    return '';
  }

  sortDeals() {
    setState(() {
      allOffers.sort((a, b) {
        return provideOrganizationName(a).compareTo(
          provideOrganizationName(b),
        );
      });
    });

    if (sortingOrder == 'asc') {
      setState(() {
        sortingOrder = 'desc';
      });
    } else {
      setState(() {
        sortingOrder = 'asc';
        allOffers = allOffers.reversed.toList();
      });
    }
  }
}
