import 'package:flutter/material.dart';
import 'package:medi_reminder/core/app/block/cubit.dart';

class DatePicker extends StatelessWidget {
  const DatePicker({super.key, required this.cubit});

  final MedicineCubit cubit;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      tileColor: Colors.grey.shade200,
      title: Text(
        "Date: ${cubit.selectedDate.toLocal().toString().split(' ')[0]}",
      ),
      trailing: const Icon(Icons.calendar_today),
      onTap: () => cubit.pickDate(context),
    );
  }
}
