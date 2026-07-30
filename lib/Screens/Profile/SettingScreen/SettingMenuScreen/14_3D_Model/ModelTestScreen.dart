// import 'package:flutter/material.dart';
// import 'package:flutter_3d_controller/flutter_3d_controller.dart';
// import 'package:flutter_svg/flutter_svg.dart';
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
//   final List<Map<String, String>> aircraftDetails = [
//     {"title": "Aircraft", "value": "Boeing 737-800"},
//     {"title": "Manufacturer", "value": "Boeing"},
//     {"title": "Engine", "value": "CFM56-7B"},
//     {"title": "Length", "value": "39.5 m"},
//     {"title": "Wingspan", "value": "35.8 m"},
//     {"title": "Height", "value": "12.5 m"},
//     {"title": "Cruise Speed", "value": "842 km/h"},
//     {"title": "Range", "value": "5,765 km"},
//     {"title": "Seats", "value": "189"},
//     {"title": "Maximum Takeoff Weight", "value": "79,015 kg"},
//   ];
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
//           ),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: Column(
//         children: [
//           /// 3D Viewer
//           SizedBox(
//             height: MediaQuery.of(context).size.height * 0.40,
//             width: double.infinity,
//             child: Flutter3DViewer(
//               controller: controller,
//               src: 'assets/3d_models/Airplane1.glb',
//
//               onLoad: (modelAddress) {
//                 controller.playAnimation();
//               },
//
//               onProgress: (progress) {
//                 debugPrint(
//                     "Loading ${(progress * 100).toStringAsFixed(0)}%");
//               },
//
//               onError: (error) {
//                 debugPrint(error);
//               },
//             ),
//           ),
//
//           const Divider(height: 1),
//
//           /// Details List
//           Expanded(
//             child: ListView.separated(
//               padding: const EdgeInsets.all(16),
//               itemCount: aircraftDetails.length,
//               separatorBuilder: (_, __) => const Divider(),
//               itemBuilder: (context, index) {
//                 final item = aircraftDetails[index];
//
//                 return Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     SizedBox(
//                       width: 150,
//                       child: Text(
//                         item["title"]!,
//                         style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 15,
//                         ),
//                       ),
//                     ),
//                     Expanded(
//                       child: Text(
//                         item["value"]!,
//                         style: const TextStyle(fontSize: 15),
//                       ),
//                     ),
//                   ],
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }