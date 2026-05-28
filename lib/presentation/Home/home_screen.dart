import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi_reminder/core/app/block/cubit.dart';
import 'package:medi_reminder/presentation/Home/home_screen_body.dart';
import 'package:medi_reminder/presentation/Home/widgets/add_medi_float_button.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  @override
  void initState() {
    super.initState();
    context.read<MedicineCubit>().loadMedicines();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HomeScreenBody(),
      floatingActionButton: AddMediButton(),
    );
  }
}
