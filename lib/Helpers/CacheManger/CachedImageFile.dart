import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../Constants/constantImages.dart';
import 'CustomCacheManager.dart';
import 'cached_svg.dart';

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

  bool get _isNetwork =>
      imagePath.startsWith('http://') || imagePath.startsWith('https://');

  bool get _isSvg => imagePath.toLowerCase().endsWith('.svg');

  @override
  Widget build(BuildContext context) {
    if (imagePath.isEmpty) {
      return _errorIcon(isForPlaneList);
    }

    ///NETWORK
    if (_isNetwork) {
      if (_isSvg) {
        return _fixedBox(
          useCache
              ? CachedSvgImage(imageUrl: imagePath, fit: contentImage)
              : _networkSvg(),
        );
      }

      return _fixedBox(
        useCache
            ? CachedNetworkImage(
                httpHeaders: {"User-Agent": "Mozilla/5.0"},
                cacheManager: CustomCacheManager.instance,
                imageUrl: imagePath,
                fit: contentImage,
                placeholder: (_, _) => _loader(),
                errorWidget: (_, url, error) {
                  debugPrint("❌ Image load failed: $url");
                  debugPrint("❌ Error: $error");
                  return _errorIcon(isForPlaneList);
                },
              )
            : Image.network(
                imagePath,
                fit: contentImage,
                errorBuilder: (_, error, stackTrace) {
                  debugPrint("❌ Image.network failed: $imagePath");
                  debugPrint("❌ Error: $error");
                  return _errorIcon(isForPlaneList);
                },
              ),
      );
    }

    ///ASSETS
    if (_isSvg) {
      return _fixedBox(SvgPicture.asset(imagePath, fit: contentImage));
    }

    return _fixedBox(
      Image.asset(
        imagePath,
        fit: contentImage,
        errorBuilder: (_, error, stackTrace) {
          debugPrint("❌ Asset load failed: $imagePath");
          debugPrint("❌ Error: $error");
          return _errorIcon(isForPlaneList);
        },
      ),
    );
  }

  Widget _networkSvg() {
    try {
      return SvgPicture.network(
        imagePath,
        fit: contentImage,
        placeholderBuilder: (_) => _loader(),
      );
    } catch (e, s) {
      debugPrint("❌ SVG load failed: $imagePath");
      debugPrint("❌ Error: $e");
      debugPrint("$s");
      return _errorIcon(isForPlaneList);
    }
  }

  ///HELPERS
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
