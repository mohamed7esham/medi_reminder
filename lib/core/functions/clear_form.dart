import 'package:medi_reminder/core/app/block/cubit.dart';

class ClearForm {
  static void execute(MedicineCubit cubit) {
    cubit.nameController.clear();

    cubit.selectedDate = cubit.currentSelectedDate;

    cubit.selectedTime = null;

    cubit.repeatDaily = false;

    cubit.imagePath = null;

    cubit.setFormUpdated();
  }
}
