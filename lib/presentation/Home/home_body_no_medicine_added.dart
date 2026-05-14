import 'package:flutter/material.dart';
import 'package:medi_reminder/presentation/Add_Medicine/add_medicine_screen.dart';

class NoMedcinesInHomeScreenn extends StatelessWidget {
  const NoMedcinesInHomeScreenn({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 40),
        const Text("No medicines added yet 💊", style: TextStyle(fontSize: 18)),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddMedicineScreen()),
            );
          },
          child: Text("Add Medicine"),
        ),
      ],
    );
  }
}
