import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lix/app/color_select.dart';
import 'package:lix/models/transaction_model.dart';
import 'package:lix/models/transc_model.dart';
import 'package:lix/screens/transaction_details.dart';
import 'package:lix/screens/views/bottom_tabs/home_screen_styles.dart';

class MyEarnedView extends StatefulWidget {
  final List<TransactionModel> allTransactions;
  const MyEarnedView({
    Key? key,
    required this.allTransactions,
  }) : super(key: key);

  @override
  State<MyEarnedView> createState() => _MyEarnedViewState();
}

class _MyEarnedViewState extends State<MyEarnedView> {
  late List<TransactionModel> allTransactions = widget.allTransactions;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: allTransactions.length,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TransactionDetails(
                    transaction: allTransactions[index],
                  ),
                ),
              );
            },
            tileColor: Colors.white,
            title: Padding(
              padding: const EdgeInsets.only(top: 10, left: 0, bottom: 4),
              child: Text(
                allTransactions[index].description ?? '',
                style: textStyleBoldBlack(15),
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                getTransactionDate(index),
                style: customFontRegular(
                  13,
                  ColorSelect.greyDark,
                ),
              ),
            ),
            leading: Container(
              height: 36,
              width: 36,
              decoration: BoxDecoration(
                image: const DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(
                    "assets/icons/ic_notlist_4.png",
                  ),
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(8.0),
                ),
                border: Border.all(
                  color: ColorSelect.appThemeGrey,
                  width: 2,
                ),
              ),
            ),
            trailing: Text(
              parseCurrency(index),
              style: textStyleViewAll(14),
            ),
          );
        },
      ),
    );
  }

  getTransactionDate(int index) {
    if (allTransactions[index].createdAt != null) {
      return DateFormat('d, MMM yyyy').format(
        DateTime.parse(allTransactions[index].createdAt!),
      );
    }
    return DateFormat('d, MMM yyyy').format(
      DateTime.now(),
    );
  }

  String parseCurrency(int index) {
    if (allTransactions[index].amount != null &&
        allTransactions[index].currency != null) {
      return '${allTransactions[index].amount} ${allTransactions[index].currency}';
    }
    return '0 LIX';
  }
}
