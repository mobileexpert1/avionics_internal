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

    /// ================= NETWORK =================
    if (_isNetwork) {
      if (_isSvg) {
        return _fixedBox(
          useCache
              ? CachedSvgImage(imageUrl: imagePath, fit: contentImage)
              : SvgPicture.network(imagePath, fit: contentImage),
        );
      }

      return _fixedBox(
        useCache
            ? CachedNetworkImage(
                cacheManager: CustomCacheManager.instance,
                imageUrl: imagePath,
                fit: contentImage,
                placeholder: (_, __) => _loader(),
                errorWidget: (_, __, ___) => _errorIcon(isForPlaneList),
              )
            : Image.network(
                imagePath,
                fit: contentImage,
                errorBuilder: (_, __, ___) => _errorIcon(isForPlaneList),
              ),
      );
    }

    /// ================= ASSETS =================
    if (_isSvg) {
      return _fixedBox(SvgPicture.asset(imagePath, fit: contentImage));
    }

    return _fixedBox(
      Image.asset(
        imagePath,
        fit: contentImage,
        errorBuilder: (_, __, ___) => _errorIcon(isForPlaneList),
      ),
    );
  }

  /// ================= HELPERS =================

  Widget _fixedBox(Widget child) => SizedBox(
    width: width,
    height: height,
    child: ClipRRect(borderRadius: BorderRadius.circular(6), child: child),
  );

  Widget _loader() =>
      const Center(child: CircularProgressIndicator(strokeWidth: 1.5));

  Widget _errorIcon(bool isPlaneList) => SizedBox(
    width: width,
    height: height,
    child: isPlaneList
        ? Center(
            child: SvgPicture.asset(
              CommonUi.setSvgImage(AssetsPath.Plane1),
              height: height,
              width: width,
              fit: BoxFit.cover,
            ),
          )
        : const Center(child: Icon(Icons.error, color: Colors.red)),
  );
}

class CachedSvgImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit fit;

  const CachedSvgImage({super.key, required this.imageUrl, required this.fit});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.network(imageUrl, fit: fit);
  }
}
