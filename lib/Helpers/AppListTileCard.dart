import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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

    final horizontalPadding = screenWidth * 0.045;
    final verticalPadding = screenWidth * 0.01;
    final iconSize = screenWidth * 0.075;
    final fontSize = screenWidth * 0.042;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.03,
            vertical: screenWidth * 0.01,
          ),
          leading: _buildLeadingImage(iconSize),
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: fontSize,
            ),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            size: screenWidth * 0.045,
          ),
          onTap: onTap,
        ),
      ),
    );
  }

  Widget _buildLeadingImage(double size) {
    if (isSvg) {
      return SvgPicture.asset(
        imagePath,
        height: size,
        width: size,
        fit: BoxFit.contain,
      );
    } else if (isNetwork) {
      return Image.network(
        imagePath,
        height: size,
        width: size,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => Icon(Icons.broken_image, size: size),
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
