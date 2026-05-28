import 'dart:io';

import 'package:flutter/material.dart';
import 'package:medi_reminder/core/utils/app_values.dart';

class MedicineImage extends StatelessWidget {
  const MedicineImage({super.key, required this.imagePath});

  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: imagePath!,

      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSize.s24),

        child: Image.file(
          File(imagePath!),
          height: AppHeight.h240,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
