import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:medi_reminder/presentation/MedicineAlarmScreen/medicine_alarm_screen.dart';
import 'package:medi_reminder/services/database_helper.dart';
import 'package:medi_reminder/services/navigator_key.dart';

class AlarmService {
  static bool _isAlarmOpen = false;
  static bool _initialized = false;

  // =========================
  // INIT LISTENER
  // =========================
  static void initListener() {
    debugPrint("🚀 Alarm Listener Init Called");

    if (_initialized) {
      debugPrint("⚠️ Listener already initialized");
      return;
    }

    _initialized = true;

    Alarm.ringing.listen((alarmSet) async {
      debugPrint("🔔 Alarm ringing event received");

      if (_isAlarmOpen) {
        debugPrint("⚠️ Alarm screen already open");
        return;
      }

      if (navigatorKey.currentState == null) {
        debugPrint("❌ navigatorKey.currentState is NULL");
        return;
      }

      if (alarmSet.alarms.isEmpty) {
        debugPrint("❌ No alarms inside alarmSet");
        return;
      }

      final alarm = alarmSet.alarms.first;

      debugPrint("✅ Alarm Found");
      debugPrint("🆔 Alarm ID: ${alarm.id}");
      debugPrint("🕒 Alarm Time: ${alarm.dateTime}");
      debugPrint("📢 Alarm Title: ${alarm.notificationSettings.title}");

      final medicine = await DBHelper.getMedicineById(alarm.id);

      if (medicine == null) {
        debugPrint("❌ Medicine NOT FOUND in database");
      } else {
        debugPrint("💊 Medicine Found");
        debugPrint("💊 Name: ${medicine.name}");
        debugPrint("🔁 Repeat Daily: ${medicine.repeatDaily}");
      }

      _isAlarmOpen = true;

      navigatorKey.currentState!.push(
        MaterialPageRoute(
          fullscreenDialog: true,
          builder: (_) => MedicineAlarmScreen(
            medicineName: alarm.notificationSettings.title,
            time: "Now",

            onTaken: () async {
              debugPrint("✅ TAKEN BUTTON PRESSED");

              await Alarm.stop(alarm.id);

              debugPrint("🛑 Alarm stopped");

              final medicine = await DBHelper.getMedicineById(alarm.id);

              if (medicine != null && medicine.repeatDaily) {
                debugPrint("🔁 Scheduling NEXT DAY alarm");

                final nextDay = alarm.dateTime.add(const Duration(days: 1));

                debugPrint("📅 Next Day Time: $nextDay");

                await AlarmService.schedule(
                  id: alarm.id,
                  title: alarm.notificationSettings.title,
                  body: alarm.notificationSettings.body,
                  dateTime: nextDay,
                  repeatDaily: true,
                );
              } else {
                debugPrint("⛔ Not repeatDaily -> no next alarm");
              }

              _close();
            },

            onSkip: () async {
              debugPrint("⏭️ SKIP BUTTON PRESSED");

              await Alarm.stop(alarm.id);

              debugPrint("🛑 Alarm stopped");

              final medicine = await DBHelper.getMedicineById(alarm.id);

              if (medicine != null && medicine.repeatDaily) {
                debugPrint("🔁 Scheduling NEXT DAY alarm");

                final nextDay = alarm.dateTime.add(const Duration(days: 1));

                debugPrint("📅 Next Day Time: $nextDay");

                await AlarmService.schedule(
                  id: alarm.id,
                  title: alarm.notificationSettings.title,
                  body: alarm.notificationSettings.body,
                  dateTime: nextDay,
                  repeatDaily: true,
                );
              } else {
                debugPrint("⛔ Not repeatDaily -> no next alarm");
              }

              _close();
            },
          ),
        ),
      );
    });
  }

  // =========================
  // CLOSE SCREEN
  // =========================
  static void _close() {
    debugPrint("❌ Closing Alarm Screen");

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
    bool repeatDaily = false,
    String? imagePath,
  }) async {
    debugPrint("=================================");
    debugPrint("📢 SCHEDULE FUNCTION CALLED");
    debugPrint("🆔 ID: $id");
    debugPrint("📢 TITLE: $title");
    debugPrint("🕒 DATE: $dateTime");
    debugPrint("🔁 REPEAT: $repeatDaily");
    debugPrint("=================================");

    try {
      await Alarm.stop(id);

      debugPrint("🛑 Old alarm removed");

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

      debugPrint("✅ Alarm Successfully Scheduled");

      final alarms = await Alarm.getAlarms();

      debugPrint("📦 TOTAL ALARMS: ${alarms.length}");

      for (final alarm in alarms) {
        debugPrint("⏰ Alarm -> ID:${alarm.id} | Time:${alarm.dateTime}");
      }
    } catch (e) {
      debugPrint("❌ FAILED TO SCHEDULE");
      debugPrint("❌ ERROR: $e");
    }
  }

  // =========================
  // SCHEDULE NEXT DAY
  // =========================
  static Future<void> scheduleNextDay({
    required int id,
    required String title,
    required String body,
    required DateTime currentDate,
  }) async {
    debugPrint("🔁 scheduleNextDay CALLED");

    final nextDay = currentDate.add(const Duration(days: 1));

    debugPrint("📅 NEXT DAY: $nextDay");

    await schedule(
      id: id,
      title: title,
      body: body,
      dateTime: nextDay,
      repeatDaily: true,
    );
  }
}
