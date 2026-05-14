import 'package:flutter/material.dart';

extension GetDeviceHeight on BuildContext {
  double get height => MediaQuery.of(this).size.height;
}

extension GetDeviceWidth on BuildContext {
  double get width => MediaQuery.of(this).size.width;
}
