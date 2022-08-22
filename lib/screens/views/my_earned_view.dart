import 'package:flutter/material.dart';
import 'package:lix/app/color_select.dart';
import 'package:lix/models/transc_model.dart';
import 'package:lix/screens/transaction_details.dart';
import 'package:lix/screens/views/bottom_tabs/home_screen_styles.dart';

class MyEarnedView extends StatefulWidget {
  const MyEarnedView({Key? key}) : super(key: key);

  @override
  State<MyEarnedView> createState() => _MyEarnedViewState();
}

class _MyEarnedViewState extends State<MyEarnedView> {
  final List<TranscModel> earninigs = [
    TranscModel(
        title: "Share a deal and get 20 LIX",
        date: "Jul, 23 2022",
        imgPath: "assets/icons/ic_notlist_4.png",
        points: "20 LIX"),
    TranscModel(
        title: "Download the app",
        date: "Jul, 23 2022",
        imgPath: "assets/icons/ic_notlist_2.png",
        points: "20 LIX"),
    TranscModel(
        title: "Buy 2 meals",
        date: "Jul, 23 2022 2022",
        imgPath: "assets/icons/ic_notlist_3.png",
        points: "20 LIX"),
    TranscModel(
        title: "10 Lix per night",
        date: "Jul, 24 2022 2022",
        imgPath: "assets/icons/ic_notlist_4.png",
        points: "20 LIX"),
  ];

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
          itemCount: earninigs.length,
          itemBuilder: (context, index) {
            return ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const TransactionDetails()),
                );
              },
              tileColor: Colors.white,
              title: Padding(
                padding: const EdgeInsets.only(top: 10, left: 0, bottom: 4),
                child: Text(
                  earninigs[index].title,
                  style: textStyleBoldBlack(15),
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(earninigs[index].date,
                    style: customFontRegular(13, ColorSelect.greyDark)),
              ),
              leading: Container(
                height: 36,
                width: 36,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(earninigs[index].imgPath)),
                  borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                  border: Border.all(
                    color: ColorSelect.appThemeGrey,
                    width: 2,
                  ),
                ),
              ),
              trailing:
                  Text(earninigs[index].points, style: textStyleViewAll(14)),
            );
          }),
    );
  }
}
