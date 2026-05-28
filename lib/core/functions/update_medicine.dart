import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:medi_reminder/core/app/block/cubit.dart';
import 'package:medi_reminder/core/functions/medicine_datetime.dart';
import 'package:medi_reminder/model/medicine.dart';
import 'package:medi_reminder/services/alarm_service.dart';
import 'package:medi_reminder/services/database_helper.dart';

class UpdateMedicine {
  static Future<void> execute(
    MedicineCubit cubit,
    BuildContext context,
    int medicineId,
  ) async {
    try {
      cubit.setLoading();

      final updatedMedicine = Medicine(
        id: medicineId,
        name: cubit.nameController.text.trim(),
        date: cubit.selectedDate.toIso8601String().split('T')[0],
        time: cubit.selectedTime!.format(context),
        repeatDaily: cubit.repeatDaily,
        imagePath: cubit.imagePath,
      );

      await DBHelper.updateMedicine(updatedMedicine);

      final alarms = await Alarm.getAlarms();

      if (alarms.any((a) => a.id == medicineId)) {
        await Alarm.stop(medicineId);
      }

      final scheduledDateTime = MedicineDateTime.build(
        date: cubit.selectedDate,
        time: cubit.selectedTime!,
        repeatDaily: cubit.repeatDaily,
      );

      await AlarmService.schedule(
        id: medicineId,
        title: "Medicine Reminder 💊",
        body: "Take ${updatedMedicine.name}",
        dateTime: scheduledDateTime,
        repeatDaily: cubit.repeatDaily,
      );

      await cubit.loadMedicines();

      cubit.setSuccess("Medicine Updated");

      if (context.mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      cubit.setError(e.toString());
    }
  }
}
