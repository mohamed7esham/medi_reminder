import 'dart:io';
import 'package:flutter/material.dart';
import 'package:medi_reminder/core/app/block/cubit.dart';
import 'package:medi_reminder/core/utils/app_values.dart';
import 'package:medi_reminder/model/medicine.dart';
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
    return SingleChildScrollView(
      child: Column(
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

          SizedBox(height: AppHeight.h20),

          // 📅 DATE
          ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSize.s12),
            ),
            tileColor: Colors.grey.shade200,
            title: Text(
              "Date: ${cubit.selectedDate.toLocal().toString().split(' ')[0]}",
            ),
            trailing: const Icon(Icons.calendar_today),
            onTap: () => cubit.pickDate(context),
          ),

          SizedBox(height: AppHeight.h12),

          // ⏰ TIME
          ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSize.s12),
            ),
            tileColor: Colors.grey.shade200,
            title: Text(
              cubit.selectedTime == null
                  ? "Select Time"
                  : "Time: ${cubit.selectedTime!.format(context)}",
            ),
            trailing: const Icon(Icons.access_time),
            onTap: () => cubit.pickTime(context),
          ),

          SizedBox(height: AppHeight.h12),

          // 🔁 REPEAT DAILY
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text("Repeat everyday"),
            value: cubit.repeatDaily,
            onChanged: (value) {
              cubit.changeRepeat(value!);
            },
          ),

          SizedBox(height: AppHeight.h20),
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
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                await cubit.updateMedicine(context, medicine.id!);

                DBHelper.printAllMedicines();
                // DBHelper.clearDatabase(); //clear database for testing
              },
              child: const Text("Update Medicine"),
            ),
          ),
        ],
      ),
    );
  }
}
