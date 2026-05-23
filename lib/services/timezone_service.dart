import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/material.dart';

class TimezoneService {
  static Future<void> init() async {
    tz.initializeTimeZones();

    try {
      final timezone = await FlutterTimezone.getLocalTimezone();

      final String name = timezone.identifier;

      debugPrint("🌍 Timezone: $name");

      tz.setLocalLocation(tz.getLocation(name));
    } catch (e) {
      debugPrint("❌ Timezone error: $e");

      tz.setLocalLocation(tz.getLocation('Africa/Cairo'));
    }
  }

  static tz.TZDateTime convert(DateTime dateTime) {
    return tz.TZDateTime.from(dateTime, tz.local);
  }
}
