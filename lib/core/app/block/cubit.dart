import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi_reminder/model/medicine.dart';
import 'package:medi_reminder/services/database_helper.dart';
import 'package:medi_reminder/services/notification_service.dart';
import 'package:medi_reminder/core/app/block/medicine_state.dart';
import 'package:timezone/timezone.dart' as tz;

class MedicineCubit extends Cubit<MedicineState> {
  MedicineCubit() : super(MedicineInitial());

  List<Medicine> allMedicines = [];

  // ================= LOAD =================

  Future<void> loadMedicines() async {
    emit(MedicineLoading());

    try {
      allMedicines = await DBHelper.getMedicines();

      emit(MedicineLoaded(allMedicines));
    } catch (e) {
      emit(MedicineError(e.toString()));
    }
  }

  // ================= FILTER =================

  void filterByDate(DateTime date) {
    final formatted = date.toIso8601String().split('T')[0];

    final filtered = allMedicines
        .where((m) => m.repeatDaily || m.date == formatted)
        .toList();

    emit(MedicineLoaded(filtered));
  }

  // ================= ADD =================

  Future<void> addMedicine({
    required BuildContext context,
    required String name,
    required DateTime selectedDate,
    required TimeOfDay selectedTime,
    required bool repeatDaily,
    String? imagePath,
  }) async {
    try {
      emit(MedicineLoading());

      final formattedDate = selectedDate.toIso8601String().split('T')[0];

      final medicine = Medicine(
        name: name.trim(),
        date: formattedDate,
        time: selectedTime.format(context),
        repeatDaily: repeatDaily,
        imagePath: imagePath,
      );

      final id = await DBHelper.insertMedicine(medicine);

      final scheduledDateTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        selectedTime.hour,
        selectedTime.minute,
      );

      await NotificationService.scheduleNotification(
        id: id,
        title: "Medicine Reminder 💊",
        body: "Take ${medicine.name}",
        scheduledTime: tz.TZDateTime.from(scheduledDateTime, tz.local),
        repeatDaily: repeatDaily,
        imagePath: imagePath,
      );

      await loadMedicines();

      emit(MedicineSuccess("Medicine Added"));
    } catch (e) {
      emit(MedicineError(e.toString()));
    }
  }

  // ================= LOAD EDIT DATA =================

  void loadMedicineForEdit(BuildContext context, Medicine medicine) {
    nameController.text = medicine.name;

    selectedDate = DateTime.parse(medicine.date);

    repeatDaily = medicine.repeatDaily;

    imagePath = medicine.imagePath;

    // convert string -> TimeOfDay
    final parts = medicine.time.split(' ');
    final hm = parts[0].split(':');

    int hour = int.parse(hm[0]);

    final minute = int.parse(hm[1]);

    if (parts.length > 1) {
      if (parts[1] == 'PM' && hour != 12) {
        hour += 12;
      }

      if (parts[1] == 'AM' && hour == 12) {
        hour = 0;
      }
    }

    selectedTime = TimeOfDay(hour: hour, minute: minute);

    emit(MedicineFormUpdated());
  }

  // ================= UPDATE =================

  Future<void> updateMedicine(Medicine medicine) async {
    try {
      emit(MedicineLoading());

      await DBHelper.updateMedicine(medicine);

      await loadMedicines();

      emit(MedicineSuccess("Medicine Updated"));
    } catch (e) {
      emit(MedicineError(e.toString()));
    }
  }

  // ================= UPDATE MEDICINE =================

  Future<void> updateMedicineData({
    required BuildContext context,
    required int medicineId,
  }) async {
    if (!formKey.currentState!.validate() || selectedTime == null) {
      return;
    }

    try {
      emit(MedicineLoading());

      final updatedMedicine = Medicine(
        id: medicineId,
        name: nameController.text.trim(),
        date: selectedDate.toIso8601String().split('T')[0],
        time: selectedTime!.format(context),
        repeatDaily: repeatDaily,
        imagePath: imagePath,
      );

      await DBHelper.updateMedicine(updatedMedicine);

      await loadMedicines();

      emit(MedicineSuccess("Medicine Updated"));
    } catch (e) {
      emit(MedicineError(e.toString()));
    }
  }

  // ================= DELETE =================

  Future<void> deleteMedicine(int id) async {
    try {
      await DBHelper.deleteMedicine(id);

      await loadMedicines();

      emit(MedicineSuccess("Medicine Deleted"));
    } catch (e) {
      emit(MedicineError(e.toString()));
    }
  }

  final formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();

  DateTime selectedDate = DateTime.now();

  TimeOfDay? selectedTime;

  bool repeatDaily = false;

  String? imagePath;

  //================= Save =================
  Future<void> saveMedicine(BuildContext context) async {
    if (!formKey.currentState!.validate() || selectedTime == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please select time")));
      return;
    }

    final formattedDate = selectedDate.toIso8601String().split('T')[0];

    final medicine = Medicine(
      name: nameController.text.trim(),
      date: formattedDate,
      time: selectedTime!.format(context),
      repeatDaily: repeatDaily,
      imagePath: imagePath,
    );

    await addMedicine(
      context: context,
      name: context.read<MedicineCubit>().nameController.text,
      selectedDate: selectedDate,
      selectedTime: selectedTime!,
      repeatDaily: repeatDaily,
      imagePath: imagePath,
    );

    // 🔔 Schedule Notification
    final scheduledDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime!.hour,
      selectedTime!.minute,
    );

    if (scheduledDateTime.isBefore(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please choose a future time")),
      );
      return;
    }
    debugPrint("📡 Calling scheduleNotification...");
    NotificationService.scheduleNotification(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: "Medicine Reminder 💊",
      body: "Take ${medicine.name}",
      scheduledTime: tz.TZDateTime.from(scheduledDateTime, tz.local),
      repeatDaily: repeatDaily,
      imagePath: imagePath,
    );
    debugPrint("💊===========- SAVE BUTTON PRESSED");
    debugPrint("📅=============- Selected Date: $selectedDate");
    debugPrint("⏰=============- Selected Time: $selectedTime");
    Navigator.pop(context);
  }

  //================= pickDate =================
  Future<void> pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      selectedDate = picked;
      emit(MedicineFormUpdated());
    }
  }

  //================= pickTime =================
  Future<void> pickTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      selectedTime = picked;
      emit(MedicineFormUpdated());
    }
  }

  // ================= PICK EDIT DATE =================

  Future<void> pickEditDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2025), // Prevent selecting past dates during edit
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      selectedDate = picked;

      emit(MedicineFormUpdated());
    }
  }

  // ================= PICK EDIT TIME =================

  Future<void> pickEditTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );

    if (picked != null) {
      selectedTime = picked;

      emit(MedicineFormUpdated());
    }
  }

  //================= Form Updates checkbox =================
  void changeRepeat(bool value) {
    repeatDaily = value;

    emit(MedicineFormUpdated());
  }

  // ================= EDIT IMAGE =================
  void changeImage(String? path) {
    imagePath = path;

    emit(MedicineFormUpdated());
  }

  // ================= EDIT TEXT HELPERS =================
  String get selectedDateText =>
      "Date: ${selectedDate.toString().split(' ')[0]}";

  String selectedTimeText(BuildContext context) {
    if (selectedTime == null) {
      return "Select Time";
    }

    return "Time: ${selectedTime!.format(context)}";
  }
}

// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:medi_reminder/model/medicine.dart';
// import 'package:medi_reminder/services/database_helper.dart';

// class MedicineCubit extends Cubit<List<Medicine>> {
//   MedicineCubit() : super([]);

//   List<Medicine> allMedicines = [];

//   void loadMedicines() async {
//     allMedicines = await DBHelper.getMedicines();
//     emit(allMedicines);
//   }

//   void filterByDate(DateTime date) {
//     final formatted = date.toIso8601String().split('T')[0];

//     final filtered = allMedicines
//         .where((m) => m.repeatDaily || m.date == formatted)
//         .toList();
//     emit(filtered);
//   }

//   Future<int> addMedicine(Medicine medicine) async {
//     final id = await DBHelper.insertMedicine(medicine);

//     loadMedicines();

//     return id;
//   }

//   void deleteMedicine(int id) async {
//     await DBHelper.deleteMedicine(id);
//     loadMedicines();
//   }

//   // ✏️ Update medicine
//   void updateMedicine(Medicine medicine) async {
//     await DBHelper.updateMedicine(medicine);
//     loadMedicines();
//   }
// }
