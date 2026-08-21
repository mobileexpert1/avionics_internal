// import 'package:flutter/material.dart';
//
// import '../../../../../../Constants/AppColors.dart';
// import '../../../../../../Helpers/AppTextStyles/AppTextStyles.dart';
// import '../../../../../../bloc/Games/SubGameSection/AllSticker/AllMySticker_model.dart';
//
// class StickerCard extends StatelessWidget {
//   final StickerModel sticker;
//   final VoidCallback? onTap;
//
//   const StickerCard({super.key, required this.sticker, this.onTap});
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       borderRadius: BorderRadius.circular(12),
//       onTap: onTap,
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: const Color(0xffE5E7EB)),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(.04),
//               blurRadius: 5,
//               offset: const Offset(0, 1),
//             ),
//           ],
//         ),
//         child: Column(
//           children: [
//             Expanded(
//               flex: 5,
//               child: ClipRRect(
//                 borderRadius: const BorderRadius.vertical(
//                   top: Radius.circular(12),
//                 ),
//                 child: _buildImage(),
//               ),
//             ),
//             Expanded(
//               flex: 3,
//               child: Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       sticker.brand,
//                       style: AppTextStyles.bold(
//                         16,
//                       ).copyWith(height: 1.0, color: AppColors.primaryDark),
//                     ),
//                     const SizedBox(height: 6),
//                     Text(
//                       sticker.model,
//                       style: AppTextStyles.bold(
//                         20,
//                       ).copyWith(height: 1.0, color: AppColors.primaryDark),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildImage() {
//     if (sticker.isUnlocked) {
//       return Image.asset(
//         sticker.imageUrl ?? '',
//         fit: BoxFit.cover,
//         width: double.infinity,
//       );
//     }
//
//     return Container(
//       color: const Color(0xffD6D6D6),
//       child: Center(
//         child: Image.asset("assets/dummyPictures/7777.png", fit: BoxFit.cover),
//       ),
//     );
//   }
// }
