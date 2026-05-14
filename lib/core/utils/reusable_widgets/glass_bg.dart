import 'dart:ui';
import 'package:flutter/material.dart';

class GlassBackground extends StatelessWidget {
  final Widget child; //  علشان نقدر نحط محتوى الصفحة فوق الخلفية

  const GlassBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        //  خلفية التدرج
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFdfe9f3), Color(0xFFffffff)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),

        // 🔵 دوائر ضبابية
        Positioned(
          top: -60,
          left: -40,
          child: _blurredCircle(250, Colors.pinkAccent.withValues(alpha: 0.3)),
        ),
        Positioned(
          bottom: -80,
          right: -60,
          child: _blurredCircle(
            280,
            Colors.lightBlueAccent.withValues(alpha: 0.3),
          ),
        ),

        // 🌫️ طبقة الزجاج
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
          child: Container(color: Colors.white.withValues(alpha: 0.25)),
        ),

        //  محتوى الصفحة فوق الخلفية
        child,
      ],
    );
  }

  Widget _blurredCircle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.5),
            blurRadius: 100,
            spreadRadius: 40,
          ),
        ],
      ),
    );
  }
}
