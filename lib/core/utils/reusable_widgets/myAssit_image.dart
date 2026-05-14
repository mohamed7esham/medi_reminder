// ignore_for_file: file_names

import 'package:flutter/material.dart';

class MyAssetImage extends StatelessWidget {
  final String image;
  final String extension; // default image extension
  final double? width; // optional width
  final double? height; // optional height

  const MyAssetImage({
    super.key,
    required this.image,
    this.width,
    this.height,
    this.extension = 'png', // allow overriding the extension
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/$image.$extension',
      fit: BoxFit.cover,
      width: width ?? double.infinity,
    );
  }
}
