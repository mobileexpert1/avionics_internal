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
        final isLarge = constraints.maxWidth > 200;
        final iconSize = isLarge ? 60.0 : 45.0;
        final titleFont = isLarge ? 16.0 : 14.0;
        final subtitleFont = isLarge ? 13.0 : 11.0;
        final padding = isLarge ? 20.0 : 12.0;

        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: EdgeInsets.all(padding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  CommonUi.setSvgImage(item.icon),
                  height: iconSize,
                  width: iconSize,
                  color: Colors.blue,
                ),
                const SizedBox(height: 10),
                Text(
                  item.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: titleFont,
                  ),
                ),
                const SizedBox(height: 6),
                Flexible(
                  child: Text(
                    item.subtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: subtitleFont,
                      color: Colors.black54,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
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
