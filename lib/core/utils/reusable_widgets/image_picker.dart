import 'dart:io';

import 'package:flutter/material.dart';
import 'package:medi_reminder/services/image_service.dart';

class ImagePickerSection extends StatelessWidget {
  final String? imagePath;
  final Function(String?) onImageSelected;

  const ImagePickerSection({
    super.key,
    required this.imagePath,
    required this.onImageSelected,
  });

  Future<void> _pickFromGallery() async {
    final path = await ImageService.pickImage();
    onImageSelected(path);
  }

  Future<void> _pickFromCamera() async {
    final path = await ImageService.takePhoto();
    onImageSelected(path);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: SelectionTile(
                  onTap: _pickFromGallery,
                  icon: Icons.photo_library_rounded,
                  label: "Gallery",
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SelectionTile(
                  onTap: _pickFromCamera,
                  icon: Icons.camera_enhance_rounded,
                  label: "Camera",
                  color: Colors.deepPurpleAccent,
                ),
              ),
            ],
          ),

          // Preview image if exists
          if (imagePath != null) ...[
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.file(
                File(imagePath!),
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Reusable tile widget
class SelectionTile extends StatelessWidget {
  final Future<void> Function() onTap;
  final IconData icon;
  final String label;
  final Color color;

  const SelectionTile({
    super.key,
    required this.onTap,
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () async => await onTap(),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              colors: [
                color.withValues(alpha: 0.1),
                color.withValues(alpha: 0.05),
              ],
            ),
          ),
          child: Column(
            children: [
              Icon(icon, size: 32, color: color),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: color.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
