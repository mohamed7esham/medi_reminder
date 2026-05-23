import 'package:alarm/alarm.dart';
// import 'package:alarm/model/alarm_settings.dart';
import 'package:flutter/material.dart';
import 'package:medi_reminder/presentation/MedicineAlarmScreen/medicine_alarm_screen.dart';
import 'package:medi_reminder/services/navigator_key.dart';

class AlarmService {
  static bool _isAlarmOpen = false;
  static bool _initialized = false;

  // =========================
  // INIT LISTENER (CALL IN MAIN)
  // =========================
  static void initListener() {
    if (_initialized) return;
    _initialized = true;

    Alarm.ringing.listen((alarmSet) {
      if (_isAlarmOpen) return;
      if (navigatorKey.currentState == null) return;
      if (alarmSet.alarms.isEmpty) return;

      final alarm = alarmSet.alarms.first;

      _isAlarmOpen = true;

      navigatorKey.currentState!.push(
        MaterialPageRoute(
          fullscreenDialog: true,
          builder: (_) => MedicineAlarmScreen(
            medicineName: alarm.notificationSettings.title,
            time: "Now",

            onTaken: () async {
              await Alarm.stop(alarm.id);
              _close();
            },

            onSkip: () async {
              await Alarm.stop(alarm.id);
              _close();
            },
          ),
        ),
      );
    });
  }

  static void _close() {
    if (navigatorKey.currentState?.canPop() ?? false) {
      navigatorKey.currentState!.pop();
    }
    _isAlarmOpen = false;
  }

  // =========================
  // SCHEDULE ALARM
  // =========================
  static Future<void> schedule({
    required int id,
    required String title,
    required String body,
    required DateTime dateTime,
    // required tz.TZDateTime scheduledTime,
    bool repeatDaily = false,
    String? imagePath,
  }) async {
    final alarmSettings = AlarmSettings(
      id: id,
      dateTime: dateTime,

      assetAudioPath: 'assets/sounds/alarm.mp3',

      loopAudio: true,
      vibrate: true,

      androidFullScreenIntent: true,
      warningNotificationOnKill: true,
      androidStopAlarmOnTermination: false,
      allowAlarmOverlap: false,

      notificationSettings: NotificationSettings(
        title: title,
        body: body,
        stopButton: "Stop",
        icon: "notification_icon",
      ),
      volumeSettings: VolumeSettings.fixed(volume: 1.0),
    );

    await Alarm.set(alarmSettings: alarmSettings);
  }
}
