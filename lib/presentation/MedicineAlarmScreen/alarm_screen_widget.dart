import 'dart:io';

import 'package:flutter/material.dart';
import 'package:medi_reminder/core/utils/app_values.dart';
import 'package:medi_reminder/services/audio_service.dart';
import 'package:medi_reminder/services/vibration_service.dart';

class AlarmScreenWidget extends StatelessWidget {
  final String medicineName;
  final String time;
  final String? imagePath;
  final VoidCallback onTaken;
  final VoidCallback onSkip;
  final double controllerValue;

  const AlarmScreenWidget({
    super.key,
    required this.medicineName,
    required this.time,
    this.imagePath,
    required this.onTaken,
    required this.onSkip,
    required this.controllerValue,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 🔔 Animated Alarm Icon
        Transform.scale(
          scale: 1 + (controllerValue * 0.2),

          child: Container(
            padding: EdgeInsets.all(AppSize.s24),

            decoration: BoxDecoration(
              color: Colors.red.shade100,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.red.withValues(alpha: 0.4),
                  blurRadius: 25,
                  spreadRadius: 10,
                ),
              ],
            ),

            child: Icon(Icons.alarm, size: AppSize.s90, color: Colors.red),
          ),
        ),

        SizedBox(height: AppHeight.h35),

        // 💊 Title
        Text(
          "Medicine Time!",
          style: TextStyle(fontSize: FontSize.s34, fontWeight: FontWeight.bold),
        ),

        SizedBox(height: AppHeight.h10),

        // 💊 Medicine Name
        Text(
          medicineName,
          textAlign: TextAlign.center,

          style: TextStyle(
            fontSize: FontSize.s30,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),

        SizedBox(height: AppHeight.h12),

        // ⏰ Time
        Text(
          time,
          style: TextStyle(fontSize: FontSize.s22, color: Colors.grey.shade700),
        ),

        SizedBox(height: AppHeight.h35),

        // 🖼 Medicine Image
        if (imagePath != null)
          Hero(
            tag: imagePath!,

            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppSize.s24),

              child: Image.file(
                File(imagePath!),
                height: AppHeight.h240,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),

        SizedBox(height: AppHeight.h45),

        // ✅ TAKE BUTTON
        SizedBox(
          width: double.infinity,
          height: AppHeight.h65,

          child: ElevatedButton.icon(
            onPressed: () async {
              VibrationService.stop();

              onTaken();
            },

            icon: const Icon(Icons.check_circle),

            label: Text("I Took It", style: TextStyle(fontSize: FontSize.s22)),

            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSize.s18),
              ),
            ),
          ),
        ),

        SizedBox(height: AppHeight.h16),

        // 😴 SNOOZE BUTTON
        SizedBox(
          width: double.infinity,
          height: AppHeight.h65,

          child: ElevatedButton.icon(
            onPressed: () async {
              await AudioService.stopAlarm();
              VibrationService.stop();

              debugPrint("😴 Snoozed 5 minutes");
              if (!context.mounted) return;
              Navigator.pop(context);
            },

            icon: const Icon(Icons.snooze),

            label: Text(
              "Snooze 5 Min",
              style: TextStyle(fontSize: FontSize.s22),
            ),

            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSize.s18),
              ),
            ),
          ),
        ),

        SizedBox(height: AppHeight.h16),

        // ❌ SKIP BUTTON
        SizedBox(
          width: double.infinity,
          height: AppHeight.h65,

          child: OutlinedButton.icon(
            onPressed: () async {
              await AudioService.stopAlarm();
              VibrationService.stop();

              onSkip();
            },

            icon: const Icon(Icons.close),

            label: Text("Skip", style: TextStyle(fontSize: FontSize.s22)),

            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red,
              side: BorderSide(color: Colors.red, width: AppWidth.w2),

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSize.s18),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
