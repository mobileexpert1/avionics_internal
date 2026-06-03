import 'dart:ui';

class GamePairItemModel {
  final GameCardModel? left;
  final GameCardModel? right;
  const GamePairItemModel({this.left, this.right});
}

class GameCardModel {
  final String id;
  final String title;
  final Color color;
  final double topValue;

  const GameCardModel({
    required this.id,
    required this.title,
    required this.color,
    required this.topValue,
  });
}
