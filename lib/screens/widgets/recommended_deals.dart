// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:lix/app/color_select.dart';
import 'package:lix/models/market_offer_model.dart';
import 'package:lix/screens/views/bottom_tabs/home_screen_styles.dart';
import 'package:lix/services/api.dart';

class RecommendedDeals extends StatefulWidget {
  final Function onTap;
  final List<MarketOffer> productsList;
  final bool viewAllOption;
  const RecommendedDeals({
    Key? key,
    required this.onTap,
    required this.productsList,
    required this.viewAllOption,
  }) : super(key: key);

  @override
  State<RecommendedDeals> createState() => _RecommendedDealsState();
}

class _RecommendedDealsState extends State<RecommendedDeals> {
  late List<MarketOffer> allOffers = widget.productsList;
  double getTopMargin() {
    if (widget.viewAllOption) {
      return 16;
    } else {
      return 0;
    }
  }

  @override
  void didUpdateWidget(covariant RecommendedDeals oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.productsList != oldWidget.productsList) {
      setState(() {
        allOffers = widget.productsList;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.fromLTRB(16, getTopMargin(), 16, 0),
      child: Column(
        children: [
          if (widget.viewAllOption) const SizedBox(height: 12),
          if (widget.viewAllOption)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recommended',
                  style: textStyleBoldBlack(16),
                ),
                Text(
                  'View All',
                  style: textStyleViewAll(12),
                ),
              ],
            ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 12, 0, 0),
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: allOffers.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    widget.onTap();
                  },
                  child: Container(
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.fromLTRB(16, 0, 0, 16),
                          height: 160,
                          alignment: Alignment.bottomLeft,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: provideDealImage(allOffers[index]),
                              fit: BoxFit.fill,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4.0),
                            child: Image(
                              height: 50,
                              width: 50,
                              image: provideLogoImage(allOffers[index]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Container(
                          height: 70,
                          margin: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                          decoration: const BoxDecoration(
                            color: ColorSelect.appThemeGrey,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(4),
                              bottomRight: Radius.circular(4),
                            ),
                          ),
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.fromLTRB(16, 12, 0, 12),
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                (allOffers[index]
                                            .organisation
                                            ?.name
                                            .toString() ??
                                        '') +
                                    (allOffers[index]
                                            .organisation
                                            ?.id
                                            .toString() ??
                                        ''),
                                style: textStyleBoldBlack(16),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                allOffers[index].benefit ?? '',
                                overflow: TextOverflow.ellipsis,
                                style: textStyleRegularBlack(14),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  ImageProvider provideLogoImage(MarketOffer offer) {
    // TODO remove this once done.
    if (offer.organisation?.avatar != null) {
      return NetworkImage(
        APIService().imagesPath + (offer.organisation?.avatar ?? ''),
      );
    }
    return const AssetImage("assets/icons/ic_brand_1.png");
  }

  ImageProvider provideDealImage(MarketOffer offer) {
    // TODO remove this once done.
    if (offer.offerImage != null && offer.offerImage!.contains('http')) {
      return NetworkImage(
        offer.offerImage!,
      );
    }
    return const AssetImage("assets/images/ic_home_1.png");
  }
}
