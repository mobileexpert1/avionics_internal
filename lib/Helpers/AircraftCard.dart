import 'package:avionics_internal/Constants/constantImages.dart';
import 'package:flutter/material.dart';

class AircraftCard {
  static Widget buildAircraftCard({
    required String imagePath,
    required String model,
    required String badge,
    required String manufacturer,
    required String registrationNumber,
    Key? key,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = MediaQuery.of(context).size.width;

        // Scale factors
        final imageWidth = screenWidth * 0.3;
        final imageHeight = screenWidth * 0.25;
        final titleFontSize = screenWidth * 0.05;
        final badgeFontSize = screenWidth * 0.032;
        final infoFontSize = screenWidth * 0.033;
        final iconSize = screenWidth * 0.045;

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
          margin: EdgeInsets.only(
            bottom: screenWidth * 0.03,
            left: screenWidth * 0.045,
            right: screenWidth * 0.045,
            top: screenWidth * 0.015,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: Colors.grey.shade300, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Card(
            key: key,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            elevation: 0,
            margin: EdgeInsets.zero,
            child: ListTile(
              contentPadding: EdgeInsets.all(screenWidth * 0.025),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  imagePath,
                  width: imageWidth,
                  height: imageHeight,
                  fit: BoxFit.cover,
                ),
              ),
              title: Row(
                children: [
                  Flexible(
                    child: Text(
                      model,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: titleFontSize,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.015),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.02,
                      vertical: screenWidth * 0.005,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      badge,
                      style: TextStyle(
                        fontSize: badgeFontSize,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              subtitle: Padding(
                padding: EdgeInsets.only(top: screenWidth * 0.01),
                child: Row(
                  children: [
                    Image.asset(
                      CommonUi.setPngImage(manufacturerImagePath),
                      width: iconSize,
                      height: iconSize,
                    ),
                    SizedBox(width: 6),
                    Text(
                      manufacturer,
                      style: TextStyle(fontSize: infoFontSize),
                    ),
                    SizedBox(width: 12),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.02,
                        vertical: screenWidth * 0.005,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        registrationNumber,
                        style: TextStyle(
                          fontSize: badgeFontSize,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              trailing: Icon(
                Icons.chevron_right,
                size: screenWidth * 0.05,
              ),
            ),
          ),
        );
      },
    );
  }
}
