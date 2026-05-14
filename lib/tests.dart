import 'dart:ui';
import 'package:flutter/material.dart';

class GlassBackground0 extends StatelessWidget {
  const GlassBackground0({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // خلفية بتدرج ناعم
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFdfe9f3), // أزرق فاتح
                  Color(0xFFffffff), // أبيض
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // 🔵 دائرة ضبابية كبيرة على الشمال فوق
          Positioned(
            top: -60,
            left: -40,
            child: _blurredCircle(
              250,
              Colors.pinkAccent.withValues(alpha: 0.3),
            ),
          ),

          // 🟢 دائرة ضبابية على اليمين تحت
          Positioned(
            bottom: -80,
            right: -60,
            child: _blurredCircle(
              280,
              Colors.lightBlueAccent.withValues(alpha: 0.3),
            ),
          ),

          // 🌫️ طبقة الزجاج (blur)
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
            child: Container(color: Colors.white.withValues(alpha: 0.3)),
          ),

          // 🩵 محتوى الصفحة
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    "Your Medicines\nReminder",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.black.withValues(alpha: 0.8),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // مثال على كارت واحد
                  _medicineCard(
                    title: "Paracetamol XL2",
                    subtitle: "150mg, 1 capsule",
                    colors: [Colors.pinkAccent, Colors.orangeAccent],
                  ),
                  _medicineCard(
                    title: "DPP-4 inhibitors",
                    subtitle: "150mg, 1 capsule",
                    colors: [Colors.tealAccent, Colors.lightBlueAccent],
                  ),
                  _medicineCard(
                    title: "Meglitinides",
                    subtitle: "150mg, 1 capsule",
                    colors: [Colors.yellowAccent, Colors.greenAccent],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🟠 دائرة ضبابية
  Widget _blurredCircle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.5),
            blurRadius: 100,
            spreadRadius: 40,
          ),
        ],
      ),
    );
  }

  // 💊 كارت الدواء
  Widget _medicineCard({
    required String title,
    required String subtitle,
    required List<Color> colors,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // الأيقونة (دائرة متدرجة)
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: colors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 16),
          // النص
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(color: Colors.grey[700], fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
//////// buttons to test notifications in home screen, not to be included in final code, just for testing purposes
// SliverToBoxAdapter(
//                 child: ElevatedButton(
//                   onPressed: () async {
//                     debugPrint("🧪 TZ TEST CLICKED");

//                     final scheduledTime = tz.TZDateTime.now(
//                       tz.local,
//                     ).add(const Duration(seconds: 10));

//                     debugPrint("📅 Scheduled TZ Time: $scheduledTime");
//                     debugPrint(
//                       "📅 Now TZ Time: ${tz.TZDateTime.now(tz.local)}",
//                     );

//                     await FlutterLocalNotificationsPlugin().zonedSchedule(
//                       id: 0,
//                       title: "Test Notification",
//                       body: "This is a test of TZ notifications",
//                       scheduledDate: scheduledTime,
//                       notificationDetails: const NotificationDetails(
//                         android: AndroidNotificationDetails(
//                           'test_channell',
//                           'Test Channel',
//                           channelDescription: 'Test TZ notifications',
//                           importance: Importance.max,
//                           priority: Priority.high,
//                         ),
//                       ),
//                       androidScheduleMode:
//                           scheduledTime.difference(
//                                 tz.TZDateTime.now(tz.local),
//                               ) <
//                               const Duration(minutes: 1)
//                           ? AndroidScheduleMode.inexactAllowWhileIdle
//                           : AndroidScheduleMode.exactAllowWhileIdle,
//                     );

//                     debugPrint("🧪 TZ TEST SENT");
//                   },
//                   child: const Text("Test TZ Notification"),
//                 ),
//               ),
//               SliverToBoxAdapter(
//                 child: ElevatedButton(
//                   onPressed: () async {
//                     debugPrint("🧪 FINAL TEST START good");

//                     await NotificationService.scheduleNotification(
//                       id: 90,
//                       title: "FINAL TEST",
//                       body: "If you see this → everything works",
//                       scheduledTime: tz.TZDateTime.now(
//                         tz.local,
//                       ).add(const Duration(minutes: 1)),
//                     );

//                     debugPrint("🧪 FINAL TEST SENT");
//                   },
//                   child: Text("FINAL TEST"),
//                 ),
//               ),
