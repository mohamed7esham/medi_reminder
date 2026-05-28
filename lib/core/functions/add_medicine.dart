import 'package:flutter/material.dart';
import 'package:medi_reminder/core/app/block/cubit.dart';

import 'package:medi_reminder/core/functions/medicine_datetime.dart';
import 'package:medi_reminder/model/medicine.dart';
import 'package:medi_reminder/services/alarm_service.dart';
import 'package:medi_reminder/services/database_helper.dart';

class AddMedicine {
  static Future<void> execute(MedicineCubit cubit, BuildContext context) async {
    if (!cubit.formKey.currentState!.validate()) {
      debugPrint(
        "=============!cubit.formKey.currentState!.validate(): ${!cubit.formKey.currentState!.validate()}============",
      );
      return;
    }

    if (cubit.selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select a time ⏰"),
          backgroundColor: Colors.red,
        ),
      );
      debugPrint(
        "=================cubit.selectedTime is null=================",
      );
      return;
    }

    try {
      cubit.setLoading();

      final medicine = Medicine(
        name: cubit.nameController.text.trim(),
        date: cubit.selectedDate.toIso8601String().split('T')[0],
        time: cubit.selectedTime!.format(context),
        repeatDaily: cubit.repeatDaily,
        imagePath: cubit.imagePath,
      );

      final id = await DBHelper.insertMedicine(medicine);

      final scheduledDateTime = MedicineDateTime.build(
        date: cubit.selectedDate,
        time: cubit.selectedTime!,
        repeatDaily: cubit.repeatDaily,
      );

      await AlarmService.schedule(
        id: id,
        title: "Medicine Reminder 💊",
        body: "Take ${medicine.name}",
        dateTime: scheduledDateTime,
        repeatDaily: cubit.repeatDaily,
      );

      await cubit.loadMedicines();

      cubit.setSuccess("Medicine Added");

      cubit.clearForm();

      if (context.mounted) {
        Navigator.pop(context);
        debugPrint("=================returnFromPage=================");
      }
    } catch (e) {
      cubit.setError(e.toString());
      debugPrint("=================Error: ${e.toString()}=================");
    }
  }
}
