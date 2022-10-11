import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lix/app/color_select.dart';
import 'package:lix/models/transaction_model.dart';
import 'package:lix/screens/views/bottom_tabs/home_screen_styles.dart';
import 'package:lix/screens/widgets/submit_button.dart';

class TransactionDetails extends StatefulWidget {
  final TransactionModel transaction;
  const TransactionDetails({
    Key? key,
    required this.transaction,
  }) : super(key: key);

  @override
  State<TransactionDetails> createState() => _TransactionDetailsState();
}

class _TransactionDetailsState extends State<TransactionDetails> {
  late TransactionModel transaction = widget.transaction;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 215,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/ic_home_1.png"),
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
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text(
                  //   "Watchbox",
                  //   style: textStyleMediumBlack(20),
                  // ),
                  // const SizedBox(height: 8),
                  Text(
                    transaction.description ?? '',
                    style: customFontRegular(
                      14,
                      ColorSelect.lightBlack,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Date",
                        style: textStyleBoldBlack(14),
                      ),
                      Text(
                        getTransactionDate(),
                        style: textStyleRegularBlack(14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            "Transaction ID",
                            style: textStyleBoldBlack(14),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            getTransactionId(),
                            textAlign: TextAlign.right,
                            style: textStyleRegularBlack(14),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 2,
                    width: MediaQuery.of(context).size.width,
                    color: ColorSelect.appThemeGrey,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total",
                        style: textStyleBoldBlack(14),
                      ),
                      Text(
                        parseCurrency(),
                        style: textStyleViewAll(14),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getTransactionId() {
    if (transaction.tnxId != null) {
      return transaction.tnxId!;
    }
    return '';
  }

  String getTransactionDate() {
    if (transaction.createdAt != null) {
      return DateFormat('d, MMM yyyy').format(
        DateTime.parse(transaction.createdAt!),
      );
    }
    return DateFormat('d, MMM yyyy').format(
      DateTime.now(),
    );
  }

  String parseCurrency() {
    String value = '0 LIX';
    if (transaction.amount != null && transaction.currency != null) {
      value = '${transaction.amount} ${transaction.currency}';
    }

    if (transaction.type != null && transaction.type != 'earning') {
      value = '-$value';
    }
    return value;
  }
}
