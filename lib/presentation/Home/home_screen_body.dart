import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi_reminder/core/app/block/cubit.dart';
import 'package:medi_reminder/core/app/block/medicine_state.dart';
import 'package:medi_reminder/core/utils/reusable_widgets/glass_bg.dart';
import 'package:medi_reminder/presentation/Home/widgets/medi_card_list.dart';
import 'package:medi_reminder/presentation/Home/home_body_no_medicine_added.dart';
import 'package:medi_reminder/presentation/Home/widgets/calender_line.dart';

class HomeScreenBody extends StatelessWidget {
  const HomeScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassBackground(
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
                  if (state is MedicineLoading && cubit.allMedicines.isEmpty) {
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
                  return MediCardList(medicines: medicines);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
