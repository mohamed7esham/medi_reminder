import 'package:flutter/material.dart';
import 'package:medi_reminder/core/app/block/cubit.dart';

class TimePicker extends StatelessWidget {
  const TimePicker({super.key, required this.cubit});

  final MedicineCubit cubit;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      tileColor: Colors.grey.shade200,
      title: Text(cubit.selectedTimeText),
      trailing: const Icon(Icons.access_time),
      onTap: () async {
        await cubit.pickTime(context);
      },
    );
  }
}
