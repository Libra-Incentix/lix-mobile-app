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
  var dealsList = [
    {
      "name": "Watchbox",
      "picture": "assets/images/ic_home_1.png",
      "logo": "assets/icons/ic_brand_1.png",
      "desc": "Superior Watchmaking Service"
    },
    {
      "name": "Bloomingdales",
      "picture": "assets/images/ic_home_2.png",
      "logo": "assets/icons/ic_brand_2.png",
      "desc": "Get the latest offers of Bloomingdales"
    },
    {
      "name": "Mcdonald's",
      "picture": "assets/images/ic_home_3.png",
      "logo": "assets/icons/ic_brand_3.png",
      "desc": "Best choice for quick snacks"
    },
    {
      "name": "Atlantis hotel",
      "picture": "assets/images/ic_home_4.png",
      "logo": "assets/icons/ic_brand_4.png",
      "desc": "Luxury stay in Dubai"
    },
    {
      "name": "Watchbox",
      "picture": "assets/images/ic_home_1.png",
      "logo": "assets/icons/ic_brand_1.png",
      "desc": "Superior Watchmaking Service"
    },
    {
      "name": "Bloomingdales",
      "picture": "assets/images/ic_home_2.png",
      "logo": "assets/icons/ic_brand_2.png",
      "desc": "Get the latest offers of Bloomingdales"
    },
    {
      "name": "Mcdonald's",
      "picture": "assets/images/ic_home_3.png",
      "logo": "assets/icons/ic_brand_3.png",
      "desc": "Best choice for quick snacks"
    },
    {
      "name": "Atlantis hotel",
      "picture": "assets/images/ic_home_4.png",
      "logo": "assets/icons/ic_brand_4.png",
      "desc": "Luxury stay in Dubai"
    },
  ];
  bool loading = false;
  APIService apiService = locator<APIService>();
  HelperService helperService = locator<HelperService>();
  late User user = locator<HelperService>().getCurrentUser()!;
  SnackBarService snackBarService = locator<SnackBarService>();
  List<MarketOffer> allOffers = [];
  List<MarketOffer> initialOffers = [];
  List<Category> allCategories = [];
  String sortingOrder = 'asc';

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
      // fetching all categories...
      List<Category> categories = await apiService.getAllCategories(user);

      // first setting all the categories
      setState(() {
        if (!mounted) return;
        allCategories = categories;
        // allCategories[0].selected = true;
      });

      // fetching all market offers...
      List<MarketOffer> offers = await apiService.allMarketOffers(user);

      // setting all the market offers...
      setState(() {
        if (!mounted) return;
        allOffers = offers;
        initialOffers = offers;
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
    initialize();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
          "Deals",
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
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(16, 6, 0, 18),
                    height: 40.0,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: allCategories.length,
                      itemBuilder: (context, index) {
                        return CategoryItem(
                          category: allCategories[index],
                          onTap: (Category category) {
                            setState(() {
                              for (Category element in allCategories) {
                                element.selected = false;
                              }
                              Category c = category;
                              c.selected = true;
                              allCategories[index] = c;
                              filterCategories(c.id);
                            });
                          },
                        );
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'All Deals',
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
                  // TODO this is commented because of coming from changes in RecommendedDeals page.
                  RecommendedDeals(
                    onTap: (MarketOffer offer) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DealDetailsScreen(marketOffer: offer),
                        ),
                      );
                    },
                    productsList: allOffers,
                    viewAllOption: false,
                  ),
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
