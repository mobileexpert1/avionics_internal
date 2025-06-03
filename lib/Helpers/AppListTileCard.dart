import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppListTileCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final VoidCallback? onTap;
  final bool isSvg;

  const AppListTileCard({
    Key? key,
    required this.title,
    required this.imagePath,
    this.onTap,
    this.isSvg = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 3),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: ListTile(
          leading: isSvg
              ? SvgPicture.asset(
            imagePath,
            height: 30,
            width: 30,
            fit: BoxFit.contain,
          )
              : Image.asset(
            imagePath,
            height: 30,
            width: 30,
            fit: BoxFit.contain,
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 17,
            ),
          ),
          trailing: const Icon(Icons.arrow_forward_ios, size: 19),
          onTap: onTap,
        ),
      ),
    );
  }
}
