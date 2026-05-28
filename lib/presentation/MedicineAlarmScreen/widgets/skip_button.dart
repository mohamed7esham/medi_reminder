import 'package:flutter/material.dart';
import 'package:medi_reminder/services/audio_service.dart';
import 'package:medi_reminder/core/utils/app_values.dart';
import 'package:medi_reminder/services/vibration_service.dart';

class SkipButton extends StatelessWidget {
  const SkipButton({super.key, required this.onSkip});

  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
    );
  }
}
