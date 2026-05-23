import 'dart:io';

import 'package:flutter/material.dart';
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
            padding: const EdgeInsets.all(24),

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

            child: const Icon(Icons.alarm, size: 90, color: Colors.red),
          ),
        ),

        const SizedBox(height: 35),

        // 💊 Title
        const Text(
          "Medicine Time!",
          style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 10),

        // 💊 Medicine Name
        Text(
          medicineName,
          textAlign: TextAlign.center,

          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),

        const SizedBox(height: 12),

        // ⏰ Time
        Text(time, style: TextStyle(fontSize: 22, color: Colors.grey.shade700)),

        const SizedBox(height: 35),

        // 🖼 Medicine Image
        if (imagePath != null)
          Hero(
            tag: imagePath!,

            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),

              child: Image.file(
                File(imagePath!),
                height: 240,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),

        const SizedBox(height: 45),

        // ✅ TAKE BUTTON
        SizedBox(
          width: double.infinity,
          height: 65,

          child: ElevatedButton.icon(
            onPressed: () async {
              VibrationService.stop();

              onTaken();
            },

            icon: const Icon(Icons.check_circle),

            label: const Text("I Took It", style: TextStyle(fontSize: 22)),

            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),

        // 😴 SNOOZE BUTTON
        SizedBox(
          width: double.infinity,
          height: 65,

          child: ElevatedButton.icon(
            onPressed: () async {
              await AudioService.stopAlarm();
              VibrationService.stop();

              debugPrint("😴 Snoozed 5 minutes");
              if (!context.mounted) return;
              Navigator.pop(context);
            },

            icon: const Icon(Icons.snooze),

            label: const Text("Snooze 5 Min", style: TextStyle(fontSize: 22)),

            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),

        // ❌ SKIP BUTTON
        SizedBox(
          width: double.infinity,
          height: 65,

          child: OutlinedButton.icon(
            onPressed: () async {
              await AudioService.stopAlarm();
              VibrationService.stop();

              onSkip();
            },

            icon: const Icon(Icons.close),

            label: const Text("Skip", style: TextStyle(fontSize: 22)),

            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red,
              side: const BorderSide(color: Colors.red, width: 2),

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
