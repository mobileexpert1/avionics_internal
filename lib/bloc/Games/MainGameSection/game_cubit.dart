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
        id: "quiz",
        title: "Quiz",
        subtitle: "Test your aviation\n knowledge with time\n question",
        icon: AssetsPath.quiz,
      ),
      GameItem(
        id: "one_word",
        title: "One Word",
        subtitle: "Complete aviation\n terms and\n procedures",
        icon: AssetsPath.oneWord,
      ),
      GameItem(
        id: "black_box",
        title: "Black Box",
        subtitle: "Emergency scenarios\n and decision making",
        icon: AssetsPath.blackBox,
      ),
      GameItem(
        id: "calculation",
        title: "Calculations",
        subtitle: "Test your aviation\n knowledge with time\n question",
        icon: AssetsPath.calculations,
      ),
    ];

    emit(GamesLoaded(games));
  }
}
