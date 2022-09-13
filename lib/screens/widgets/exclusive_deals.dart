// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:lix/app/color_select.dart';
import 'package:lix/models/market_offer_model.dart';
import 'package:lix/screens/views/bottom_tabs/home_screen_styles.dart';

class ExclusiveDeals extends StatefulWidget {
  final Function onTap;
  final List<MarketOffer> productsList;
  const ExclusiveDeals({
    Key? key,
    required this.onTap,
    required this.productsList,
  }) : super(key: key);

  @override
  State<ExclusiveDeals> createState() => _ExclusiveDealsState();
}

class _ExclusiveDealsState extends State<ExclusiveDeals> {
  late List<MarketOffer> allOffers = widget.productsList;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.fromLTRB(16, 28, 16, 0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Exclusive Deals',
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
            height: 166.0,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: allOffers.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4),
                          topRight: Radius.circular(4),
                        ),
                        child: Image(
                          width: 150,
                          height: 134,
                          image: provideImage(allOffers[index]),
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          color: ColorSelect.appThemeGrey,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(4),
                            bottomRight: Radius.circular(4),
                          ),
                        ),
                        width: 150,
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                        alignment: Alignment.center,
                        child: Text(
                          allOffers[index].organisation!.name!,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  ImageProvider provideImage(MarketOffer offer) {
    // TODO remove this once done.
    // if (offer.offerImage != null && offer.offerImage!.contains('http')) {
    //   return NetworkImage(
    //     offer.offerImage!,
    //   );
    // }
    return const AssetImage("assets/images/nike_img.png");
  }
}
