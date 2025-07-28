import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../Constants/constantImages.dart';
import '../../bloc/Games/MainGameSection/game_model.dart';


class GameCard extends StatelessWidget {
  final GameItem item;

  const GameCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 150;
        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: EdgeInsets.all(isWide ? 20 : 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  CommonUi.setSvgImage(item.icon),
                  height: isWide ? 60 : 40,
                  width: isWide ? 50 : 30,
                  color: Colors.blue,
                ),
                const SizedBox(height: 12),
                Text(
                  item.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: isWide ? 16 : 14,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  item.subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: isWide ? 14 : 12,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
