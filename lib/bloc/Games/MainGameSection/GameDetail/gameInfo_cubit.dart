import 'package:flutter_bloc/flutter_bloc.dart';
import 'gameInfo_model.dart';

class GameDetailCubit extends Cubit<GameInfo> {
  GameDetailCubit(GameInfo game) : super(game);
}
