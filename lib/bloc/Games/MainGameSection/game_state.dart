import 'package:flutter/cupertino.dart';

import 'game_model.dart';

@immutable
abstract class GamesState {}

class GamesInitial extends GamesState {}

class GamesLoaded extends GamesState {
  final List<GamePairItemModel> games;
  GamesLoaded(this.games);
}
