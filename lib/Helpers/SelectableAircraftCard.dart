import 'package:flutter/material.dart';
import '../Constants/constantImages.dart';


class SelectableAircraftCard extends StatelessWidget {
  final String imagePath;
  final String model;
  final String badge;
  final String manufacturer;
  final String? airline;
  final String? airlineImagePath;
  final bool isSelected;
  final VoidCallback? onTap;

  const SelectableAircraftCard({
    Key? key,
    required this.imagePath,
    required this.model,
    required this.badge,
    required this.manufacturer,
    this.airline,
    this.airlineImagePath,
    this.isSelected = false,
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
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 13, right: 13, top: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: isSelected ? const Color(0xFF1C1733) : Colors.grey.shade300,
                width: 1
             ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
              elevation: 0,
              margin: EdgeInsets.zero,
              child: ListTile(
                contentPadding: const EdgeInsets.all(8),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    imagePath,
                    width: 120,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      model,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Color(0xFF1C1733), // Optional: to match the dark look
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        badge,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF4B4B4B), // Optional: to match the gray tone
                        ),
                      ),
                    ),
                  ],
                ),

                subtitle: Row(
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
                      Text(
                        airline!,
                        style: const TextStyle(fontSize: 13),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          if (isSelected)
            const Positioned(
              right: 40,
              top: 40,
              child: Icon(Icons.check, color: Colors.blue, size: 20),
            ),
        ],
      ),
    );
  }
}
