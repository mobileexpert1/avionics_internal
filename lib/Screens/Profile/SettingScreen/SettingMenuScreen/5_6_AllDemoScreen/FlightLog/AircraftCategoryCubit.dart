import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../Constants/ApiClass/ApiErrorModel.dart';
import 'AircraftCategoryModel.dart';
import 'AircraftCategoryState.dart';

class AircraftCategoryCubit extends Cubit<AircraftCategoryState> {
  AircraftCategoryCubit() : super(const AircraftCategoryState());

  Future<void> loadCategories() async {
    emit(state.copyWith(status: CommonApiStatus.initial));

    try {
      // await Future.delayed(
      //   const Duration(milliseconds: 500),
      // );
      emit(
        state.copyWith(
          categories: _mockCategories(),
          isSuccess: true,
          status: CommonApiStatus.success,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: CommonApiStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void unlockStickerInCategory(String categoryId) {
    final updated = state.categories.map((category) {
      if (category.id != categoryId) {
        return category;
      }

      if (category.unlockedCount >= category.totalCount) {
        return category;
      }

      return category.copyWith(unlockedCount: category.unlockedCount + 1);
    }).toList();

    emit(state.copyWith(categories: updated));
  }

  List<AircraftCategoryModel> _mockCategories() {
    return [
      AircraftCategoryModel(
        id: "A",
        letter: "A",
        title: "Commercial\nNarrow Body\nJets",
        image: "assets/dummyPictures/1111.png",
        color: const Color(0xffFDC20F),
        unlockedCount: 3,
        totalCount: 12,
      ),
      AircraftCategoryModel(
        id: "B",
        letter: "B",
        title: "Wide-Body &\nLong-Haul\nAircraft",
        image: "assets/dummyPictures/2222.png",
        color: const Color(0xff9CD450),
        unlockedCount: 3,
        totalCount: 12,
      ),
      AircraftCategoryModel(
        id: "C",
        letter: "C",
        title: "Regional Jets",
        image: "assets/dummyPictures/3333.png",
        color: const Color(0xff4797DB),
        unlockedCount: 3,
        totalCount: 12,
      ),
      AircraftCategoryModel(
        id: "D",
        letter: "D",
        title: "Regional\nTurboprops",
        image: "assets/dummyPictures/4444.png",
        color: const Color(0xff3EE1E1),
        unlockedCount: 3,
        totalCount: 12,
      ),
      AircraftCategoryModel(
        id: "E",
        letter: "E",
        title: "Battery-Powered\nAircraft",
        image: "assets/dummyPictures/5555.png",
        color: const Color(0xff201E48),
        unlockedCount: 3,
        totalCount: 12,
      ),
      AircraftCategoryModel(
        id: "F",
        letter: "F",
        title: "Business Jets",
        image: "assets/dummyPictures/6666.png",
        color: const Color(0xffD44545),
        unlockedCount: 3,
        totalCount: 12,
      ),
    ];
  }
}
