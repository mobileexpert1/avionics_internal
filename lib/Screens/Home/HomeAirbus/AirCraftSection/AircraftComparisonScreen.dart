import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../Constants/ApiClass/FirebaseAnalytics/analytics_service.dart';
import '../../../../Constants/ApiClass/FirebaseAnalytics/event_names.dart';
import '../../../../Helpers/AppText.dart';
import '../../../../Helpers/CacheManger/CachedImageFile.dart';
import '../../../../Helpers/SelectableAircraftCard.dart';
import '../../../../Helpers/SearchBarWidget.dart';
import '../../../../bloc/Home/AircraftComparison/AircraftComparisonCubit.dart';
import '../../../../bloc/Home/AircraftComparison/AircraftComparisonState.dart';

class AircraftComparisonScreen extends StatefulWidget {
  final String? selectedModel1;
  final String? selectedModel2;

  const AircraftComparisonScreen({
    super.key,
    this.selectedModel1,
    this.selectedModel2,
  });

  @override
  State<AircraftComparisonScreen> createState() =>
      _AircraftComparisonScreenState();
}

class _AircraftComparisonScreenState extends State<AircraftComparisonScreen> {
  late final AircraftComparisonCubit _cubit;
  final TextEditingController searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _cubit = AircraftComparisonCubit()..loadAircraftModels(context: context);
    _scrollController.addListener(_onScroll);
    AnalyticsService.instance.logVisibleScreen(
      FirebaseEvents.aircraftComparisonScreen,
    );
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      if (_cubit.state.hasNextPage && !_cubit.state.isFetchingMore) {
        _cubit.loadAircraftModels(context: context, isLoadMore: true);
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _cubit.close();
    searchController.dispose();
    super.dispose();
  }

