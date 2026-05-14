import 'dart:io';

import 'package:flutter/material.dart';
import 'package:medi_reminder/core/app/block/cubit.dart';
import 'package:medi_reminder/model/medicine.dart';
import 'package:medi_reminder/presentation/MedicineAlarmScreen/MedicineAlarmScreen.dart';
import 'package:medi_reminder/services/database_helper.dart';

class EditScreenWidget extends StatelessWidget {
  const EditScreenWidget({
    super.key,
    required this.cubit,
    required this.medicine,
  });

  final MedicineCubit cubit;
  final Medicine medicine;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 💊 NAME
        TextFormField(
          controller: cubit.nameController,
          decoration: const InputDecoration(
            labelText: "Medicine Name",
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Enter name";
            }
            return null;
          },
        ),

        const SizedBox(height: 20),

        // 📅 DATE
        ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          tileColor: Colors.grey.shade200,
          title: Text(
            "Date: ${cubit.selectedDate.toLocal().toString().split(' ')[0]}",
          ),
          trailing: const Icon(Icons.calendar_today),
          onTap: () => cubit.pickEditDate(context),
        ),

        const SizedBox(height: 12),

        // ⏰ TIME
        ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          tileColor: Colors.grey.shade200,
          title: Text(
            cubit.selectedTime == null
                ? "Select Time"
                : "Time: ${cubit.selectedTime!.format(context)}",
          ),
          trailing: const Icon(Icons.access_time),
          onTap: () => cubit.pickEditTime(context),
        ),

        const SizedBox(height: 12),

        // 🔁 REPEAT DAILY
        CheckboxListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text("Repeat everyday"),
          value: cubit.repeatDaily,
          onChanged: (value) {
            cubit.repeatDaily = value ?? false;
          },
        ),

        const SizedBox(height: 20),
        if (cubit.imagePath != null)
          Center(
            child: Image.file(
              File(cubit.imagePath!),
              height: 120,
              fit: BoxFit.cover,
            ),
          ),
        const SizedBox(height: 20),

        // 💾 UPDATE BUTTON
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MedicineAlarmScreen(
                    medicineName: "Panadol",
                    time: "8:00 PM",
                    imagePath: medicine.imagePath,

                    onTaken: () {
                      Navigator.pop(context);

                      debugPrint("✅ Medicine Taken");
                    },

                    onSkip: () {
                      Navigator.pop(context);

                      debugPrint("❌ Medicine Skipped");
                    },
                  ),
                ),
              );
              cubit.updateMedicineData(
                context: context,
                medicineId: medicine.id!,
              );
              if (!context.mounted) return;

              Navigator.pop(context);
              DBHelper.printAllMedicines();
              // DBHelper.clearDatabase(); //clear database for testing
            },
            child: const Text("Update Medicine"),
          ),
        ),
      ],
    );
  }
}
