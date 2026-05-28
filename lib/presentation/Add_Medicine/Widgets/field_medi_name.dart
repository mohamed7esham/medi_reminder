import 'package:flutter/material.dart';
import 'package:medi_reminder/core/app/block/cubit.dart';

class FormFieldForMedicineName extends StatelessWidget {
  const FormFieldForMedicineName({super.key, required this.cubit});

  final MedicineCubit cubit;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
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
    );
  }
}
