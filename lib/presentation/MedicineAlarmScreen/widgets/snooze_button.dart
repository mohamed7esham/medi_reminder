import 'package:flutter/material.dart';
import 'package:medi_reminder/core/utils/app_values.dart';
import 'package:medi_reminder/services/audio_service.dart';
import 'package:medi_reminder/services/vibration_service.dart';

class SnoozeButton extends StatelessWidget {
  const SnoozeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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

        label: Text("Snooze 5 Min", style: TextStyle(fontSize: FontSize.s22)),

        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSize.s18),
          ),
        ),
      ),
    );
  }
}
