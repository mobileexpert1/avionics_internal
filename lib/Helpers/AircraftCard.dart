import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:avionics_internal/Constants/constantImages.dart';

class AircraftCard {
  static Widget buildAircraftCard({
    required String imagePath,
    required String model,
    required String badge,
    required String manufacturer,
    required String registrationNumber,
    required String manufacturerLogoPath,
    Key? key,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = MediaQuery.of(context).size.width;

        final imageWidth = kIsWeb ? screenWidth * 0.12 : screenWidth * 0.3;
        final imageHeight = kIsWeb ? screenWidth : screenWidth * 0.2;
        final titleFontSize = kIsWeb ? screenWidth * 0.02 : screenWidth * 0.04;
        final badgeFontSize = kIsWeb ? screenWidth * 0.01 : screenWidth * 0.03;
        final infoFontSize = kIsWeb ? screenWidth * 0.011 : screenWidth * 0.031;
        final iconSize = kIsWeb ? screenWidth * 0.02 : screenWidth * 0.04;

        String manufacturerImagePath;
        bool isNetworkLogo = false;

        if (manufacturer == 'Boeing') {
          manufacturerImagePath = AssetsPath.boeinglogo;
        } else if (manufacturer == 'Airbus') {
          manufacturerImagePath = AssetsPath.airbus;
        } else if (manufacturerLogoPath.startsWith('http') ||
            manufacturerLogoPath.startsWith('/media')) {
          manufacturerImagePath = manufacturerLogoPath;
          isNetworkLogo = true;
        } else {
          manufacturerImagePath = AssetsPath.DhcLogo;
        }

        return Container(
          margin: EdgeInsets.symmetric(
            horizontal: kIsWeb ? screenWidth * 0.02 : screenWidth * 0.045,
            vertical: kIsWeb ? screenWidth * 0.008 : screenWidth * 0.015,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: Colors.grey.shade300),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ListTile(
            key: key,
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: Image.network(
                imagePath,
                width: imageWidth,
                height: imageHeight,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) =>
                    Icon(Icons.broken_image, size: imageHeight),
              ),
            ),
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  fit: FlexFit.loose,
                  child: Text(
                    model,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: titleFontSize,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 6),
                _buildBadge(badge, badgeFontSize),
              ],
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Row(
                children: [
                  isNetworkLogo
                      ? Image.network(
                          manufacturerImagePath,
                          width: iconSize,
                          height: iconSize,
                          errorBuilder: (_, _, _) =>
                              Icon(Icons.error, size: iconSize),
                        )
                      : Image.asset(
                          CommonUi.setPngImage(manufacturerImagePath),
                          width: iconSize,
                          height: iconSize,
                        ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      manufacturer,
                      style: TextStyle(fontSize: infoFontSize),
                      overflow: TextOverflow.visible,
                    ),
                  ),
                  _buildBadge(registrationNumber, badgeFontSize, bold: true),
                ],
              ),
            ),

            trailing: Icon(
              Icons.chevron_right,
              size: kIsWeb ? screenWidth * 0.03 : screenWidth * 0.05,
            ),
          ),
        );
      },
    );
  }

  static Widget _buildBadge(String text, double fontSize, {bool bold = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        boxShadow: const [BoxShadow(color: Colors.grey, spreadRadius: 0.1)],
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: bold ? FontWeight.w500 : FontWeight.w400,
        ),
      ),
    );
  }
}
