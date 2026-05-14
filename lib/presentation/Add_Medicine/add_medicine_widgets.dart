import 'package:flutter/material.dart';
import 'package:medi_reminder/core/app/block/cubit.dart';
import 'package:medi_reminder/core/utils/reusable_widgets/image_picker.dart';
import 'package:medi_reminder/services/database_helper.dart';

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
            TextFormField(
              controller: cubit.nameController,
              decoration: const InputDecoration(
                labelText: "Medicine Name",
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Enter medicine name";
                }
                return null;
              },
            ),

            const SizedBox(height: 20),

            // 📅 Date Picker
            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              tileColor: Colors.grey.shade200,
              title: Text(
                "Date: ${cubit.selectedDate.toLocal().toString().split(' ')[0]}",
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => cubit.pickDate(context),
            ),

            const SizedBox(height: 12),

            // ⏰ Time Picker
            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              tileColor: Colors.grey.shade200,
              title: Text(cubit.selectedTimeText(context)),
              trailing: const Icon(Icons.access_time),
              onTap: () => cubit.pickTime(context),
            ),

            const SizedBox(height: 30),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,

              title: const Text("Repeat everyday"),

              subtitle: const Text("Enable for daily medicine reminders"),

              value: cubit.repeatDaily,

              onChanged: (value) {
                cubit.changeRepeat(value ?? false);
              },
            ),
            const SizedBox(height: 30),
            ImagePickerSection(
              imagePath: cubit.imagePath,
              onImageSelected: (path) {
                cubit.changeImage(path);
              },
            ),

            // 💾 Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  cubit.saveMedicine(context);
                  DBHelper.printAllMedicines();
                },
                child: const Text("Save Medicine"),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
