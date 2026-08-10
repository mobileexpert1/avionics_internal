import 'package:equatable/equatable.dart';

import 'AirPlanePartsModel.dart';

class AirPlanePartsState extends Equatable {
  final List<AirPlanePartsModel> parts;
  final bool isLoading;
  final String? errorMessage;

  const AirPlanePartsState({
    this.parts = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  int get unlockedCount {
    return parts
        .where(
          (part) => part.collectedCount >= part.totalCount,
    )
        .length;
  }

  int get totalCount {
    return parts.length;
  }

  double get progress {
    if (totalCount == 0) return 0;

    return unlockedCount / totalCount;
  }

  AirPlanePartsState copyWith({
    List<AirPlanePartsModel>? parts,
    bool? isLoading,
    String? errorMessage,
  }) {
    return AirPlanePartsState(
      parts: parts ?? this.parts,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    parts,
    isLoading,
    errorMessage,
  ];
}