// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../../core/utils/app_values.dart';

class Pageviewcontent extends StatelessWidget {
  const Pageviewcontent({
    super.key,
    required this.imagePath,
    required this.title,
    required this.subTitle,
    this.widgetChild,
  });

  final String imagePath;
  final String title;
  final String subTitle;
  final Widget? widgetChild;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          fit: BoxFit.cover,
          imagePath,
          colorBlendMode: BlendMode.modulate,
          width: double.infinity,
          height: AppHeight.h250,
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(
            AppSize.s15,
            AppSize.s10,
            AppSize.s15,
            AppSize.s8,
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontSize: FontSize.s32,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              AppSize.s25,
              AppSize.s10,
              AppSize.s25,
              AppSize.s8,
            ),
            child: Column(
              children: [
                Text(
                  subTitle,
                  style: TextStyle(fontSize: FontSize.s20),
                  textAlign: TextAlign.center,
                ),
                widgetChild ?? Text(' '),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
