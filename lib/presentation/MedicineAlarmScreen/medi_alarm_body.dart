import 'package:flutter/material.dart';
import 'package:medi_reminder/core/utils/app_values.dart';
import 'package:medi_reminder/presentation/MedicineAlarmScreen/alarm_screen_widget.dart';
import 'package:medi_reminder/presentation/MedicineAlarmScreen/medicine_alarm_screen.dart';

class MedicineAlarmBody extends StatelessWidget {
  const MedicineAlarmBody({
    super.key,
    required this.controller,
    required this.widget,
  });

  final AnimationController controller;
  final MedicineAlarmScreen widget;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,

      builder: (context, child) {
        return Scaffold(
          backgroundColor: Color.lerp(
            Colors.red.shade50,
            Colors.red.shade200,
            controller.value,
          ),

          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(AppSize.s20),

              child: SingleChildScrollView(
                child: AlarmScreenWidget(
                  medicineName: widget.medicineName,
                  time: widget.time,
                  imagePath: widget.imagePath,
                  onTaken: widget.onTaken,
                  onSkip: widget.onSkip,
                  controllerValue: controller.value,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
