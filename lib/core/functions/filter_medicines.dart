import 'package:medi_reminder/core/app/block/cubit.dart';

class FilterMedicines {
  static void execute(MedicineCubit cubit, DateTime date) {
    cubit.currentSelectedDate = date;

    final formatted = date.toIso8601String().split('T')[0];

    cubit.filteredMedicines = cubit.allMedicines.where((medicine) {
      return medicine.repeatDaily || medicine.date == formatted;
    }).toList();

    cubit.setLoaded(cubit.filteredMedicines);
  }
}
