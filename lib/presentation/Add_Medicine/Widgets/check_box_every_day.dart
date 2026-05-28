import 'package:flutter/material.dart';
import 'package:medi_reminder/core/app/block/cubit.dart';

class CheckBoxEveryDay extends StatelessWidget {
  const CheckBoxEveryDay({super.key, required this.cubit});

  final MedicineCubit cubit;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      contentPadding: EdgeInsets.zero,

      title: const Text("Repeat everyday"),

      subtitle: const Text("Enable for daily medicine reminders"),

      value: cubit.repeatDaily,

      onChanged: (value) {
        cubit.changeRepeat(value ?? false);
      },
    );
  }
}
