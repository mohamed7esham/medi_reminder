import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi_reminder/core/app/block/cubit.dart';
import 'package:medi_reminder/core/app/block/medicine_state.dart';
// import 'package:medi_reminder/core/utils/reusable_widgets/image_picker.dart';
import 'package:medi_reminder/presentation/Add_Medicine/add_medicine_widgets.dart';
// import 'package:medi_reminder/services/database_helper.dart';

class AddMedicineScreen extends StatefulWidget {
  const AddMedicineScreen({super.key});

  @override
  State<AddMedicineScreen> createState() => _AddMedicineScreenState();
}

class _AddMedicineScreenState extends State<AddMedicineScreen> {
  // late MedicineCubit cubit;
  @override
  void initState() {
    super.initState();

    context.read<MedicineCubit>().clearForm();
  }

  @override
  Widget build(BuildContext context) {
    MedicineCubit cubit = context.read<MedicineCubit>();
    return Scaffold(
      appBar: AppBar(title: const Text("Add Medicine")),
      body: BlocBuilder<MedicineCubit, MedicineState>(
        builder: (context, state) {
          return SingleChildScrollView(child: AddMedicineWidget(cubit: cubit));
        },
      ),
    );
  }
}
