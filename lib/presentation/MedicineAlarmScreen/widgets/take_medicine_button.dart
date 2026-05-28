import 'package:flutter/material.dart';
import 'package:medi_reminder/core/utils/app_values.dart';
import 'package:medi_reminder/services/vibration_service.dart';

class TakeMedicineButton extends StatelessWidget {
  const TakeMedicineButton({super.key, required this.onTaken});

  final VoidCallback onTaken;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
    );
  }
}
