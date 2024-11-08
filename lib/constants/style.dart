import 'package:flutter/material.dart';
import 'colors.dart';

class MyTextStyle {
  static const String robotoFamily = "Roboto";

  static const header = TextStyle(
    fontFamily: robotoFamily,
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: MyColors.whiteColor,
  );

  static var emptyHome = TextStyle(
    fontFamily: robotoFamily,
    fontSize: 28, 
    color: MyColors.greyColor
  );
}