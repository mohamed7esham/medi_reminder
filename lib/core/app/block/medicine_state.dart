import 'package:medi_reminder/model/medicine.dart';

abstract class MedicineState {}

class MedicineInitial extends MedicineState {}

class MedicineLoading extends MedicineState {}

class MedicineLoaded extends MedicineState {
  final List<Medicine> medicines;

  MedicineLoaded(this.medicines);
}

class MedicineSuccess extends MedicineState {
  final String message;

  MedicineSuccess(this.message);
}

class MedicineError extends MedicineState {
  final String message;

  MedicineError(this.message);
}

class MedicineAdded extends MedicineState {}

class MedicineFormUpdated extends MedicineState {}
