import 'package:flutter/material.dart';
import 'package:medi_reminder/presentation/Add_Medicine/add_medicine_screen.dart';

class AddMediButton extends StatelessWidget {
  const AddMediButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddMedicineScreen()),
        );
      },
      child: const Icon(Icons.add),
    );
  }
}
