// import 'dart:io';

// import 'package:alarm/alarm.dart';
// import 'package:alarm/model/alarm_settings.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_timezone/flutter_timezone.dart';
// import 'package:medi_reminder/presentation/MedicineAlarmScreen/medicine_alarm_screen.dart';
// import 'package:timezone/data/latest.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;

// import 'navigator_key.dart';

// class NotificationService {
//   // =========================
//   // INIT
//   // =========================
//   static Future<void> init() async {
//     WidgetsFlutterBinding.ensureInitialized();

//     // INIT ALARM PACKAGE
//     await Alarm.init();

//     debugPrint("✅ Alarm package initialized");

//     // =========================
//     // TIMEZONE
//     // =========================
//     tz.initializeTimeZones();

//     try {
//       final timezone = await FlutterTimezone.getLocalTimezone();

//       final String currentTimeZone = timezone.identifier;

//       debugPrint("🌍 Device timezone: $currentTimeZone");

//       tz.setLocalLocation(tz.getLocation(currentTimeZone));

//       debugPrint("✅ Timezone initialized");
//     } catch (e) {
//       debugPrint("❌ Timezone error: $e");

//       tz.setLocalLocation(tz.getLocation('Africa/Cairo'));
//     }

//     // =========================
//     // LISTEN FOR ALARMS
//     // =========================
//     // Alarm.ringStream.stream.listen((alarmSettings) {
//     //   navigatorKey.currentState?.push(
//     //     MaterialPageRoute(
//     //       builder: (_) => MedicineAlarmScreen(
//     //         medicineName: alarmSettings.notificationSettings.title,
//     //         time: "Now",

//     //         onTaken: () async {
//     //           await Alarm.stop(alarmSettings.id);

//     //           navigatorKey.currentState?.pop();
//     //         },

//     //         onSkip: () async {
//     //           await Alarm.stop(alarmSettings.id);

//     //           navigatorKey.currentState?.pop();
//     //         },
//     //       ),
//     //     ),
//     //   );
//     // });
//   }

//   // =========================
//   // SCHEDULE ALARM
//   // =========================
//   static Future<void> scheduleNotification({
//     required int id,
//     required String title,
//     required String body,
//     required tz.TZDateTime scheduledTime,
//     bool repeatDaily = false,
//     String? imagePath,
//   }) async {
//     try {
//       debugPrint("📢 Scheduling REAL alarm...");
//       debugPrint("🕒 Time: $scheduledTime");

//       final alarmSettings = AlarmSettings(
//         id: id,

//         dateTime: scheduledTime,
//         androidStopAlarmOnTermination: false,

//         assetAudioPath: 'assets/sounds/alarm.mp3',
//         allowAlarmOverlap: false,
//         loopAudio: true,

//         vibrate: false, // We'll handle vibration manually for better control

//         volumeSettings: VolumeSettings.fade(
//           volume: 1.0,
//           fadeDuration: const Duration(seconds: 3),
//           volumeEnforced: true,
//         ),

//         androidFullScreenIntent: true,

//         warningNotificationOnKill: true,

//         notificationSettings: NotificationSettings(
//           title: title,
//           body: body,

//           stopButton: 'Stop',

//           icon: 'notification_icon',
//         ),
//       );

//       await Alarm.set(alarmSettings: alarmSettings);

//       debugPrint("✅ REAL alarm scheduled");
//     } catch (e) {
//       debugPrint("❌ Alarm scheduling failed: $e");
//     }
//   }
// }

// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter_timezone/flutter_timezone.dart';
// import 'package:medi_reminder/presentation/MedicineAlarmScreen/medicine_alarm_screen.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:timezone/data/latest.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;

// import 'navigator_key.dart';

// class NotificationService {
//   static final FlutterLocalNotificationsPlugin _notifications =
//       FlutterLocalNotificationsPlugin();

//   // =========================
//   // INIT
//   // =========================
//   static Future<void> init() async {
//     // ANDROID SETTINGS
//     const AndroidInitializationSettings androidSettings =
//         AndroidInitializationSettings('@mipmap/ic_launcher');

//     const InitializationSettings settings = InitializationSettings(
//       android: androidSettings,
//     );

//     // INITIALIZE NOTIFICATIONS
//     await _notifications.initialize(
//       settings: settings,

//       // 🔥 OPEN FULLSCREEN SCREEN WHEN NOTIFICATION IS PRESSED
//       onDidReceiveNotificationResponse: (NotificationResponse response) async {
//         navigatorKey.currentState?.push(
//           MaterialPageRoute(
//             builder: (_) => MedicineAlarmScreen(
//               medicineName: response.payload ?? "Medicine",
//               time: "Now",
//               imagePath: null,
//               onTaken: () {
//                 navigatorKey.currentState?.pop();
//               },
//               onSkip: () {
//                 navigatorKey.currentState?.pop();
//               },
//             ),
//           ),
//         );
//       },
//     );

