import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class VibrationService {
  static Timer? _timer;

  static void start() {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      HapticFeedback.heavyImpact();
    });
    debugPrint("=================Vibration Started=================");
  }

  static void stop() {
    _timer?.cancel();
    debugPrint("=================Vibration Stopped=================");
  }
}
