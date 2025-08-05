import 'package:flutter/material.dart';
import '../Constants/constantImages.dart';

// class SelectableAircraftCard extends StatelessWidget {
//   final String imagePath;
//   final String model;
//   final String badge;
//   final String manufacturer;
//   final String? airline;
//   final String? airlineImagePath;
//   final bool isSelected;
//   final VoidCallback? onTap;
//   final bool isComeFromPopUp;
//
//   const SelectableAircraftCard({
//     Key? key,
//     required this.imagePath,
//     required this.model,
//     required this.badge,
//     required this.manufacturer,
//     this.airline,
//     this.airlineImagePath,
//     this.isSelected = false,
//     this.isComeFromPopUp = false,
//     this.onTap,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     String manufacturerImagePath;
//     switch (manufacturer) {
//       case 'Boeing':
//         manufacturerImagePath = AssetsPath.boeinglogo;
//         break;
//       case 'Airbus':
//         manufacturerImagePath = AssetsPath.airbus;
//         break;
//       default:
//         manufacturerImagePath = AssetsPath.DhcLogo;
//     }
//
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(6),
//           border: Border.all(
//             color: isSelected ? const Color(0xFF1C1733) : Colors.grey.shade300,
//             width: 2,
//           ),
//           boxShadow: const [
//             BoxShadow(
//               color: Colors.black12,
//               blurRadius: 4,
//               offset: Offset(0, 2),
//             ),
//           ],
//         ),
//         child: ListTile(
//           contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//           leading: ClipRRect(
//             borderRadius: BorderRadius.circular(4),
//             child: Image.asset(
//               imagePath,
//               width: 100,
//               height: 40,
//               fit: BoxFit.cover,
//             ),
//           ),
//
//           // FIXED TITLE LAYOUT
//           title: Wrap(
//             crossAxisAlignment: WrapCrossAlignment.center,
//             spacing: 4,
//             children: [
//               Text(
//                 model,
//                 style: const TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 15,
//                 ),
//               ),
//               _buildBadge(badge),
//             ],
//           ),
//
//           // Subtitle layout
//           subtitle: Padding(
//             padding: const EdgeInsets.only(top: 4),
//             child: Row(
//               children: [
//                 Image.asset(
//                   CommonUi.setPngImage(manufacturerImagePath),
//                   width: 16,
//                   height: 16,
//                 ),
//                 const SizedBox(width: 4),
//                 Text(
//                   manufacturer,
//                   style: const TextStyle(fontSize: 13),
//                 ),
//                 if (airline != null && airlineImagePath != null) ...[
//                   const SizedBox(width: 10),
//                   Image.asset(
//                     airlineImagePath!,
//                     width: 16,
//                     height: 16,
//                   ),
//                   const SizedBox(width: 4),
//                   Flexible(
//                     child: Text(
//                       airline!,
//                       style: const TextStyle(fontSize: 13),
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                 ],
//               ],
//             ),
//           ),
//
//
//           // Trailing icon logic
//           trailing: isComeFromPopUp == true ? Wrap() : isSelected
//               ? const Icon(Icons.check_circle, color: Colors.blue, size: 20)
//               : const Icon(Icons.chevron_right, size: 18),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildBadge(String text) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(4),
//         boxShadow: const [
//           BoxShadow(
//             color: Colors.grey,
//             spreadRadius: 0.1,
//             blurRadius: 1,
//           ),
//         ],
//       ),
//       child: Text(
//         text,
//         style: const TextStyle(
//           fontSize: 12,
//           fontWeight: FontWeight.w500,
//         ),
//       ),
//     );
//   }
// }

class SimpleAircraftCard extends StatelessWidget {
  final String imagePath;
  final String model;
  final String badge;
  final String manufacturer;
  final String? airline;
  final String? airlineImagePath;
  final VoidCallback? onTap;

  const SimpleAircraftCard({
    Key? key,
    required this.imagePath,
    required this.model,
    required this.badge,
    required this.manufacturer,
    this.airline,
    this.airlineImagePath,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String manufacturerImagePath;
    switch (manufacturer) {
      case 'Boeing':
        manufacturerImagePath = AssetsPath.boeinglogo;
        break;
      case 'Airbus':
        manufacturerImagePath = AssetsPath.airbus;
        break;
      default:
        manufacturerImagePath = AssetsPath.DhcLogo;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.grey.shade300, width: 1),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.asset(
              imagePath,
              width: 100,
              height: 40,
              fit: BoxFit.cover,
            ),
          ),
          title: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 4,
            children: [
              Text(
                model,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              _buildBadge(badge),
            ],
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Row(
              children: [
                Image.asset(
                  CommonUi.setPngImage(manufacturerImagePath),
                  width: 16,
                  height: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  manufacturer,
                  style: const TextStyle(fontSize: 13),
                ),
                if (airline != null && airlineImagePath != null) ...[
                  const SizedBox(width: 10),
                  Image.asset(
                    airlineImagePath!,
                    width: 16,
                    height: 16,
                  ),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      airline!,
                      style: const TextStyle(fontSize: 13),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            spreadRadius: 0.1,
            blurRadius: 1,
          ),
        ],
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

