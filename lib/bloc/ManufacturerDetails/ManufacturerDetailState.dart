class ManufacturerDetailState {
  final bool showGeneralInfo;
  final bool showAbout;
  final bool showHistory;
  final bool showProducts;

  ManufacturerDetailState({
    this.showGeneralInfo = false,
    this.showAbout = false,
    this.showHistory = false,
    this.showProducts = false,
  });

  ManufacturerDetailState copyWith({
    bool? showGeneralInfo,
    bool? showAbout,
    bool? showHistory,
    bool? showProducts,
  }) {
    return ManufacturerDetailState(
      showGeneralInfo: showGeneralInfo ?? this.showGeneralInfo,
      showAbout: showAbout ?? this.showAbout,
      showHistory: showHistory ?? this.showHistory,
      showProducts: showProducts ?? this.showProducts,
    );
  }
}
