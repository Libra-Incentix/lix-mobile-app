import 'package:flutter/material.dart';
import 'package:lix/app/image_assets.dart';
import 'package:lix/screens/views/bottom_tabs/home_screen_styles.dart';
import 'package:lix/screens/views/deal_details_screen.dart';
import 'package:lix/screens/widgets/category_item.dart';
import 'package:lix/screens/widgets/recommended_deals.dart';

class DealsScreen extends StatefulWidget {
  const DealsScreen({Key? key}) : super(key: key);

  @override
  State<DealsScreen> createState() => _DealsScreenState();
}

class _DealsScreenState extends State<DealsScreen> {
  var selectedCategory = 0;
  var catList = [
    {
      "name": "All",
      "selected": true,
    },
    {
      "name": "Fashion",
      "selected": false,
    },
    {
      "name": "Dining",
      "selected": false,
    },
    {
      "name": "Travel",
      "selected": false,
    },
    {
      "name": "Entertainment",
      "selected": false,
    },
    {
      "name": "Furniture",
      "selected": false,
    },
    {
      "name": "Leisure",
      "selected": true,
    }
  ];
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
              fontFamily: 'Inter'),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                margin: const EdgeInsets.fromLTRB(16, 6, 0, 18),
                height: 40.0,
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: catList.length,
                    itemBuilder: (context, index) {
                      return CategoryItem(
                          itemIndex: index,
                          onTap: (itemIndex) {
                            setState(() {
                              selectedCategory = itemIndex;
                              // catList[itemIndex].selected = true;
                            });
                          },
                          text: catList[index]["name"].toString(),
                          selected: (index == selectedCategory));
                    })),
            Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('All Deals', style: textStyleMediumBlack(24)),
                  Row(
                    children: [
                      const Image(
                        image: AssetImage(ImageAssets.sortArrowIcon),
                        height: 16,
                        width: 16,
                      ),
                      const SizedBox(width: 8),
                      Text('Sort', style: textStyleViewAll(12)),
                    ],
                  ),
                ],
              ),
            ),
            RecommendedDeals(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const DealDetailsScreen()),
                  );
                },
                productsList: dealsList,
                viewAllOption: false),
          ],
        ),
      ),
    );
  }
}
