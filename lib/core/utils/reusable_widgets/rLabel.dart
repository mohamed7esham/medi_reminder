// ignore_for_file: file_names

import 'package:flutter/material.dart';

class MyLable extends StatelessWidget {
  final double fontsize;
  final double? left;
  final String text;
  const MyLable({
    super.key,
    required this.fontsize,
    required this.text,
    this.left,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomLeft,
      padding: EdgeInsets.only(left: left ?? 24),
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontsize,
          color: const Color.fromARGB(255, 108, 103, 103),
        ),
      ),
    );
  }
}
