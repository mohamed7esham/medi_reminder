import 'package:flutter/material.dart';
import 'package:medi_reminder/core/app/block/cubit.dart';
import 'package:medi_reminder/model/medicine.dart';
import 'package:medi_reminder/services/database_helper.dart';

class UpdateMedicineButton extends StatelessWidget {
  const UpdateMedicineButton({
    super.key,
    required this.cubit,
    required this.medicine,
  });

  final MedicineCubit cubit;
  final Medicine medicine;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          await cubit.updateMedicine(context, medicine.id!);

          DBHelper.printAllMedicines();
          // DBHelper.clearDatabase(); //clear database for testing
        },
        child: const Text("Update Medicine"),
      ),
    );
  }
}
