import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../Constants/constantImages.dart';

class AppListTileCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final VoidCallback? onTap;
  final bool isSvg;
  final bool isNetwork;

  const AppListTileCard({
    Key? key,
    required this.title,
    required this.imagePath,
    this.onTap,
    this.isSvg = true,
    this.isNetwork = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final horizontalPadding = kIsWeb
        ? screenWidth * 0.02
        : screenWidth * 0.042;
    final iconSize = kIsWeb ? screenWidth * 0.055 : screenWidth * 0.15;
    final fontSize = kIsWeb ? screenWidth * 0.02 : screenWidth * 0.038;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 6),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: ListTile(
          dense: true,
          visualDensity: VisualDensity(vertical: -3),
          contentPadding: EdgeInsets.symmetric(
            horizontal: kIsWeb ? screenWidth * 0.01 :screenWidth * 0.03,
            vertical: 6,
          ),
          leading: _buildLeadingImage(iconSize),
          title: Text(
            title,
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: fontSize),
          ),
          trailing: Icon(Icons.arrow_forward_ios, size: kIsWeb ?  screenWidth * 0.020: screenWidth * 0.040),
          onTap: onTap,
        ),
      ),
    );
  }

  Widget _buildLeadingImage(double size) {
    if (isSvg) {
      if (imagePath.contains("assets")) {
        return SvgPicture.asset(
          imagePath,
          height: size,
          width: size,
          fit: BoxFit.contain,
        );
      } else {
        return SizedBox(
          height: size,
          width: size,
          child: SvgPicture.network(
            imagePath,
            fit: BoxFit.contain,
            placeholderBuilder: (context) => SvgPicture.asset(
              CommonUi.setSvgImage(AssetsPath.manuFirstImage),
              height: 32,
              width: 32,
              fit: BoxFit.contain,
            ),
          ),
        );
      }
    } else if (isNetwork) {
      return Image.network(
        imagePath,
        height: size,
        width: size,
        fit: BoxFit.contain,
        errorBuilder: (_, _, _) => SvgPicture.asset(
          CommonUi.setSvgImage(AssetsPath.manuFirstImage),
          height: 32,
          width: 32,
          fit: BoxFit.contain,
        ),
      );
    } else {
      return Image.asset(
        imagePath,
        height: size,
        width: size,
        fit: BoxFit.contain,
      );
    }
  }
}
