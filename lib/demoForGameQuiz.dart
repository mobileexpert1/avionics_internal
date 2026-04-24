// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
//
//
//
// class AtmosphereScreen extends StatelessWidget {
//   const AtmosphereScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final layers = [
//       "Exosphere",
//       "Thermosphere",
//       "Mesosphere",
//       "Stratosphere",
//       "Troposphere",
//     ];
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             children: List.generate(
//               layers.length,
//               (index) => AtmosLayer(title: layers[index]),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class AtmosLayer extends StatelessWidget {
//   final String title;
//
//   const AtmosLayer({super.key, required this.title});
//
//   @override
//   Widget build(BuildContext context) {
//     final assetName = AtmosphereAssets.getAsset(title);
//
//     return CustomPaint(
//       child: SizedBox(
//         height: 160,
//         width: double.infinity,
//         child: Stack(
//           children: [
//             Positioned.fill(
//               child: SvgPicture.asset(
//                 "assets/svg_images/$assetName.svg",
//                 fit: BoxFit.contain,
//               ),
//             ),
//
//              Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     title,
//                     style: const TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.red, // better visibility
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   Container(
//                     height: 45,
//
//                     width: 45,
//                     decoration: BoxDecoration(
//                       color: Colors.black.withOpacity(0.5),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: const Icon(
//                       Icons.arrow_forward_ios,
//                       color: Colors.white,
//                       size: 18,
//                     ),
//                   ),
//                   SizedBox(height: 60),
//                 ],
//               ),
//             ),
//             SizedBox(height: 100),
//           ],
//         ),
//       ),
//     );
//   }
// }
