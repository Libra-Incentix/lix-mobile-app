import 'package:flutter/material.dart';

class Slide3 extends StatelessWidget {
  const Slide3({Key? key}) : super(key: key);

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
            'Keep Track on your points',
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
            'Lorem Ipsum is simply dummy text of the printing and typesetting industry. ',
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
