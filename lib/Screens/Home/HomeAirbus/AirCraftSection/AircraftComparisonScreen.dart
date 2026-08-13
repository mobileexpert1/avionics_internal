import 'dart:async';
import 'dart:ui';

import 'package:avionics_internal/CustomFiles/CustomAppBar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../Constants/ApiClass/FirebaseAnalytics/analytics_service.dart';
import '../../../../Constants/ApiClass/FirebaseAnalytics/event_names.dart';
import '../../../../Constants/AppColors.dart';
import '../../../../Constants/constantImages.dart';
import '../../../../Helpers/AppTextStyles/AppTextStyles.dart';
import '../../../../Helpers/CacheManger/CachedImageFile.dart';
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
  Timer? _debounce;

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
    _debounce?.cancel();
    _scrollController.dispose();
    _cubit.close();
    searchController.dispose();
    super.dispose();
  }

  void _onSearch(String value) {
    _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      _cubit.loadAircraftModels(context: context, query: value, page: 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final bool isDesktopWeb = kIsWeb && screenWidth >= 900;

    // Dynamic sizes
    double bodyFontSize = isDesktopWeb ? screenWidth * 0.015 : 16;
    double cardHeight = isDesktopWeb ? 120 : 80;
    double imageWidth = isDesktopWeb ? screenWidth * 0.12 : screenWidth * 0.22;
    double imageHeight = cardHeight - 20;

    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          title: 'Models Lists',
          centerTitle: false,
          leftButton: IconButton(
            icon: SvgPicture.asset(
              CommonUi.setSvgImage(AssetsPath.backArrowButton),
              fit: BoxFit.cover,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isDesktopWeb ? 1500 : double.infinity,
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
                      SizedBox(
                        height: isDesktopWeb
                            ? screenWidth * 0.01
                            : screenWidth * 0.03,
                      ),
                      PreferredSize(
                        preferredSize: Size.fromHeight(
                          isDesktopWeb ? 130 : 110,
                        ),
                        child: SafeArea(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SearchBarWidget(
                                enableBackArrow: false,
                                enableFilter: false,
                                enableCloseScreen: false,
                                controller: searchController,
                                onChanged: _onSearch,
                                searchTitle: 'Select Model for Comparison',
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: isDesktopWeb
                            ? screenWidth * 0.01
                            : screenWidth * 0.02,
                      ),

                      // Scrollable list
                      Flexible(
                        child: models.isEmpty
                            ? const Center(
                                child: Text(
                                  'No Compare models available',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
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
                                  itemCount:
                                      models.length +
                                      (state.isFetchingMore ? 1 : 0),
                                  itemBuilder: (context, index) {
                                    if (index >= models.length) {
                                      if (state.hasNextPage) {
                                        return const Padding(
                                          padding: EdgeInsets.all(16),
                                          child: Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                        );
                                      } else {
                                        return Padding(
                                          padding: EdgeInsets.all(16),
                                          child: Center(
                                            child: Text(
                                              "No more models",
                                              style: AppTextStyles.medium(14)
                                                  .copyWith(
                                                    height: 1.0,
                                                    color: AppColors.grayMedium,
                                                  ),
                                            ),
                                          ),
                                        );
                                      }
                                    }

                                    final model = models[index];
                                    if (isDesktopWeb) {
                                      return Padding(
                                        key: ValueKey(model.id),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 10.0,
                                        ),
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.pop(context, model);
                                          },
                                          child: Container(
                                            height: cardHeight,
                                            clipBehavior: Clip.hardEdge,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.08),
                                                  blurRadius: 5,
                                                  spreadRadius: 1,
                                                  offset: const Offset(0, 1),
                                                ),
                                              ],
                                            ),
                                            padding: const EdgeInsets.all(10),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                CachedAnyImage(
                                                  key: ValueKey(model.image),
                                                  imagePath: model.image,
                                                  width: imageWidth,
                                                  height: imageHeight,
                                                  contentImage: BoxFit.cover,
                                                  isForPlaneList: true,
                                                ),
                                                const SizedBox(width: 10),
                                                Expanded(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            model.aircraftModel,
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize:
                                                                  bodyFontSize,
                                                            ),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                          if (model
                                                              .icaoTypeCode
                                                              .isNotEmpty)
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets.only(
                                                                    left: 8.0,
                                                                  ),
                                                              child: Container(
                                                                padding:
                                                                    const EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          6,
                                                                      vertical:
                                                                          2,
                                                                    ),
                                                                decoration: BoxDecoration(
                                                                  color: Colors
                                                                      .white,
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                        4,
                                                                      ),
                                                                  boxShadow: const [
                                                                    BoxShadow(
                                                                      color: Colors
                                                                          .grey,
                                                                      spreadRadius:
                                                                          0.1,
                                                                    ),
                                                                  ],
                                                                ),
                                                                child: Text(
                                                                  model
                                                                      .icaoTypeCode,
                                                                  style: const TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          ClipRRect(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  2,
                                                                ),
                                                            child: SizedBox(
                                                              width: 90,
                                                              height: 40,
                                                              child: CachedAnyImage(
                                                                imagePath:
                                                                    model
                                                                        .manufacturer
                                                                        ?.logo ??
                                                                    "",
                                                                width: 40,
                                                                height: 40,
                                                                contentImage:
                                                                    BoxFit
                                                                        .contain,
                                                                isForPlaneList:
                                                                    true,
                                                              ),
                                                            ),
                                                          ),
                                                          // const SizedBox(
                                                          //   width: 8,
                                                          // ),
                                                          // if (model
                                                          //         .manufacturer
                                                          //         ?.companyName !=
                                                          //     null)
                                                          //   Text(
                                                          //     model
                                                          //             .manufacturer
                                                          //             ?.companyName ??
                                                          //         "",
                                                          //     style:
                                                          //         const TextStyle(
                                                          //           fontSize:
                                                          //               13,
                                                          //         ),
                                                          //     overflow:
                                                          //         TextOverflow
                                                          //             .ellipsis,
                                                          //   ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox.shrink(),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    } else {
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.pop(context, model);
                                        },
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 5,
                                                    horizontal: 10,
                                                  ),
                                              child: Row(
                                                children: [
                                                  model.image != null &&
                                                          model.image.isNotEmpty
                                                      ? CachedAnyImage(
                                                          useCache: true,
                                                          imagePath:
                                                              model.image,
                                                          width: 70,
                                                          height: 70,
                                                          contentImage:
                                                              BoxFit.contain,
                                                          isForPlaneList: true,
                                                        )
                                                      : SvgPicture.asset(
                                                          CommonUi.setSvgImage(
                                                            AssetsPath
                                                                .manufacturerPlaceholder,
                                                          ),
                                                          width: 40,
                                                          height: 40,
                                                        ),

                                                  const SizedBox(width: 20),

                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          model.aircraftModel,
                                                          style:
                                                              const TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: Color(
                                                                  0xFF3F3D56,
                                                                ),
                                                              ),
                                                        ),

                                                        Row(
                                                          children: [
                                                            ClipRRect(
                                                              child: SizedBox(
                                                                width:
                                                                    model
                                                                        .manufacturer!
                                                                        .logo
                                                                        .contains(
                                                                          "fi_corp.svg",
                                                                        )
                                                                    ? 30
                                                                    : 60,
                                                                height:
                                                                    model
                                                                        .manufacturer!
                                                                        .logo
                                                                        .contains(
                                                                          "fi_corp.svg",
                                                                        )
                                                                    ? 30
                                                                    : 20,
                                                                child: CachedAnyImage(
                                                                  imagePath:
                                                                      model
                                                                          .manufacturer
                                                                          ?.logo ??
                                                                      "",
                                                                  width:
                                                                      screenWidth *
                                                                      0.06,
                                                                  height:
                                                                      screenWidth *
                                                                      0.06,
                                                                  contentImage:
                                                                      BoxFit
                                                                          .fill,
                                                                  isForPlaneList:
                                                                      true,
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              width: 5,
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            Divider(
                                              height: 1,
                                              thickness: 1,
                                              color: Colors.grey.shade300,
                                            ),
                                          ],
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
