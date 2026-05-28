import 'package:flutter/material.dart';
import 'package:medi_reminder/core/app/block/cubit.dart';
import 'package:medi_reminder/model/medicine.dart';

class LoadEditData {
  static void execute(MedicineCubit cubit, Medicine medicine) {
    cubit.nameController.text = medicine.name;

    cubit.selectedDate = DateTime.parse(medicine.date);

    cubit.repeatDaily = medicine.repeatDaily;

    cubit.imagePath = medicine.imagePath;

    debugPrint(
      "=================Loading edit data for medicine: ${medicine.id}=================",
    );

    final parts = medicine.time.split(' ');

    final hm = parts[0].split(':');

    int hour = int.parse(hm[0]);

    final minute = int.parse(hm[1]);

    if (parts.length > 1) {
      if (parts[1] == 'PM' && hour != 12) {
        hour += 12;
      }

      if (parts[1] == 'AM' && hour == 12) {
        hour = 0;
      }
    }

    cubit.selectedTime = TimeOfDay(hour: hour, minute: minute);

    cubit.setFormUpdated();
  }
}