  void _onSearch(String value) {
    _cubit.loadAircraftModels(context: context, query: value, page: 1);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Dynamic sizes
    double bodyFontSize = kIsWeb ? screenWidth * 0.015 : 16;
    double cardHeight = kIsWeb ? 120 : 80;
    double imageWidth = kIsWeb ? screenWidth * 0.12 : screenWidth * 0.22;
    double imageHeight = cardHeight - 20;

    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kIsWeb ? 130 : 110),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SearchBarWidget(
                  enableBackArrow: true,
                  enableFilter: false,
                  enableCloseScreen: false,
                  controller: searchController,
                  onChanged: _onSearch,
                  searchTitle: 'Search Models',
                  onBackButtonTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: kIsWeb ? 1500 : double.infinity,
            ),
            child: SafeArea(
              child: BlocBuilder<AircraftComparisonCubit, AircraftState>(
                builder: (context, state) {
                  final models = state.aircraftList.where((model) {
                    final selected1 = widget.selectedModel1;
                    final selected2 = widget.selectedModel2;
                    final currentId = model.id;
                    return currentId != selected1 && currentId != selected2;
                  }).toList();

                  if (state.isLoading) {
                    return const Scaffold(
                      backgroundColor: Colors.white,
                      body: Center(child: CircularProgressIndicator()),
                    );
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: kIsWeb ? screenWidth * 0.01 : screenWidth * 0.04),
                      Padding(
                        padding: EdgeInsets.only(
                          left: kIsWeb ? screenWidth * 0.03 : screenWidth * 0.06,
                        ),
                        child: AppTexts(
                          text: "Select Model for Comparison",
                          imageName: null,
                          font: 'Roboto',
                          side: 'left',
                          color: const Color(0xFF3F3D56),
                          weight: FontWeight.w600,
                          fontSize: kIsWeb ? screenWidth * 0.02 : screenWidth * 0.04,
                          imageSize: kIsWeb ? screenWidth * 0.02 : screenWidth * 0.04,
                        ),
                      ),
                      SizedBox(height: kIsWeb ? screenWidth * 0.01 : screenWidth * 0.04),

                      // Scrollable list
                      Flexible(
                        child: models.isEmpty
                            ? const Center(
                          child: Text(
                            'No Compare models available',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        )
                            : ScrollConfiguration(
                          behavior: const ScrollBehavior().copyWith(
                            scrollbars: true,
                            dragDevices: {
                              PointerDeviceKind.touch,
                              PointerDeviceKind.mouse,
                            },
                          ),
                          child: ListView.builder(
                            controller: _scrollController,
                            padding: EdgeInsets.only(
                              bottom: screenWidth * 0.05,
                              left: screenWidth * 0.025,
                              right: screenWidth * 0.025,
                            ),
                            physics: const BouncingScrollPhysics(),
                            itemCount: models.length + (state.isFetchingMore ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index >= models.length) {
                                if (state.hasNextPage) {
                                  return const Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Center(child: CircularProgressIndicator()),
                                  );
                                } else {
                                  return const Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Center(
                                      child: Text(
                                        "No more models",
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ),
                                  );
                                }
                              }

                              final model = models[index];

                              // Web layout
                              if (kIsWeb) {
                                return Padding(
                                  key: ValueKey(model.id),
                                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.pop(context, model);
                                    },
                                    child: Container(
                                      height: cardHeight,
                                      clipBehavior: Clip.hardEdge,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(5),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.08),
                                            blurRadius: 5,
                                            spreadRadius: 1,
                                            offset: const Offset(0, 1),
                                          ),
                                        ],
                                      ),
                                      padding: const EdgeInsets.all(10),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          CachedAnyImage(
                                            key: ValueKey(model.image),
                                            imagePath: model.image,
                                            width: imageWidth,
                                            height: imageHeight,
                                            contentImage: BoxFit.cover,
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      model.aircraftModel,
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.w600,
                                                        fontSize: bodyFontSize,
                                                      ),
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                    if (model.icaoTypeCode.isNotEmpty)
                                                      Padding(
                                                        padding: const EdgeInsets.only(left: 8.0),
                                                        child: Container(
                                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                          decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius: BorderRadius.circular(4),
                                                            boxShadow: const [
                                                              BoxShadow(color: Colors.grey, spreadRadius: 0.1),
                                                            ],
                                                          ),
                                                          child: Text(
                                                            model.icaoTypeCode,
                                                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                                                          ),
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                                const SizedBox(height: 6),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius: BorderRadius.circular(2),
                                                      child: SizedBox(
                                                        width: 40,
                                                        height: 40,
                                                        child: CachedAnyImage(
                                                          imagePath: model.manufacturer?.logo ?? "",
                                                          width: 40,
                                                          height: 40,
                                                          contentImage: BoxFit.contain,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 8),
                                                    if (model.manufacturer?.companyName != null)
                                                      Text(
                                                        model.manufacturer?.companyName ?? "",
                                                        style: const TextStyle(fontSize: 13),
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Icon(Icons.arrow_forward_ios, size: 30),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                // Mobile layout
                                return Padding(
                                  key: ValueKey(model.id),
                                  padding: EdgeInsets.symmetric(vertical: screenWidth * 0.017),
                                  child: SimpleAircraftCard(
                                    imagePath: CachedAnyImage(
                                      imagePath: model.image,
                                      width: screenWidth * 0.15,
                                      height: screenWidth * 0.15,
                                      contentImage: BoxFit.fill,
                                    ),
                                    model: model.aircraftModel,
                                    badge: model.icaoTypeCode,
                                    callSign: "",
                                    manufacturer: model.manufacturer?.companyName,
                                    airline: null,
                                    airlineImagePath: CachedAnyImage(
                                      imagePath: model.manufacturer?.logo ?? "",
                                      width: screenWidth * 0.05,
                                      height: screenWidth * 0.05,
                                      contentImage: BoxFit.fill,
                                    ),
                                    onTap: () {
                                      Navigator.pop(context, model);
                                    },
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
