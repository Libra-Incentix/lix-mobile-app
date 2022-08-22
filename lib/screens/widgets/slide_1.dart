import 'package:flutter/material.dart';

class Slide1 extends StatelessWidget {
  const Slide1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const <Widget>[
          Image(
            image: AssetImage("assets/icons/lix_logo.png"),
            fit: BoxFit.fitHeight,
            height: 40,
            width: 56,
          ),
          SizedBox(height: 10),
          Text(
            'Earn & Redeem Points',
            style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
                fontSize: 38,
                color: Colors.white),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            'Scan your digital card to earn & redeem your reword points at over 2000 stores',
            style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                fontSize: 16,
                height: 1.4,
                color: Colors.white),
          ),
        ],
      ),
    );
  }
}
