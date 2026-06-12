import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Constants/AppColors.dart';
import 'game_model.dart';
import 'game_state.dart';

class GamesCubit extends Cubit<GamesState> {
  GamesCubit() : super(GamesInitial()) {
    loadGames();
  }

  void loadGames() {
    final List<GamePairItemModel> rowsGame = [
      GamePairItemModel(
        left: GameCardModel(
          id: "quiz",
          title: "Aviation\nQuiz",
          color: AppColors.greenColourForPlan,
          topValue: kIsWeb ? 240 : 250,
        ),
        right: GameCardModel(
          id: "black_box",
          title: "Black Box",
          color: AppColors.blackBoxColorForGame,
          topValue: kIsWeb ? 240 : 250,
        ),
      ),

      GamePairItemModel(
        left: GameCardModel(
          id: "aircraftEncyclopaedia",
          title: "Citius. Altius.\nLongius.",
          color: AppColors.citiusAltiusColorForGame,
          topValue: kIsWeb ? 380 : 370,
        ),
        right: GameCardModel(
          id: "trivia",
          title: "Jetting\nAround\nThe World",
          color: AppColors.primaryBlue,
          topValue: kIsWeb ? 380 : 370,
        ),
      ),

      GamePairItemModel(
        left: GameCardModel(
          id: "one_word",
          title: "Basic Topics",
          color: AppColors.primaryDark,
          topValue: kIsWeb ? 520 : 490,
        ),
        right: GameCardModel(
          id: "imageBased",
          title: "PlaneSpotter",
          color: AppColors.planeSpotterColorForGame,
          topValue: kIsWeb ? 520 : 490,
        ),
      ),

      GamePairItemModel(
        left: GameCardModel(
          id: "calculation",
          title: "Calculations",
          color: AppColors.greenColourForPlan,
          topValue: kIsWeb ? 650 : 610,
        ),
      ),
    ];

    emit(GamesLoaded(rowsGame));
  }
}
