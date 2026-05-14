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
  late MedicineCubit cubit;

  @override
  void initState() {
    super.initState();

    cubit = context.read<MedicineCubit>();
  }

  @override
  void dispose() {
    cubit.nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Medicine")),
      body: BlocConsumer<MedicineCubit, MedicineState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return SingleChildScrollView(child: AddMedicineWidget(cubit: cubit));
        },
      ),
    );
  }
}
