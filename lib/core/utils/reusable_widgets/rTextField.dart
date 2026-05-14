// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../app_values.dart';

class MyTextField extends StatelessWidget {
  final String hintTextt;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final double? left_;
  final double? right_;
  final double? top_;
  final double? bottom_;
  final bool? autoFocus;
  final TextEditingController? controller;
  final Function()? onPress;
  final Function(String)? onChanged;
  const MyTextField({
    super.key,
    required this.hintTextt,
    this.obscureText = false,
    this.keyboardType,
    this.prefixIcon,
    this.left_,
    this.right_,
    this.top_,
    this.bottom_,
    this.onPress,
    this.autoFocus,
    this.controller,
    this.onChanged,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: left_ ?? AppWidth.w24,
        right: right_ ?? AppWidth.w24,
        top: top_ ?? AppHeight.h6,
        bottom: bottom_ ?? 0,
      ),
      child: SizedBox(
        width: double.infinity,
        height: AppHeight.h45,
        child: TextFormField(
          // text field bar
          controller: controller,
          autofocus: autoFocus ?? false,
          keyboardType: TextInputType.text,
          onTap: onPress,
          onChanged: onChanged,
          decoration: InputDecoration(
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            filled: true, // Required to enable background color
            fillColor: Color(0xffE7F4ED), // Set the desired background color
            contentPadding: EdgeInsets.only(
              left: AppWidth.w8,
              top: AppHeight.h8,
            ),
            hintText: hintTextt,
            hintStyle: const TextStyle(fontSize: 16, color: Color(0xffA7C7B8)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSize.s10),
              borderSide: BorderSide.none,
            ),
            // const OutlineInputBorder(
            //   borderSide: BorderSide(width: 2, color: Color(0xffe8e8e9)),
            // ),
            // focusedBorder: const OutlineInputBorder(
            //   borderSide: BorderSide(width: 2, color: Color(0xffe8e8e9)),
            // ),
            // enabledBorder: const OutlineInputBorder(
            //   borderSide: BorderSide(width: 2, color: Color(0xffe8e8e9)),
            // ),
          ),
        ),
      ),
    );
  }
}
