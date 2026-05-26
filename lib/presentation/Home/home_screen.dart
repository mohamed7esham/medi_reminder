import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi_reminder/core/app/block/cubit.dart';
import 'package:medi_reminder/core/app/block/medicine_state.dart';
import 'package:medi_reminder/presentation/Add_Medicine/add_medicine_screen.dart';
import 'package:medi_reminder/presentation/Home/home_body.dart';
import 'package:medi_reminder/presentation/Home/home_body_no_medicine_added.dart';
import '../../core/utils/reusable_widgets/glass_bg.dart';
import 'calender_line.dart';

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
      body: GlassBackground(
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              // SizedBox(height: 60),
              SliverToBoxAdapter(child: CalenderLine()),
              SliverToBoxAdapter(
                child: BlocConsumer<MedicineCubit, MedicineState>(
                  listener: (context, state) {
                    if (state is MedicineSuccess) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(state.message)));
                      context.read<MedicineCubit>().loadMedicines();
                    }

                    if (state is MedicineError) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(state.message)));
                    }
                  },

                  builder: (context, state) {
                    final cubit = context.read<MedicineCubit>();
                    // LOADING
                    if (state is MedicineLoading &&
                        cubit.allMedicines.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    // GET CURRENT LIST
                    final medicines = state is MedicineLoaded
                        ? state.medicines
                        : cubit.filteredMedicines;

                    // EMPTY
                    if (medicines.isEmpty) {
                      return const NoMedcinesInHomeScreenn();
                    }

                    // DATA
                    return HomeBody(medicines: medicines);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddMedicineScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
