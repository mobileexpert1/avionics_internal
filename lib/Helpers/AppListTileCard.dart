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

    final horizontalPadding = screenWidth * 0.042;
    final iconSize = screenWidth * 0.15;
    final fontSize = screenWidth * 0.038;

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
            horizontal: screenWidth * 0.03,
            vertical: 6,
          ),
          leading: _buildLeadingImage(iconSize),
          title: Text(
            title,
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: fontSize),
          ),
          trailing: Icon(Icons.arrow_forward_ios, size: screenWidth * 0.040),
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
            placeholderBuilder: (context) =>
                Icon(Icons.broken_image, size: size),
          ),
        );
      }
    } else if (isNetwork) {
      return Image.network(
        imagePath,
        height: size,
        width: size,
        fit: BoxFit.contain,
        errorBuilder: (_, _, _) => Icon(Icons.broken_image, size: size),
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
