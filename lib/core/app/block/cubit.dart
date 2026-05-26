import 'dart:async';

import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi_reminder/model/medicine.dart';
import 'package:medi_reminder/services/alarm_service.dart';
import 'package:medi_reminder/services/database_helper.dart';
import 'package:medi_reminder/core/app/block/medicine_state.dart';

class MedicineCubit extends Cubit<MedicineState> {
  MedicineCubit() : super(MedicineInitial());

  List<Medicine> allMedicines = [];

  // ================= LOAD =================

  Future<void> loadMedicines() async {
    emit(MedicineLoading());

    try {
      allMedicines = await DBHelper.getMedicines();
      // ✅ KEEP CURRENT FILTER
      filterByDate(currentSelectedDate);
      // emit(MedicineLoaded(allMedicines));
    } catch (e) {
      emit(MedicineError(e.toString()));
    }
  }

  // ================= FILTER =================
  DateTime currentSelectedDate = DateTime.now();
  List<Medicine> filteredMedicines = [];
  void filterByDate(DateTime date) {
    currentSelectedDate = date;
    final formatted = date.toIso8601String().split('T')[0];

    filteredMedicines = allMedicines.where((medicine) {
      return medicine.repeatDaily || medicine.date == formatted;
    }).toList();

    emit(MedicineLoaded(filteredMedicines));
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

      // ✅ Update DB
      await DBHelper.updateMedicine(updatedMedicine);

      // ✅ IMPORTANT:
      // remove old alarm first
      await Alarm.stop(medicineId);

      final scheduledDateTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        selectedTime!.hour,
        selectedTime!.minute,
      );

      // ✅ Schedule new updated alarm
      await AlarmService.schedule(
        id: medicineId,
        title: "Medicine Reminder 💊",
        body: "Take ${updatedMedicine.name}",
        dateTime: scheduledDateTime,
        repeatDaily: repeatDaily,
        imagePath: imagePath,
      );

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

  @override
  Future<void> close() {
    nameController.dispose();
    return super.close();
  }

  void clearForm() {
    nameController.clear();

    selectedDate = currentSelectedDate;

    selectedTime = null;

    repeatDaily = false;

    imagePath = null;

    emit(MedicineFormUpdated());
  }

  //================= Save =================
  Future<void> saveMedicine(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    if (selectedTime == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please select time")));
      return;
    }

    debugPrint("========== SAVE ==========");
    debugPrint("NAME: ${nameController.text}");
    debugPrint("REPEAT: $repeatDaily");
    debugPrint("DATE: $selectedDate");
    debugPrint("TIME: $selectedTime");

    final scheduledDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime!.hour,
      selectedTime!.minute,
    );

    if (scheduledDateTime.isBefore(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please choose future time")),
      );
      return;
    }

    try {
      emit(MedicineLoading());

      final medicine = Medicine(
        name: nameController.text.trim(),
        date: selectedDate.toIso8601String().split('T')[0],
        time: selectedTime!.format(context),
        repeatDaily: repeatDaily,
        imagePath: imagePath,
      );

      final id = await DBHelper.insertMedicine(medicine);

      await AlarmService.schedule(
        id: id,
        title: "Medicine Reminder 💊",
        body: "Take ${medicine.name}",
        dateTime: scheduledDateTime,
      );

      await loadMedicines();

      emit(MedicineSuccess("Medicine Added"));

      clearForm();

      if (context.mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      debugPrint("//////// SAVE ERROR: $e ////////////////");
      emit(MedicineError(e.toString()));
    }
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
