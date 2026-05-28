import 'package:alarm/alarm.dart';
import 'package:flutter/widgets.dart';
import 'package:medi_reminder/services/alarm_service.dart';
import 'package:medi_reminder/services/timezone_service.dart';
import 'package:permission_handler/permission_handler.dart';

class AppInitializer {
  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
    await TimezoneService.init();
    await Permission.notification.request();
    await Alarm.init();
    AlarmService.initListener();
    debugPrint("=================App Initialized=================");
  }
}
