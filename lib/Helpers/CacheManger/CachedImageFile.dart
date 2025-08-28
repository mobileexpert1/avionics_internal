import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'CustomCacheManager.dart';

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'CustomCacheManager.dart';

class CachedAnyImage extends StatelessWidget {
  final String imagePath;
  final double width;
  final double height;

  const CachedAnyImage({
    super.key,
    required this.imagePath,
    required this.width,
    required this.height,
  });

  bool get _isNetwork => imagePath.startsWith("http");
  bool get _isSvg => imagePath.toLowerCase().endsWith(".svg");

  @override
  Widget build(BuildContext context) {
    if (imagePath.isEmpty) {
      return _errorIcon();
    }

    // --- Network Images (SVG + PNG/JPG) ---
    if (_isNetwork) {
      if (_isSvg) {
        return FutureBuilder<File>(
          future: CustomCacheManager.instance.getSingleFile(imagePath),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _loader();
            }
            if (snapshot.hasError) {
              return _errorIcon();
            }
            if (!snapshot.hasData) {
              return _errorIcon();
            }

            return _fixedBox(
              SvgPicture.file(
                snapshot.data!,
                fit: BoxFit.contain,
              ),
            );
          },
        );
      } else {
        return _fixedBox(
          CachedNetworkImage(
            cacheManager: CustomCacheManager.instance,
            imageUrl: imagePath,
            fit: BoxFit.contain,
            placeholder: (context, url) => _loader(),
            errorWidget: (context, url, error) => _errorIcon(),
          ),
        );
      }
    }

    // --- Local Assets (SVG + PNG/JPG) ---
    if (_isSvg) {
      return _fixedBox(
        SvgPicture.asset(
          imagePath,
          fit: BoxFit.contain,
        ),
      );
    } else {
      return _fixedBox(
        Image.asset(
          imagePath,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => _errorIcon(),
        ),
      );
    }
  }

  Widget _fixedBox(Widget child) => SizedBox(
    width: width,
    height: height,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(6), // optional rounded corners
      child: child,
    ),
  );

  Widget _loader() => SizedBox(
    width: width,
    height: height,
    child: const Center(
      child: CircularProgressIndicator(strokeWidth: 1.5),
    ),
  );

  Widget _errorIcon() => SizedBox(
    width: width,
    height: height,
    child: const Center(child: Icon(Icons.error, color: Colors.red)),
  );
}
