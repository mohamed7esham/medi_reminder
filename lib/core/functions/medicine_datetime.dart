import 'package:flutter/material.dart';

class MedicineDateTime {
  static DateTime build({
    required DateTime date,
    required TimeOfDay time,
    required bool repeatDaily,
  }) {
    if (repeatDaily) {
      final now = DateTime.now();

      DateTime result = DateTime(
        now.year,
        now.month,
        now.day,
        time.hour,
        time.minute,
      );

      if (result.isBefore(now)) {
        result = result.add(const Duration(days: 1));
        debugPrint(
          "=================DateTime.isBefore(now)${result.isBefore(now)}=================",
        );
      }

      return result;
    }

    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }
}
