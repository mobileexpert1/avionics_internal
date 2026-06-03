import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../Constants/AppColors.dart';
import '../../../Constants/constantImages.dart';

class MapTrackingModePopup extends StatelessWidget {
  final VoidCallback onFlyingSelected;
  final VoidCallback onTrackSelected;
  final VoidCallback onCrossButton;

  const MapTrackingModePopup({
    super.key,
    required this.onCrossButton,
    required this.onFlyingSelected,
    required this.onTrackSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                height: 1,
                width: 50,
                margin: const EdgeInsets.only(bottom: 15),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(2.5),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Center(
                    child: Text(
                      "Choose Your Tracking Mode",
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: onCrossButton,
                  child: const Icon(Icons.close, color: Colors.black, size: 30),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Flying in the Area
            GestureDetector(
              onTap: onFlyingSelected,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.facebookButton,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  children: [
                    SizedBox(width: 5),
                    SvgPicture.asset(
                      CommonUi.setSvgImage(AssetsPath.mapPopupAircraft),
                      height: 32,
                      width: 32,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Flying in the Area",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 6),
            const Text(
              "Click to view flights currently flying in this area on the map",
              style: TextStyle(color: Colors.black, fontSize: 13),
              textAlign: TextAlign.start,
            ),

            const SizedBox(height: 16),

            GestureDetector(
              onTap: onTrackSelected,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.customBottomEnabledColour,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  children: [
                    SizedBox(width: 5),
                    SvgPicture.asset(
                      CommonUi.setSvgImage(AssetsPath.mapPopupLiveArea),
                      height: 25,
                      width: 25,
                      fit: BoxFit.fitWidth,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Track a Flight",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 6),
            const Text(
              "View real-time status, route, and updates for a flight.",
              style: TextStyle(color: Colors.black, fontSize: 12),
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
