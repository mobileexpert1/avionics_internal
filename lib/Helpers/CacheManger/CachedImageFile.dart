import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../Constants/constantImages.dart';
import 'CustomCacheManager.dart';

class CachedAnyImage extends StatelessWidget {
  final String imagePath;
  final double width;
  final double height;
  final BoxFit contentImage;
  final bool useCache;
  final bool isForPlaneList;

  const CachedAnyImage({
    super.key,
    required this.imagePath,
    required this.width,
    required this.height,
    required this.contentImage,
    this.useCache = true,
    this.isForPlaneList = false,
  });

  bool get _isNetwork => imagePath.startsWith('http');
  bool get _isSvg => imagePath.toLowerCase().endsWith('.svg');

  @override
  Widget build(BuildContext context) {
    if (imagePath.isEmpty) {
      return _errorIcon(isForPlaneList);
    }

    /// ================= NETWORK IMAGES =================
    if (_isNetwork) {
      /// -------- SVG NETWORK IMAGE --------
      if (_isSvg) {
        if (!useCache) {
          return _fixedBox(
            SvgPicture.network(
              imagePath,
              fit: contentImage,
            ),
          );
        }

        return FutureBuilder<File>(
          future: CustomCacheManager.instance.getSingleFile(imagePath),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _loader();
            }

            if (snapshot.hasError || !snapshot.hasData) {
              return _errorIcon(isForPlaneList);
            }

            return _fixedBox(
              SvgPicture.file(
                snapshot.data!,
                fit: contentImage,
                clipBehavior: Clip.hardEdge,
              ),
            );
          },
        );
      }

      /// -------- PNG / JPG NETWORK IMAGE --------
      return _fixedBox(
        useCache
            ? CachedNetworkImage(
          cacheManager: CustomCacheManager.instance,
          imageUrl: imagePath,
          fit: contentImage,
          placeholder: (context, url) => _loader(),
          errorWidget: (context, url, error) =>
              _errorIcon(isForPlaneList),
        )
            : Image.network(
          imagePath,
          fit: contentImage,
          errorBuilder: (context, error, stackTrace) =>
              _errorIcon(isForPlaneList),
        ),
      );
    }

    /// ================= LOCAL ASSETS =================
    if (_isSvg) {
      return _fixedBox(
        SvgPicture.asset(
          imagePath,
          fit: contentImage,
        ),
      );
    }

    return _fixedBox(
      Image.asset(
        imagePath,
        fit: contentImage,
        errorBuilder: (context, error, stackTrace) =>
            _errorIcon(isForPlaneList),
      ),
    );
  }

  /// ================= UI HELPERS =================

  Widget _fixedBox(Widget child) => SizedBox(
    width: width,
    height: height,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(6),
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

  Widget _errorIcon(bool isComeFromPlayList) => SizedBox(
    width: width,
    height: height,
    child: isComeFromPlayList
        ? Center(
      child: SvgPicture.asset(
        CommonUi.setSvgImage(AssetsPath.Plane1),
        height: height,
        width: width,
        fit: BoxFit.cover,
      ),
    )
        : const Center(
      child: Icon(Icons.error, color: Colors.red),
    ),
  );
}
