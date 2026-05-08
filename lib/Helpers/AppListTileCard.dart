import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../Constants/AppColors.dart';
import '../Constants/constantImages.dart';
import 'AppTextStyles/AppTextStyles.dart';

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

    final horizontalPadding = kIsWeb ? screenWidth * 0.02 : screenWidth * 0.01;
    final iconSize = kIsWeb ? screenWidth * 0.055 : screenWidth * 0.10;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: 5,
          ),
          child: ListTile(
            dense: true,
            visualDensity: VisualDensity(vertical: -3),
            contentPadding: EdgeInsets.symmetric(
              horizontal: kIsWeb ? screenWidth * 0.01 : screenWidth * 0.03,
              vertical: 6,
            ),
            leading: _buildLeadingImage(iconSize),
            title: Text(
              title,
              style: AppTextStyles.medium(
                16,
              ).copyWith(height: 1.0, color: AppColors.black),
            ),
            onTap: onTap,
          ),
        ),
        const Divider(
          height: 0,
          thickness: 2,
          color: AppColors.dividerLineColour,
        ),
      ],
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
