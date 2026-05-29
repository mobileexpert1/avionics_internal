// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
//
// import '../../Constants/constantImages.dart';
// import 'CustomCacheManager.dart';
//
// class CachedSvgImage extends StatefulWidget {
//   final String imageUrl;
//   final BoxFit fit;
//   final double width;
//   final double height;
//   final bool isForPlaneList;
//
//   const CachedSvgImage({
//     super.key,
//     required this.imageUrl,
//     required this.fit,
//     required this.isForPlaneList,
//     required this.width,
//     required this.height,
//   });
//
//   @override
//   State<CachedSvgImage> createState() => _CachedSvgImageState();
// }
//
// class _CachedSvgImageState extends State<CachedSvgImage> {
//   Future<File>? _svgFuture;
//
//   @override
//   void initState() {
//     super.initState();
//
//     /// iOS PE CACHE DISABLE
//     if (!Platform.isIOS) {
//       _svgFuture = CustomCacheManager.instance
//           .getSingleFile(widget.imageUrl);
//     }
//   }
//
//   @override
//   void didUpdateWidget(covariant CachedSvgImage oldWidget) {
//     super.didUpdateWidget(oldWidget);
//
//     if (oldWidget.imageUrl != widget.imageUrl) {
//
//       if (!Platform.isIOS) {
//         _svgFuture = CustomCacheManager.instance
//             .getSingleFile(widget.imageUrl);
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     /// iOS DIRECT NETWORK
//     if (Platform.isIOS) {
//       return _networkSvg();
//     }
//
//     /// OTHER PLATFORMS CACHE
//     return FutureBuilder<File>(
//       future: _svgFuture,
//
//       builder: (context, snapshot) {
//
//         /// LOADING
//         if (snapshot.connectionState ==
//             ConnectionState.waiting) {
//           return _loader();
//         }
//
//         /// CACHE SUCCESS
//         if (snapshot.hasData &&
//             snapshot.data != null) {
//
//           return SvgPicture.file(
//             snapshot.data!,
//             fit: widget.fit,
//             width: widget.width,
//             height: widget.height,
//             clipBehavior: Clip.hardEdge,
//           );
//         }
//
//         /// CACHE FAIL -> NETWORK
//         return _networkSvg();
//       },
//     );
//   }
//
//   Widget _networkSvg() {
//     return SvgPicture.network(
//       widget.imageUrl,
//       fit: widget.fit,
//       width: widget.width,
//       height: widget.height,
//
//       placeholderBuilder: (_) {
//         return _loader();
//       },
//     );
//   }
//
//   Widget _loader() {
//     return const Center(
//       child: CircularProgressIndicator(
//         strokeWidth: 1.5,
//       ),
//     );
//   }
//
//   Widget _errorIcon(bool isPlaneList) {
//     return SizedBox(
//       width: widget.width,
//       height: widget.height,
//       child: isPlaneList
//           ? Center(
//         child: SvgPicture.asset(
//           CommonUi.setSvgImage(
//             AssetsPath.Plane1,
//           ),
//           height: widget.height,
//           width: widget.width,
//           fit: BoxFit.cover,
//         ),
//       )
//           : const Center(
//         child: Icon(
//           Icons.error,
//           color: Colors.red,
//         ),
//       ),
//     );
//   }
// }