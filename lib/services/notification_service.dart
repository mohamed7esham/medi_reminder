import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static Future init() async {
    debugPrint("🚀 NotificationService INIT STARTED");

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');

    const settings = InitializationSettings(android: android);

    await _notifications.initialize(settings: settings);

    debugPrint("✅ Flutter notifications initialized");

    tz.initializeTimeZones();
    try {
      final TimezoneInfo info = await FlutterTimezone.getLocalTimezone();

      final String currentTimeZone = info
          .toString()
          .split(',')
          .first
          .replaceAll('TimezoneInfo(', '');

      debugPrint("🌍 Device timezone: $currentTimeZone");

      // SAFE: try to map it to timezone package
      try {
        tz.setLocalLocation(tz.getLocation(currentTimeZone));
        debugPrint("✅ Using device timezone");
      } catch (e) {
        debugPrint("⚠️ Invalid timezone, fallback to local");
        // fallback
        tz.setLocalLocation(tz.local);
      }

      debugPrint("🌍 =-=-=-Timezone initialized: $currentTimeZone----------");

      debugPrint("✅ NotificationService initialized");
    } catch (e) {
      debugPrint("❌ Failed to get timezone: $e");

      // final fallback
      tz.setLocalLocation(tz.local);
    }
    debugPrint("✅ NotificationService initialized");
  }

  static Future scheduleNotification({
    required int id,
    required String title,
    required String body,
    required tz.TZDateTime scheduledTime,
    bool repeatDaily = false,
    String? imagePath,
  }) async {
    debugPrint("📢 ---------------- DEBUG ----------------");
    debugPrint("📢 ID: $id");
    debugPrint("📢 Title: $title");
    debugPrint("📢 Body: $body");
    debugPrint("📢 Scheduled: $scheduledTime");

    final style = imagePath != null
        ? BigPictureStyleInformation(
            FilePathAndroidBitmap(imagePath),

            contentTitle: title,
            summaryText: body,

            largeIcon: FilePathAndroidBitmap(imagePath),
          )
        : BigTextStyleInformation(body, contentTitle: title);

    try {
      DateTimeComponents? repeatRule;
      if (repeatDaily) {
        repeatRule = DateTimeComponents.time;
      }
      await _notifications.zonedSchedule(
        id: id,
        title: title,
        body: body,
        scheduledDate: scheduledTime,

        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            'medicine_channell', //channelId
            'Medicine Reminder', //channelName
            channelDescription: 'Reminders for medicine time',

            importance: Importance.max,
            priority: Priority.high,
            fullScreenIntent: true,
            playSound: true,
            enableVibration: true,

            visibility: NotificationVisibility.public,

            styleInformation: style,
          ),
        ),

        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        // 🔥 ONLY repeat if checkbox enabled
        matchDateTimeComponents: repeatRule,
      );

      debugPrint("✅ Notification scheduled successfully");
    } catch (e) {
      debugPrint("❌ ERROR scheduling notification: $e");
    }
  }
}
