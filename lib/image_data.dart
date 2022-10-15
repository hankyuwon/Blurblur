import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ImageData extends StatelessWidget {
  final double? width;
  String icon;
  ImageData(
      this.icon, {
        Key? key,
        this.width,
        Color? color,
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      icon,
      width: MediaQuery.of(context).size.height * 0.25,
      height: MediaQuery.of(context).size.height * 0.25,
    );
  }
}

class IconsPath {
  static String get shield => 'assets/images/green_shield.png';
}