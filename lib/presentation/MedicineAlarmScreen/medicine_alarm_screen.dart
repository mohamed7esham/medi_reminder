import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi_reminder/core/app/block/cubit.dart';
import 'package:medi_reminder/core/app/block/medicine_state.dart';
import 'package:medi_reminder/presentation/MedicineAlarmScreen/medi_alarm_body.dart';
import 'package:medi_reminder/services/audio_service.dart';
import 'package:medi_reminder/services/vibration_service.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class MedicineAlarmScreen extends StatefulWidget {
  const MedicineAlarmScreen({
    super.key,
    required this.medicineName,
    required this.time,
    this.imagePath,
    required this.onTaken,
    required this.onSkip,
  });

  final String medicineName;
  final String time;
  final String? imagePath;

  final VoidCallback onTaken;
  final VoidCallback onSkip;

  @override
  State<MedicineAlarmScreen> createState() => _MedicineAlarmScreenState();
}

class _MedicineAlarmScreenState extends State<MedicineAlarmScreen>
    with SingleTickerProviderStateMixin {
  late MedicineCubit cubit;
  late AnimationController controller;
  // late AudioPlayer player;

  // final AudioPlayer player = AudioPlayer();

  // Timer? vibrationTimer;

  @override
  void initState() {
    super.initState();
    cubit = context.read<MedicineCubit>();
    WakelockPlus.enable();
    // 🔥 Flash animation
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    // 🔊 Play alarm sound
    AudioService.playAlarm();
    VibrationService.start();

    // 📳 Vibrate continuously

    // 🔒 Full immersive mode
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    AudioService.stopAlarm();
    VibrationService.stop();

    controller.dispose();

    VibrationService.stop();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    WakelockPlus.disable();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,

      child: BlocBuilder<MedicineCubit, MedicineState>(
        builder: (context, state) {
          return MedicineAlarmBody(controller: controller, widget: widget);
        },
      ),
    );
  }
}
