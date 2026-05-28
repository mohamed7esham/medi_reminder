import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi_reminder/core/app/block/cubit.dart';
import 'package:medi_reminder/core/app/block/medicine_state.dart';
import 'package:medi_reminder/core/utils/app_values.dart';
import 'package:medi_reminder/model/medicine.dart';
import 'package:medi_reminder/presentation/Update_Medicine/edit_screen_body.dart';

class EditMedicineScreen extends StatefulWidget {
  const EditMedicineScreen({super.key, required this.medicine});

  final Medicine medicine;

  @override
  State<EditMedicineScreen> createState() => _EditMedicineScreenState();
}

class _EditMedicineScreenState extends State<EditMedicineScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MedicineCubit>().loadMedicineForEdit(widget.medicine);
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<MedicineCubit>();
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Medicine")),

      body: BlocBuilder<MedicineCubit, MedicineState>(
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.all(AppSize.s16),
            child: Form(
              key: cubit.formKey,
              child: EditScreenBody(cubit: cubit, medicine: widget.medicine),
            ),
          );
        },
      ),
    );
  }
}
