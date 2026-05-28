import 'package:flutter/material.dart';
import 'package:medi_reminder/core/utils/app_values.dart';

class AnimatedAlarmIcon extends StatelessWidget {
  const AnimatedAlarmIcon({super.key, required this.controllerValue});

  final double controllerValue;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 1 + (controllerValue * 0.2),

      child: Container(
        padding: EdgeInsets.all(AppSize.s24),

        decoration: BoxDecoration(
          color: Colors.red.shade100,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.red.withValues(alpha: 0.4),
              blurRadius: 25,
              spreadRadius: 10,
            ),
          ],
        ),

        child: Icon(Icons.alarm, size: AppSize.s90, color: Colors.red),
      ),
    );
  }
}