//     debugPrint("✅ Notifications initialized");

//     // =========================
//     // TIMEZONE
//     // =========================
//     tz.initializeTimeZones();

//     try {
//       final TimezoneInfo info = await FlutterTimezone.getLocalTimezone();

//       final String currentTimeZone = info
//           .toString()
//           .split(',')
//           .first
//           .replaceAll('TimezoneInfo(', '');

//       debugPrint("🌍 Device timezone: $currentTimeZone");

//       tz.setLocalLocation(tz.getLocation(currentTimeZone));

//       debugPrint("✅ Timezone initialized");
//     } catch (e) {
//       debugPrint("❌ Timezone error: $e");

//       // FALLBACK
//       tz.setLocalLocation(tz.getLocation('Africa/Cairo'));
//     }

//     // =========================
//     // PERMISSIONS
//     // =========================
//     await requestPermissions();
//   }

//   // =========================
//   // REQUEST PERMISSIONS
//   // =========================
//   static Future<void> requestPermissions() async {
//     if (Platform.isAndroid) {
//       await Permission.notification.request();

//       await Permission.scheduleExactAlarm.request();
//     }
//   }

//   // =========================
//   // SCHEDULE NOTIFICATION
//   // =========================
//   static Future<void> scheduleNotification({
//     required int id,
//     required String title,
//     required String body,
//     required tz.TZDateTime scheduledTime,
//     bool repeatDaily = false,
//     String? imagePath,
//   }) async {
//     try {
//       debugPrint("📢 Scheduling notification...");
//       debugPrint("🕒 Time: $scheduledTime");

//       // REPEAT RULE
//       DateTimeComponents? repeatRule;

//       if (repeatDaily) {
//         repeatRule = DateTimeComponents.time;
//       }

//       // STYLE
//       final StyleInformation styleInformation = imagePath != null
//           ? BigPictureStyleInformation(
//               FilePathAndroidBitmap(imagePath),

//               contentTitle: '<b>💊 Medicine Time!</b>',
//               summaryText: body,

//               largeIcon: FilePathAndroidBitmap(imagePath),

//               htmlFormatContentTitle: true,
//               htmlFormatSummaryText: true,
//             )
//           : BigTextStyleInformation(
//               body,

//               contentTitle: '<b>💊 Medicine Time!</b>',

//               htmlFormatContentTitle: true,
//             );

//       // ANDROID DETAILS
//       final AndroidNotificationDetails androidDetails =
//           AndroidNotificationDetails(
//             'medicine_alarm_channel',
//             'Medicine Alarm',

//             channelDescription: 'Medicine Reminder Notifications',

//             importance: Importance.max,
//             priority: Priority.max,

//             ticker: 'Medicine Alarm',

//             category: AndroidNotificationCategory.alarm,

//             playSound: true,
//             enableVibration: true,

//             fullScreenIntent: true,

//             autoCancel: false,
//             ongoing: true,

//             visibility: NotificationVisibility.public,

//             styleInformation: styleInformation,
//           );

//       // SCHEDULE
//       await _notifications.zonedSchedule(
//         id: id,
//         title: title,
//         body: body,

//         payload: title,

//         androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,

//         matchDateTimeComponents: repeatRule,
//         scheduledDate: scheduledTime,
//         notificationDetails: NotificationDetails(android: androidDetails),
//       );

//       debugPrint("✅ Notification scheduled successfully");
//     } catch (e) {
//       debugPrint("❌ ERROR scheduling notification: $e");

//       // FALLBACK
//       try {
//         // await _notifications.zonedSchedule(
//         //   id: id,
//         //   title: title,
//         //   body: body,
//         //   scheduledDate: scheduledTime,

//         //   notificationDetails: NotificationDetails(
//         //     android: AndroidNotificationDetails(
//         //       'medicine_fallback_channel',
//         //       'Medicine Reminder',

//         //       importance: Importance.high,
//         //       priority: Priority.high,

//         //       playSound: true,
//         //       enableVibration: true,
//         //     ),
//         //   ),

//         //   androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
//         // );

//         debugPrint("✅ Fallback notification scheduled");
//       } catch (fallbackError) {
//         debugPrint("❌ Fallback failed: $fallbackError");
//       }
//     }
//   }

//   // =========================
//   // CANCEL ONE
//   // =========================
//   static Future<void> cancelNotification(int id) async {
//     await _notifications.cancel(id: id);
//   }

