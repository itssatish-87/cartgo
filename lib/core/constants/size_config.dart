import 'package:flutter/material.dart';

class SizeConfig {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;

  static late double blockWidth;     // 1% width
  static late double blockHeight;    // 1% height

  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;

    blockWidth = screenWidth / 100;
    blockHeight = screenHeight / 100;
  }

  // Responsive font
  static double font(double size) {
    return blockWidth * size;
  }

  // Responsive width
  static double w(double widthPercent) {
    return blockWidth * widthPercent;
  }

  // Responsive height
  static double h(double heightPercent) {
    return blockHeight * heightPercent;
  }
}
