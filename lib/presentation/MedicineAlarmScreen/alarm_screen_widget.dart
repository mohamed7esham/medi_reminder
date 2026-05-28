import 'package:flutter/material.dart';
import 'package:medi_reminder/core/utils/app_values.dart';
import 'package:medi_reminder/presentation/MedicineAlarmScreen/widgets/animated_alarm_icon.dart';
import 'package:medi_reminder/presentation/MedicineAlarmScreen/widgets/medicine_image.dart';
import 'package:medi_reminder/presentation/MedicineAlarmScreen/widgets/skip_button.dart';
import 'package:medi_reminder/presentation/MedicineAlarmScreen/widgets/snooze_button.dart';
import 'package:medi_reminder/presentation/MedicineAlarmScreen/widgets/take_medicine_button.dart';

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
        AnimatedAlarmIcon(controllerValue: controllerValue),

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
        if (imagePath != null) MedicineImage(imagePath: imagePath),

        SizedBox(height: AppHeight.h45),

        // ✅ TAKE BUTTON
        TakeMedicineButton(onTaken: onTaken),

        SizedBox(height: AppHeight.h16),

        // 😴 SNOOZE BUTTON
        SnoozeButton(),

        SizedBox(height: AppHeight.h16),

        // ❌ SKIP BUTTON
        SkipButton(onSkip: onSkip),
      ],
    );
  }
}
