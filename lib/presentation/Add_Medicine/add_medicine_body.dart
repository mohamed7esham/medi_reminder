import 'package:flutter/material.dart';
import 'package:medi_reminder/core/app/block/cubit.dart';
import 'package:medi_reminder/core/utils/app_values.dart';
import 'package:medi_reminder/core/utils/reusable_widgets/image_picker.dart';
import 'package:medi_reminder/presentation/Add_Medicine/Widgets/add_medi_button.dart';
import 'package:medi_reminder/presentation/Add_Medicine/Widgets/check_box_every_day.dart';
import 'package:medi_reminder/presentation/Add_Medicine/Widgets/date_picker.dart';
import 'package:medi_reminder/presentation/Add_Medicine/Widgets/field_medi_name.dart';
import 'package:medi_reminder/presentation/Add_Medicine/Widgets/time_picker.dart';

class AddMedicineWidget extends StatelessWidget {
  const AddMedicineWidget({super.key, required this.cubit});

  final MedicineCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: cubit.formKey,
        child: Column(
          children: [
            // 💊 Name
            FormFieldForMedicineName(cubit: cubit),

            SizedBox(height: AppHeight.h20),

            // 📅 Date Picker
            DatePicker(cubit: cubit),

            SizedBox(height: AppHeight.h12),

            // ⏰ Time Picker
            TimePicker(cubit: cubit),

            SizedBox(height: AppHeight.h30),
            // 🔁 Every Day Checkbox
            CheckBoxEveryDay(cubit: cubit),

            SizedBox(height: AppHeight.h30),

            ImagePickerSection(
              imagePath: cubit.imagePath,
              onImageSelected: (path) {
                cubit.changeImage(path);
              },
            ),

            // 💾 Save Button
            SaveButton(cubit: cubit),

            SizedBox(height: AppHeight.h30),
          ],
        ),
      ),
    );
  }
}
