import 'package:alarm/alarm.dart';
// import 'package:alarm/model/alarm_settings.dart';
import 'package:flutter/material.dart';
import 'package:medi_reminder/presentation/MedicineAlarmScreen/medicine_alarm_screen.dart';
import 'package:medi_reminder/services/database_helper.dart';
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

    Alarm.ringing.listen((alarmSet) async {
      if (_isAlarmOpen) return;
      if (navigatorKey.currentState == null) return;
      if (alarmSet.alarms.isEmpty) return;

      final alarm = alarmSet.alarms.first;
      final medicine = await DBHelper.getMedicineById(alarm.id);

      _isAlarmOpen = true;

      if (medicine != null && medicine.repeatDaily) {
        await AlarmService.scheduleNextDay(
          id: alarm.id,
          title: alarm.notificationSettings.title,
          body: alarm.notificationSettings.body,
          currentDate: alarm.dateTime,
        );
      }

      navigatorKey.currentState!.push(
        MaterialPageRoute(
          fullscreenDialog: true,
          builder: (_) => MedicineAlarmScreen(
            medicineName: alarm.notificationSettings.title,
            time: "Now",

            onTaken: () async {
              await Alarm.stop(alarm.id);
              // CREATE NEXT DAY
              final medicine = await DBHelper.getMedicineById(alarm.id);

              if (medicine != null && medicine.repeatDaily) {
                final nextDay = alarm.dateTime.add(const Duration(days: 1));
                await AlarmService.schedule(
                  id: alarm.id,
                  title: alarm.notificationSettings.title,
                  body: alarm.notificationSettings.body,
                  dateTime: nextDay,
                  repeatDaily: true,
                );
              }
              _close();
            },

            onSkip: () async {
              await Alarm.stop(alarm.id);
              final medicine = await DBHelper.getMedicineById(alarm.id);

              if (medicine != null && medicine.repeatDaily) {
                final nextDay = alarm.dateTime.add(const Duration(days: 1));
                await AlarmService.schedule(
                  id: alarm.id,
                  title: alarm.notificationSettings.title,
                  body: alarm.notificationSettings.body,
                  dateTime: nextDay,
                  repeatDaily: true,
                );
              }
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
    // 🔥 ALWAYS REMOVE OLD ALARM FIRST
    await Alarm.stop(id);
    try {
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

      final alarms = await Alarm.getAlarms();

      debugPrint("TOTAL ALARMS: ${alarms.length}");
      debugPrint(
        "✅ Alarm Scheduled: $title at $dateTime | Repeat Daily: $repeatDaily",
      );

      for (final alarm in alarms) {
        debugPrint("⏰ Alarm ID: ${alarm.id} | Time: ${alarm.dateTime}");
      }
    } catch (e) {
      debugPrint("❌ Failed to schedule alarm: $e");
    }
  }

  // =========================scheduleNextDay=========================
  static Future<void> scheduleNextDay({
    required int id,
    required String title,
    required String body,
    required DateTime currentDate,
  }) async {
    final nextDay = currentDate.add(const Duration(days: 1));

    await schedule(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: title,
      body: body,
      dateTime: nextDay,
      repeatDaily: true,
    );
  }
}
