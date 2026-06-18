import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../Constants/constantImages.dart';

class CachedAnyImage extends StatefulWidget {
  final String imagePath;
  final double width;
  final double height;
  final BoxFit contentImage;
  final bool useCache;
  final bool isForPlaneList;
  final bool isForManufacturer;

  const CachedAnyImage({
    super.key,
    required this.imagePath,
    required this.width,
    required this.height,
    required this.contentImage,
    this.useCache = true,
    this.isForPlaneList = false,
    this.isForManufacturer = false,
  });

  @override
  State<CachedAnyImage> createState() => _CachedAnyImageState();
}

class _CachedAnyImageState extends State<CachedAnyImage> {
  static final Map<String, Uint8List> _svgMemoryCache = {};

  Future<Uint8List>? _svgFuture;

  bool get _isNetwork =>
      widget.imagePath.startsWith('http://') ||
      widget.imagePath.startsWith('https://');

  bool get _isSvg => widget.imagePath.toLowerCase().endsWith('.svg');

  @override
  void initState() {
    super.initState();

    if (_isNetwork && _isSvg) {
      _prepareSvg();
    }
  }

  @override
  void didUpdateWidget(covariant CachedAnyImage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.imagePath != widget.imagePath && _isNetwork && _isSvg) {
      _prepareSvg();
    }
  }

  Future<void> _prepareSvg() async {
    if (_svgMemoryCache.containsKey(widget.imagePath)) {
      _svgFuture = Future.value(_svgMemoryCache[widget.imagePath]);
      return;
    }

    _svgFuture = CustomCacheManager.instance
        .getSingleFile(widget.imagePath)
        .then((file) async {
          final bytes = await file.readAsBytes();

          _svgMemoryCache[widget.imagePath] = bytes;

          debugPrint(file.path);
          return bytes;
        });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.imagePath.isEmpty) {
      return _errorWidget();
    }

    if (_isNetwork) {
      if (_isSvg) {
        return _svgWidget();
      }

      return _networkImageWidget();
    }

    return _assetWidget();
  }

  Widget _svgWidget() {
    return SizedBox(
      width: widget.width,
      height: widget.height,

      child: FutureBuilder<Uint8List>(
        future: _svgFuture,

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _loader();
          }

          if (snapshot.hasData) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(6),

              child: SvgPicture.memory(
                snapshot.data!,
                fit: widget.contentImage,
                width: widget.width,
                height: widget.height,
              ),
            );
          }

          return _errorWidget();
        },
      ),
    );
  }

  Widget _networkImageWidget() {
    return SizedBox(
      width: widget.width,
      height: widget.height,

      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),

        child: widget.useCache
            ? CachedNetworkImage(
                imageUrl: widget.imagePath,
                cacheManager: CustomCacheManager.instance,
                fit: widget.contentImage,

                httpHeaders: const {"User-Agent": "Mozilla/5.0"},

                placeholder: (_, _) => _loader(),

                errorWidget: (_, _, _) {
                  return _errorWidget();
                },
              )
            : Image.network(
                widget.imagePath,
                fit: widget.contentImage,

                errorBuilder: (_, _, _) {
                  return _errorWidget();
                },
              ),
      ),
    );
  }

  Widget _assetWidget() {
    return SizedBox(
      width: widget.width,
      height: widget.height,

      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),

        child: _isSvg
            ? SvgPicture.asset(widget.imagePath, fit: widget.contentImage)
            : Image.asset(
                widget.imagePath,
                fit: widget.contentImage,

                errorBuilder: (_, _, _) {
                  return _errorWidget();
                },
              ),
      ),
    );
  }

  Widget _loader() {
    return const Center(child: CircularProgressIndicator(strokeWidth: 1.5));
  }

  Widget _errorWidget() {
    return SizedBox(
      width: widget.width,
      height: widget.height,

      child: widget.isForPlaneList
          ? Center(
              child: SvgPicture.asset(
                CommonUi.setSvgImage(AssetsPath.airBusPlanePlaceholder),
                fit: BoxFit.cover,
                width: widget.width,
                height: widget.height,
              ),
            )
          : widget.isForManufacturer
          ? Center(
              child: SvgPicture.asset(
                CommonUi.setSvgImage(AssetsPath.manufacturerPlaceholder),
                fit: BoxFit.cover,
                width: widget.width,
                height: widget.height,
              ),
            )
          : const Center(child: Icon(Icons.error, color: Colors.red)),
    );
  }
}

class CustomCacheManager {
  static const key = "customCache";

  static final CacheManager instance = CacheManager(
    Config(
      key,
      stalePeriod: const Duration(days: 30),
      maxNrOfCacheObjects: 1000,
    ),
  );
}
