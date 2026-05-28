import 'package:alarm/alarm.dart';
import 'package:medi_reminder/core/app/block/cubit.dart';
import 'package:medi_reminder/services/database_helper.dart';

class DeleteMedicine {
  static Future<void> execute(MedicineCubit cubit, int id) async {
    try {
      await DBHelper.deleteMedicine(id);

      await Alarm.stop(id);

      await cubit.loadMedicines();

      cubit.setSuccess("===========Medicine Deleted=============");
    } catch (e) {
      cubit.setError(e.toString());
    }
  }
}
