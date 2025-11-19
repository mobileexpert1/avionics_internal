import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../Constants/constantImages.dart';
import '../../bloc/Games/MainGameSection/game_model.dart';

class GameCard extends StatelessWidget {
  final GameItem item;
  final VoidCallback onTap;

  const GameCard({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isLarge = constraints.maxWidth > 200;
        final iconSize = isLarge ? 70.0 : 55.0;
        final titleFont = isLarge ? 21.0 : 14.0;
        final subtitleFont = isLarge ? 17.0 : 11.0;
        final padding = isLarge ? 20.0 : 12.0;


        return InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Card(
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
                    // color: Colors.blue,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    item.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: titleFont,
                      color: Color(0xFF3F3D56)
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
          ),
        );
      },
    );
  }
}
