import 'package:flutter/material.dart';
import 'package:medi_reminder/core/app/block/cubit.dart';

class PickDate {
  static Future<void> execute(MedicineCubit cubit, BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: cubit.selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      cubit.selectedDate = picked;
      debugPrint("=================datePiked=================");

      cubit.emitFormUpdate();
    }
  }
}
