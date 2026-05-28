import 'package:medi_reminder/core/app/block/cubit.dart';
import 'package:medi_reminder/services/database_helper.dart';

class LoadMedicines {
  static Future<void> execute(MedicineCubit cubit) async {
    try {
      cubit.setLoading();

      cubit.allMedicines = await DBHelper.getMedicines();

      cubit.filterByDate(cubit.currentSelectedDate);
    } catch (e) {
      cubit.setError(e.toString());
    }
  }
}
