import 'package:flutter_bloc/flutter_bloc.dart';

import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  void setTabIndex(int index) {
    _selectedIndex = index;
    emit(HomeTabChanged(index));
  }
}
