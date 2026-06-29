// import 'package:flutter/material.dart';
// import 'package:flutter_3d_controller/flutter_3d_controller.dart';
// import 'package:flutter_svg/svg.dart';
//
// import '../../../../../Constants/ConstantStrings.dart';
// import '../../../../../Constants/constantImages.dart';
// import '../../../../../CustomFiles/CustomAppBar.dart';
//
// class ModelTestScreen extends StatefulWidget {
//   const ModelTestScreen({super.key});
//
//   @override
//   State<ModelTestScreen> createState() => _ModelTestScreenState();
// }
//
// class _ModelTestScreenState extends State<ModelTestScreen> {
//   final Flutter3DController controller = Flutter3DController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppBar(
//         title: ConstantStrings.settingScreen,
//         centerTitle: false,
//         leftButton: IconButton(
//           icon: SvgPicture.asset(
//             CommonUi.setSvgImage(AssetsPath.backArrowButton),
//             fit: BoxFit.cover,
//           ),
//           onPressed: () {
//             Navigator.pop(context, true);
//           },
//         ),
//       ),
//       body: Flutter3DViewer(
//         controller: controller,
//         src: 'assets/3d_models/Airplane1.glb',
//
//         onProgress: (double progress) {
//           debugPrint('Loading: ${(progress * 100).toStringAsFixed(0)}%');
//         },
//
//         onLoad: (String modelAddress) {
//           debugPrint('Model loaded successfully: $modelAddress');
//           controller.playAnimation();
//         },
//
//         onError: (String error) {
//           debugPrint('Failed to load model: $error');
//         },
//       ),
//     );
//   }
// }
