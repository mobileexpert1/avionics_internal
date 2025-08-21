import 'package:flutter/material.dart';
import '../Constants/constantImages.dart';

class SimpleAircraftCard extends StatelessWidget {
  final Widget imagePath;
  final String model;
  final String badge;
  final String? manufacturer;
  final String? airline;
  final Widget airlineImagePath;
  final VoidCallback? onTap;

  const SimpleAircraftCard({
    Key? key,
    required this.imagePath,
    required this.model,
    required this.badge,
    this.manufacturer,
    this.airline,
    required this.airlineImagePath,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            child: SizedBox(
              width: 100,
              height: 55,
              child: imagePath,
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
                  color: Color(0xFF3F3D56),
                ),
              ),
              _buildBadge(badge),
            ],
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: SizedBox(
                    width: 30, // Increased size for better visibility
                    height: 10,
                    child: airlineImagePath,
                  ),
                ),
                const SizedBox(width: 8),
                if (manufacturer != null)
                  Expanded(
                    child: Text(
                      manufacturer!,
                      style: const TextStyle(fontSize: 13),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                if (airline != null) ...[
                  const SizedBox(width: 4),
                  Expanded(
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