//   // =========================
//   // CANCEL ALL
//   // =========================
//   static Future<void> cancelAllNotifications() async {
//     await _notifications.cancelAll();
//   }
// }

// import 'dart:io';
// // import 'package:android_intent_plus/android_intent.dart';
// import 'package:medi_reminder/presentation/MedicineAlarmScreen/medicine_alarm_screen.dart';
// import 'package:timezone/data/latest.dart' as tz;
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter_timezone/flutter_timezone.dart';
// // import 'package:flutter_timezone/timezone_info.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:timezone/timezone.dart' as tz;
// import 'navigator_key.dart';

// class NotificationService {
//   static final FlutterLocalNotificationsPlugin _notifications =
//       FlutterLocalNotificationsPlugin();

//   static Future init() async {
//     const android = AndroidInitializationSettings('@mipmap/ic_launcher');

//     const settings = InitializationSettings(android: android);

//     // await _notifications.initialize(settings: settings);

//     debugPrint("✅ Notifications initialized");

//     tz.initializeTimeZones();
//     try {
//       final TimezoneInfo info = await FlutterTimezone.getLocalTimezone();

//       final String currentTimeZone = info
//           .toString()
//           .split(',')
//           .first
//           .replaceAll('TimezoneInfo(', '');

//       debugPrint("🌍 Device timezone: $currentTimeZone");

//       // SAFE: try to map it to timezone package
//       try {
//         tz.setLocalLocation(tz.getLocation(currentTimeZone));
//         debugPrint("✅ Using device timezone");
//       } catch (e) {
//         debugPrint("⚠️ Invalid timezone, fallback to local");
//         // fallback
//         tz.setLocalLocation(tz.local);
//       }

//       debugPrint("🌍 =-=-=-Timezone initialized: $currentTimeZone----------");

//       debugPrint("✅ NotificationService initialized");
//     } catch (e) {
//       debugPrint("❌ Failed to get timezone: $e");

//       // final fallback
//       tz.setLocalLocation(tz.local);
//     }
//     debugPrint("✅ NotificationService initialized");

//     await _notifications.initialize(
//       settings: settings,

//       onDidReceiveNotificationResponse: (response) async {
//         navigatorKey.currentState?.push(
//           MaterialPageRoute(
//             builder: (_) => MedicineAlarmScreen(
//               medicineName: response.payload ?? "Medicine",
//               time: "Now",
//               onTaken: () {},
//               onSkip: () {},
//             ),
//           ),
//         );
//       },
//     );
//   }

//   /// Request exact alarm permission (Android 12+)
//   static Future<bool> requestExactAlarmPermission() async {
//     if (Platform.isAndroid) {
//       final status = await Permission.scheduleExactAlarm.request();
//       return status.isGranted;
//     }
//     return true;
//   }

//   static Future scheduleNotification({
//     required int id,
//     required String title,
//     required String body,
//     required tz.TZDateTime scheduledTime,
//     bool repeatDaily = false,
//     String? imagePath,
//   }) async {
//     try {
//       final bool hasPermission = await requestExactAlarmPermission();

//       DateTimeComponents? repeatRule = repeatDaily
//           ? DateTimeComponents.time
//           : null;

//       final styleInformation = imagePath != null
//           ? BigPictureStyleInformation(
//               FilePathAndroidBitmap(imagePath),
//               contentTitle: title,
//               summaryText: body,
//               largeIcon: FilePathAndroidBitmap(imagePath),
//             )
//           : BigTextStyleInformation(body, contentTitle: title);

//       final androidDetails = AndroidNotificationDetails(
//         'medicine_alarm_channel',
//         'Medicine Alarm',
//         channelDescription: 'Medicine reminders',
//         ticker: 'Medicine Alarm',

//         importance: Importance.max,
//         priority: Priority.max,

//         // 🔥 Fullscreen alarm (may be blocked by system)
//         fullScreenIntent: true,
//         category: AndroidNotificationCategory.alarm,

//         playSound: true,
//         enableVibration: true,

//         autoCancel: false,
//         visibility: NotificationVisibility.public,
//         ongoing: true,

//         styleInformation: styleInformation,
//       );

//       // =============================
//       // 🚨 TRY FULLSCREEN FIRST
//       // =============================
//       try {
//         if (!hasPermission) {
//           throw Exception("Exact alarm permission not granted");
//         }

//         await _notifications.zonedSchedule(
//           id: id,
//           title: title,
//           body: body,
//           scheduledDate: scheduledTime,
//           notificationDetails: NotificationDetails(android: androidDetails),
//           payload: title,
//           androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//           matchDateTimeComponents: repeatRule,
//         );

