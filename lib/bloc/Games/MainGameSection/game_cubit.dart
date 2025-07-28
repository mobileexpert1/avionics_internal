import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Constants/constantImages.dart';
import 'game_model.dart';
import 'game_state.dart';


class GamesCubit extends Cubit<GamesState> {
  GamesCubit() : super(GamesInitial()) {
    loadGames();
  }

  void loadGames() {
    final games = [
      GameItem(
        title: "Quiz",
        subtitle: "Test your aviation knowledge with time question",
        icon: AssetsPath.quiz,
      ),
      GameItem(
        title: "One Word",
        subtitle: "Complete aviation\n terms and\n procedures",
        icon: AssetsPath.oneWord,
      ),
      GameItem(
        title: "Black Box",
        subtitle: "Emergency scenarios\n and decision making",
        icon: AssetsPath.blackBox,
      ),
      GameItem(
        title: "Calculations",
        subtitle: "Test your aviation knowledge with time question",
        icon: AssetsPath.calculations,
      ),
    ];

    emit(GamesLoaded(games));
  }
}
