import 'dart:io';

import 'package:flutter/material.dart';

class AppImage extends StatelessWidget {
  final String? imagePath;
  final String? imageUrl;
  final double width;
  final double height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  const AppImage({
    super.key,
    this.imagePath,
    this.imageUrl,
    required this.width,
    required this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final imageWidget = imagePath != null && imagePath!.isNotEmpty
        ? Image.file(File(imagePath!), width: width, height: height, fit: fit)
        : Image.network(
            imageUrl ?? '',
            width: width,
            height: height,
            fit: fit,
            errorBuilder: (_, __, ___) => _fallback(),
          );

    if (borderRadius == null) return imageWidget;

    return ClipRRect(borderRadius: borderRadius!, child: imageWidget);
  }

  Widget _fallback() {
    return Container(
      width: width,
      height: height,
      color: Colors.grey.shade300,
      child: const Icon(Icons.image_not_supported),
    );
  }
}
