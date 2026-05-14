import 'dart:io';

import 'package:flutter/material.dart';

class MedicineAlarmScreen extends StatelessWidget {
  const MedicineAlarmScreen({
    super.key,
    required this.medicineName,
    required this.time,
    this.imagePath,
    required this.onTaken,
    required this.onSkip,
  });

  final String medicineName;
  final String time;
  final String? imagePath;

  final VoidCallback onTaken;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red.shade50,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              // 🔔 Alarm Icon
              Container(
                padding: const EdgeInsets.all(20),

                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  shape: BoxShape.circle,
                ),

                child: const Icon(Icons.alarm, size: 80, color: Colors.red),
              ),

              const SizedBox(height: 30),

              // 💊 Title
              const Text(
                "Medicine Time!",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              // 💊 Medicine Name
              Text(
                medicineName,
                textAlign: TextAlign.center,

                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 10),

              // ⏰ Time
              Text(
                time,
                style: TextStyle(fontSize: 20, color: Colors.grey.shade700),
              ),

              const SizedBox(height: 30),

              // 🖼 Medicine Image
              if (imagePath != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),

                  child: Image.file(
                    File(imagePath!),
                    height: 220,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),

              const SizedBox(height: 40),

              // ✅ Taken Button
              SizedBox(
                width: double.infinity,
                height: 60,

                child: ElevatedButton.icon(
                  onPressed: onTaken,

                  icon: const Icon(Icons.check_circle),

                  label: const Text(
                    "I Took It",
                    style: TextStyle(fontSize: 20),
                  ),

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ❌ Skip Button
              SizedBox(
                width: double.infinity,
                height: 60,

                child: OutlinedButton.icon(
                  onPressed: onSkip,

                  icon: const Icon(Icons.close),

                  label: const Text("Skip", style: TextStyle(fontSize: 20)),

                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red, width: 2),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
