import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// import 'dart:io';

class ImageService {
  static final _picker = ImagePicker();

  static Future<String?> pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    debugPrint(
      "=================Image Picked: ${picked?.path}=================",
    );

    return picked?.path;
  }

  static Future<String?> takePhoto() async {
    final picked = await _picker.pickImage(source: ImageSource.camera);
    debugPrint(
      "=================Photo Taken: ${picked?.path}=================",
    );

    return picked?.path;
  }
}
