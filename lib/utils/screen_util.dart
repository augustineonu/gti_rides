import 'package:flutter/material.dart';

List<MediaQueryData> testScreenSizes = const [
  MediaQueryData(size: Size(360, 800)), //Android Large
  MediaQueryData(size: Size(360, 640)), //Android Small
  MediaQueryData(size: Size(375, 667)), //iPhone 8
  MediaQueryData(size: Size(414, 736)), //iPhone 8 Plus
  MediaQueryData(size: Size(320, 568)), //iPhone SE
  MediaQueryData(size: Size(375, 812)), //iPhone 13 mini
  MediaQueryData(size: Size(390, 844)), //Iphone 14
  MediaQueryData(size: Size(393, 852)), //iPhone 14
  MediaQueryData(size: Size(430, 932)), //iPhone 14 Pro Max
  MediaQueryData(size: Size(428, 926)), //Iphone 14 plus
  MediaQueryData(size: Size(744, 1133)), //Ipad mini 8.3"
  MediaQueryData(size: Size(1440, 960)), //Surface Pro 8
  MediaQueryData(size: Size(834, 1194)), //Ipad Pro 11"
  MediaQueryData(size: Size(1024, 1366)), //Ipad Pro 12.9"
];

MediaQueryData getScreenSize(BuildContext context) {
  final double screenWidth = MediaQuery.of(context).size.width;
  final double screenHeight = MediaQuery.of(context).size.height;

  // You can define your logic here to select the appropriate screen size
  // based on the actual screen width and height.
  // For simplicity, I'll assume you want to choose a size closest to the device's dimensions.
  MediaQueryData selectedSize = testScreenSizes.first;
  double closestSizeDiff = double.infinity;

  for (var size in testScreenSizes) {
    final double diff = (size.size.width - screenWidth).abs() +
        (size.size.height - screenHeight).abs();
    if (diff < closestSizeDiff) {
      selectedSize = size;
      closestSizeDiff = diff;
    }
  }

  return selectedSize;
}


Future<void> prepareApp() async {}