//         debugPrint("✅ Fullscreen notification scheduled");
//       } catch (e) {
//         debugPrint("⚠️ Fullscreen failed → fallback: $e");

//         // =============================
//         // 🔻 FALLBACK NOTIFICATION
//         // =============================
//         await _notifications.zonedSchedule(
//           id: id,
//           title: title,
//           body: body,
//           scheduledDate: scheduledTime,
//           notificationDetails: NotificationDetails(android: androidDetails),
//           androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//           matchDateTimeComponents: repeatRule,
//         );

//         debugPrint("✅ Fallback notification scheduled");
//       }
//     } catch (e) {
//       debugPrint("❌ Scheduling failed completely: $e");
//     }
//   }
// }

// import 'dart:io';

// import 'package:android_intent_plus/android_intent.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter_timezone/flutter_timezone.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:timezone/data/latest.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;

// class NotificationService {
//   static final FlutterLocalNotificationsPlugin _notifications =
//       FlutterLocalNotificationsPlugin();

//   static Future init() async {
//     debugPrint("🚀 NotificationService INIT STARTED");

//     const android = AndroidInitializationSettings('@mipmap/ic_launcher');

//     const settings = InitializationSettings(android: android);

//     await _notifications.initialize(settings: settings);

//     debugPrint("✅ Flutter notifications initialized");

//     tz.initializeTimeZones();
//     try {
//       final TimezoneInfo info = await FlutterTimezone.getLocalTimezone();

//       final String currentTimeZone = info
//           .toString()
//           .split(',')
//           .first
//           .replaceAll('TimezoneInfo(', '');

//       debugPrint("🌍 Device timezone: $currentTimeZone");

//       // SAFE: try to map it to timezone package
//       try {
//         tz.setLocalLocation(tz.getLocation(currentTimeZone));
//         debugPrint("✅ Using device timezone");
//       } catch (e) {
//         debugPrint("⚠️ Invalid timezone, fallback to local");
//         // fallback
//         tz.setLocalLocation(tz.local);
//       }

//       debugPrint("🌍 =-=-=-Timezone initialized: $currentTimeZone----------");

//       debugPrint("✅ NotificationService initialized");
//     } catch (e) {
//       debugPrint("❌ Failed to get timezone: $e");

//       // final fallback
//       tz.setLocalLocation(tz.local);
//     }
//     debugPrint("✅ NotificationService initialized");
//   }

//   Future<void> requestExactAlarmPermission() async {
//     if (Platform.isAndroid) {
//       await Permission.scheduleExactAlarm.request();
//     }
//   }

//   static Future scheduleNotification({
//     required int id,
//     required String title,
//     required String body,
//     required tz.TZDateTime scheduledTime,
//     bool repeatDaily = false,
//     String? imagePath,
//   }) async {
//     debugPrint("📢 ---------------- DEBUG ----------------");
//     debugPrint("📢 ID: $id");
//     debugPrint("📢 Title: $title");
//     debugPrint("📢 Body: $body");
//     debugPrint("📢 Scheduled: $scheduledTime");

//     final style = imagePath != null
//         ? BigPictureStyleInformation(
//             FilePathAndroidBitmap(imagePath),

//             contentTitle: title,
//             summaryText: body,

//             largeIcon: FilePathAndroidBitmap(imagePath),
//           )
//         : BigTextStyleInformation(body, contentTitle: title);

//     try {
//       DateTimeComponents? repeatRule;
//       if (repeatDaily) {
//         repeatRule = DateTimeComponents.time;
//       }
//       await _notifications.zonedSchedule(
//         id: id,
//         title: title,
//         body: body,
//         scheduledDate: scheduledTime,

//         notificationDetails: NotificationDetails(
//           android: AndroidNotificationDetails(
//             'medicine_channell', //channelId
//             'Medicine Reminder', //channelName
//             channelDescription: 'Reminders for medicine time',

//             importance: Importance.max,
//             priority: Priority.high,
//             fullScreenIntent: true,
//             category: AndroidNotificationCategory.alarm,
//             playSound: true,
//             enableVibration: true,

//             visibility: NotificationVisibility.public,
//             ticker: 'Medicine Alarm',

//             styleInformation: style,
//           ),
//         ),

//         androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
//         // 🔥 ONLY repeat if checkbox enabled
//         matchDateTimeComponents: repeatRule,
//       );

//       debugPrint("✅ Notification scheduled successfully");
//     } catch (e) {
//       debugPrint("❌ ERROR scheduling notification: $e");
//     }
//   }
// }
