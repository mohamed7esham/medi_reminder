import 'package:flutter/material.dart';
import 'package:medi_reminder/core/app/block/cubit.dart';

class PickTime {
  static Future<void> execute(MedicineCubit cubit, BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      cubit.selectedTime = picked;
      debugPrint("=================timePiked=================");

      cubit.emitFormUpdate();
    }
  }
}
