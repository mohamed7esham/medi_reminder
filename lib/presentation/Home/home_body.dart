import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi_reminder/core/app/block/cubit.dart';
import 'package:medi_reminder/core/app/block/medicine_state.dart';
import 'package:medi_reminder/model/medicine.dart';
import 'package:medi_reminder/presentation/Update_Medicine/edit_medicine_screen.dart';

class HomeBody extends StatelessWidget {
  final List<Medicine> medicines;

  const HomeBody({super.key, required this.medicines});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MedicineCubit, MedicineState>(
      builder: (context, state) {
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: medicines.length,
          itemBuilder: (context, index) {
            final medicine = medicines[index];

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

              child: ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditMedicineScreen(medicine: medicine),
                    ),
                  );
                },
                leading:
                    medicine.imagePath != null && medicine.imagePath!.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          File(medicine.imagePath!),
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) {
                            return const Icon(
                              Icons.medication,
                              color: Colors.pink,
                            );
                          },
                        ),
                      )
                    : const Icon(Icons.medication, color: Colors.pink),

                title: Text(
                  medicine.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),

                // 🔥 UPDATED
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      medicine.repeatDaily
                          ? "⏰ ${medicine.time} • Everyday"
                          : "⏰ ${medicine.time} • ${medicine.date}",
                    ),
                  ],
                ),

                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),

                  onPressed: () {
                    if (medicine.id != null) {
                      context.read<MedicineCubit>().deleteMedicine(
                        medicine.id!,
                      );
                    }
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}
