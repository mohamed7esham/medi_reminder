import 'package:flutter/material.dart';
import 'package:medi_reminder/core/utils/app_values.dart';
import 'package:medi_reminder/presentation/Add_Medicine/add_medicine_screen.dart';

class NoMedcinesInHomeScreenn extends StatelessWidget {
  const NoMedcinesInHomeScreenn({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: AppHeight.h40),
        Text(
          "No medicines added yet 💊",
          style: TextStyle(fontSize: AppSize.s18),
        ),
        SizedBox(height: AppHeight.h20),
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
