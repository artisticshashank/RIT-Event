import 'package:flutter/material.dart';
import 'package:autonexa/theme/pallete.dart';

class EvidenceUploader extends StatelessWidget {
  const EvidenceUploader({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF28286A) : Colors.grey.shade100;

    return Row(
      children: [
        _buildAddPhotoButton(bgColor),
        const SizedBox(width: 12),
        _buildPhotoThumbnail(
          'https://images.unsplash.com/photo-1619642751034-765dfdf7c58e?q=80&w=200&auto=format&fit=crop',
        ), // Engine
        const SizedBox(width: 12),
        _buildPhotoThumbnail(
          'https://images.unsplash.com/photo-1542282088-72c9c27ed0cd?q=80&w=200&auto=format&fit=crop',
          isDarkImage: true,
        ), // UI/Dash
      ],
    );
  }

  Widget _buildAddPhotoButton(Color bgColor) {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Material(
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: Pallete.textSecondaryColor.withValues(alpha: 0.5),
            style: BorderStyle.solid,
          ),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, color: Pallete.secondaryColor),
            SizedBox(height: 4),
            Text(
              'ADD',
              style: TextStyle(
                color: Pallete.textSecondaryColor,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoThumbnail(String url, {bool isDarkImage = false}) {
    return Stack(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover),
          ),
        ),
        Positioned(
          top: -4,
          right: -4,
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: const BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.close, color: Colors.white, size: 12),
          ),
        ),
      ],
    );
  }
}
