import 'package:flutter/material.dart';
import 'package:lix/app/color_select.dart';

TextStyle textStyleMedium(double fontSize) {
  return TextStyle(
      color: Colors.white,
      fontSize: fontSize,
      fontFamily: 'Intern',
      fontWeight: FontWeight.w500);
}

TextStyle textStyleMediumBlack(double fontSize) {
  return TextStyle(
      color: Colors.black,
      fontSize: fontSize,
      fontFamily: 'Intern',
      fontWeight: FontWeight.w500);
}

TextStyle expandableText(double fontSize) {
  return TextStyle(
      color: ColorSelect.lightBlack,
      fontSize: fontSize,
      fontFamily: 'Intern',
      height: 1.4,
      fontWeight: FontWeight.w500);
}

TextStyle customFontRegular(double fontSize, Color colorType) {
  return TextStyle(
      color: colorType,
      fontSize: fontSize,
      fontFamily: 'Intern',
      fontWeight: FontWeight.w400);
}

TextStyle textStyleRegular(double fontSize) {
  return TextStyle(
      color: Colors.white,
      fontSize: fontSize,
      fontFamily: 'Intern',
      fontWeight: FontWeight.w400);
}

TextStyle textStyleRegularBlack(double fontSize) {
  return TextStyle(
      color: Colors.black,
      fontSize: fontSize,
      fontFamily: 'Intern',
      fontWeight: FontWeight.w400);
}

TextStyle textStyleBoldBlack(double fontSize) {
  return TextStyle(
      color: ColorSelect.lightBlack,
      fontSize: fontSize,
      fontFamily: 'Intern',
      fontWeight: FontWeight.w600);
}

TextStyle textStyleValidation(double fontSize) {
  return TextStyle(
      color: ColorSelect.alertOrange,
      fontSize: fontSize,
      fontFamily: 'Intern',
      fontWeight: FontWeight.w400);
}

TextStyle textStyleViewAll(double fontSize) {
  return TextStyle(
      color: ColorSelect.appThemeOrange,
      fontSize: fontSize,
      fontFamily: 'Intern',
      fontWeight: FontWeight.w600);
}

TextStyle textStyleLine(double fontSize) {
  return TextStyle(
    color: ColorSelect.greyDark,
    fontSize: fontSize,
    fontFamily: 'Intern',
    fontWeight: FontWeight.w400,
    decoration: TextDecoration.lineThrough,
  );
}

TextStyle buttonTextBold() {
  return const TextStyle(
      color: Colors.white,
      fontSize: 12.0,
      fontFamily: 'Intern',
      fontWeight: FontWeight.w600);
}
