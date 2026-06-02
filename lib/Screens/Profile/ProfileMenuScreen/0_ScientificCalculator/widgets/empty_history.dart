import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../Constants/constantImages.dart';
import '../core/index.dart';

class EmptyHistory extends StatelessWidget {
  const EmptyHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          AssetsPath.historyForCal,
          width: isLandscape ? 30 : 60,
          color: colorScheme.historyBorder,
        ),
        const SizedBox(height: 5),
        Text(
          'No History Yet...',
          style: TextStyle(color: colorScheme.historyBorder),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
