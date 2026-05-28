import 'package:flutter/material.dart';
import 'package:medi_reminder/core/app/block/cubit.dart';
import 'package:medi_reminder/services/database_helper.dart';

class SaveButton extends StatelessWidget {
  const SaveButton({super.key, required this.cubit});

  final MedicineCubit cubit;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          cubit.addMedicine(context);
          DBHelper.printAllMedicines();
        },
        child: const Text("Save Medicine"),
      ),
    );
  }
}
