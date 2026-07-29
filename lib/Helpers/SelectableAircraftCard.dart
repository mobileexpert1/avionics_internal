import 'package:avionics_internal/Constants/AppColors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SimpleAircraftCard extends StatelessWidget {
  final Widget imagePath;
  final String model;
  final String badge;
  final String? manufacturer;
  final String? airline;
  final Widget airlineImagePath;
  final String? callSign;
  final VoidCallback? onTap;
  final bool showArrow;

  const SimpleAircraftCard({
    Key? key,
    required this.imagePath,
    required this.model,
    required this.badge,
    this.manufacturer,
    this.airline,
    required this.airlineImagePath,
    this.callSign,
    this.showArrow = false,

    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: kIsWeb ? 0 : 5,
          horizontal: kIsWeb ? 30 : 15,
        ),
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
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: kIsWeb ? 10 : 6,
          ),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: SizedBox(width: 100, height: 55, child: imagePath),
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
              if (badge.isNotEmpty) ...[_buildBadge(badge, false, "")],
            ],
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: kIsWeb ? 0 : 4),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: SizedBox(
                    width: kIsWeb ? 50 : 30,
                    height: kIsWeb ? 15 : 10,
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
                if (callSign != "") ...[
                  const SizedBox(width: 4),
                  _buildBadge(badge, true, callSign ?? ""),
                  const SizedBox(width: 8),
                ],
              ],
            ),
          ),
          trailing: showArrow
              ? const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.black,
                )
              : null,
        ),
      ),
    );
  }

  Widget _buildBadge(
    String text,
    bool isComeFromCallSign,
    String callSignText,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: isComeFromCallSign == true
            ? AppColors.customBottomEnabledColour
            : Colors.white,
        borderRadius: BorderRadius.circular(4),
        boxShadow: const [
          BoxShadow(color: Colors.grey, spreadRadius: 0.1, blurRadius: 1),
        ],
      ),
      child: Text(
        isComeFromCallSign == true ? callSignText : text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: isComeFromCallSign == true ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}
