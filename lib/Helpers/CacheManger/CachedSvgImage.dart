import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'CustomCacheManager.dart';

class CachedSvgImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit fit;

  const CachedSvgImage({super.key, required this.imageUrl, required this.fit});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<File>(
      future: CustomCacheManager.instance.getSingleFile(imageUrl),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(strokeWidth: 1.5),
          );
        }

        if (!snapshot.hasData) {
          return const Icon(Icons.error, color: Colors.red);
        }

        return SvgPicture.file(
          snapshot.data!,
          fit: fit,
          clipBehavior: Clip.hardEdge,
        );
      },
    );
  }
}
