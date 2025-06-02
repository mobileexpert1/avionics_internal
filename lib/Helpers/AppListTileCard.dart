import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppListTileCard extends StatelessWidget {
  final String title;
  final String svgPath;
  final VoidCallback? onTap;

  const AppListTileCard({
    Key? key,
    required this.title,
    required this.svgPath,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 3),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF7F7F9),
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: ListTile(
          leading: SvgPicture.asset(
            svgPath,
            height: 30,
            width: 30,
            fit: BoxFit.contain,
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 19,
            ),
          ),
          trailing: const Icon(Icons.arrow_forward_ios, size: 19),
          onTap: onTap,
        ),
      ),
    );
  }
}
