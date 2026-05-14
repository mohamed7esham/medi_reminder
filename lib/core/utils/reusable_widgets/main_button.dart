// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

class MainButton extends StatelessWidget {
  final dynamic onPressed;
  final String text;
  final Color textColor;
  final double height;
  final double width;
  final double radius;
  final Color buttonColor;
  final double? r_l_padding;
  const MainButton({
    super.key,
    required this.text,
    this.textColor = Colors.white,
    required this.height,
    this.width = double.infinity,
    required this.radius,
    required this.buttonColor,
    this.r_l_padding = 24,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(r_l_padding ?? 17, 10, r_l_padding ?? 17, 0),
      child: MaterialButton(
        elevation: 0, // Remove elevation or shadows button
        minWidth: width,
        height: height,
        onPressed: onPressed,
        color: buttonColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
