import 'package:flutter/material.dart';

class ImageLoader {
  static Image load(
    String assetName, {
    double? width,
    double? height,
    BoxFit? fit,
  }) {
    return Image.asset(
      'assets/imgs/$assetName',
      width: width,
      height: height,
      fit: fit,
    );
  }
}
