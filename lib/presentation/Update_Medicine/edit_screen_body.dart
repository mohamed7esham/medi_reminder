import 'dart:io';
import 'package:flutter/material.dart';
import 'package:medi_reminder/core/app/block/cubit.dart';
import 'package:medi_reminder/core/utils/app_values.dart';
import 'package:medi_reminder/model/medicine.dart';
import 'package:medi_reminder/core/utils/reusable_widgets/check_box_every_day.dart';
import 'package:medi_reminder/core/utils/reusable_widgets/date_picker.dart';
import 'package:medi_reminder/core/utils/reusable_widgets/field_medi_name.dart';
import 'package:medi_reminder/core/utils/reusable_widgets/time_picker.dart';
import 'package:medi_reminder/presentation/Update_Medicine/Widgets/update_medicine_button.dart';

class EditScreenBody extends StatelessWidget {
  const EditScreenBody({
    super.key,
    required this.cubit,
    required this.medicine,
  });

  final MedicineCubit cubit;
  final Medicine medicine;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 💊 NAME
          FormFieldForMedicineName(cubit: cubit),

          SizedBox(height: AppHeight.h20),

          // 📅 DATE
          DatePicker(cubit: cubit),

          SizedBox(height: AppHeight.h12),

          // ⏰ TIME
          TimePicker(cubit: cubit),

          SizedBox(height: AppHeight.h12),

          // 🔁 REPEAT DAILY
          CheckBoxEveryDay(cubit: cubit),

          SizedBox(height: AppHeight.h20),
          // 🖼️ IMAGE PREVIEW
          if (cubit.imagePath != null)
            Center(
              child: Image.file(
                File(cubit.imagePath!),
                height: AppHeight.h120,
                fit: BoxFit.cover,
              ),
            ),
          SizedBox(height: AppHeight.h20),

          // 💾 UPDATE BUTTON
          UpdateMedicineButton(cubit: cubit, medicine: medicine),
        ],
      ),
    );
  }
}
