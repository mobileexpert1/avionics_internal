import 'package:avionics_internal/Constants/constantImages.dart';
import 'package:flutter/material.dart';

class AircraftCard {
  static Widget buildAircraftCard({
    required String imagePath,
    required String model,
    required String badge,
    required String manufacturer,
    String? airline,
    String? airlineImagePath,
    Key? key,
  }) {
    // Determine which image to use for the manufacturer
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

    return Container(
      margin: const EdgeInsets.only(bottom: 12, left: 18, right: 18, top: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.grey.shade300, width: 1),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Card(
        key: key,
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
            children: [
              Text(
                model,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
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
                  ),
                ),
              ),
            ],
          ),
          subtitle: Row(
            children: [
              // Display the correct manufacturer image
              Image.asset(
                CommonUi.setPngImage(manufacturerImagePath),
                // Use the image path determined earlier
                width: 16,
                height: 16,
              ),
              const SizedBox(width: 4),
              Text(manufacturer, style: const TextStyle(fontSize: 13)),
              if (airline != null) ...[
                const SizedBox(width: 10),
                Image.asset(airlineImagePath!, width: 16, height: 16),
                const SizedBox(width: 4),
                Text(airline, style: const TextStyle(fontSize: 13)),
              ],
            ],
          ),
          trailing: const Icon(Icons.chevron_right),
        ),
      ),
    );
  }
}
