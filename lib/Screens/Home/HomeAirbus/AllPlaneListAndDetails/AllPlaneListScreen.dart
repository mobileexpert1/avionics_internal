import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../Constants/ApiClass/FirebaseAnalytics/analytics_service.dart';
import '../../../../Constants/ApiClass/FirebaseAnalytics/event_names.dart';
import '../../../../Constants/AppColors.dart';
import '../../../../Constants/constantImages.dart';
import '../../../../CustomFiles/CustomAppBar.dart';
import '../../../../CustomFiles/Custom_SnackBar.dart';
import '../../../../Helpers/AppTextStyles/AppTextStyles.dart';
import '../../../../Helpers/CacheManger/CachedImageFile.dart';
import '../../../../Helpers/SearchBarWidget.dart';
import '../../../../bloc/Home/AirCraftDetail/airCraftDetail_cubit.dart';
import '../../../../bloc/Home/AllPlanesBloc/AllPlanes_cubit.dart';
import '../../../../bloc/Home/AllPlanesBloc/AllPlanes_state.dart';
import '../../../Profile/SettingScreen/SettingScreen.dart';
import '../AirCraftSection/AirCraftDetailScreen.dart';

class AllPlanesListScreen extends StatefulWidget {
  final String selectedAirbusId;
  final String manufacturerName;

  const AllPlanesListScreen({
    super.key,
    required this.selectedAirbusId,
    required this.manufacturerName,
  });

  @override
  State<AllPlanesListScreen> createState() => _AllPlanesScreenState();
}

class _AllPlanesScreenState extends State<AllPlanesListScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AllPlanesCubit>().loadListOAllAirbusModels(
        selectedAirbusId: widget.selectedAirbusId,
        context: context,
      );
    });
    AnalyticsService.instance.logVisibleScreen(
      FirebaseEvents.airCraftDetailScreen,
    );
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100) {
      final cubit = context.read<AllPlanesCubit>();
      if (cubit.state.hasNextPage && !cubit.state.isFetchingMore) {
        cubit.loadListOAllAirbusModels(
          context: context,
          page: cubit.state.currentPage + 1,
          isLoadMore: true,
          selectedAirbusId: widget.selectedAirbusId,
        );
      }
    }
  }

  void _onSearch(String value) {
    context.read<AllPlanesCubit>().loadListOAllAirbusModels(
      context: context,
      query: value,
      page: 1,
      selectedAirbusId: widget.selectedAirbusId,
    );
  }

  String normalizeWikiImage(String url) {
    if (!url.contains('upload.wikimedia.org')) return url;

    final fileName = url.split('/').last;
    return 'https://commons.wikimedia.org/wiki/Special:FilePath/$fileName';
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    double paddingHorizontal = kIsWeb ? screenWidth * 0.02 : 20;

    // card height for web
    double cardHeight = kIsWeb ? 120 : 80;
    double imageWidth = kIsWeb ? screenWidth * 0.12 : screenWidth * 0.22;
    double imageHeight = cardHeight - 20;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(
        title: "All ${widget.manufacturerName} Models",
        //'Search ${widget.manufacturerName} Models',
        centerTitle: false,
        leftButton: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        rightButton: IconButton(
          icon: SvgPicture.asset(
            CommonUi.setSvgImage(AssetsPath.homeRightSetting),
            width: 35,
            height: 31,
            fit: BoxFit.cover,
          ),
          onPressed: () async {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingScreen()),
            );
          },
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1500),
            child: Column(
              children: [
                PreferredSize(
                  preferredSize: Size.fromHeight(kIsWeb ? 130 : 110),
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
                          searchTitle:
                              'Search ${widget.manufacturerName} Models',
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: paddingHorizontal),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'All ${widget.manufacturerName} Models',
                      style: AppTextStyles.bold(20).copyWith(
                        height: 1.0,
                        color: AppColors.primaryValueColour,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: kIsWeb ? 10 : 10),
                Expanded(
                  child: BlocBuilder<AllPlanesCubit, AllPlanesState>(
                    builder: (context, state) {
                      if (state.isLoading) {
                        return const Scaffold(
                          backgroundColor: Colors.white,
                          body: Center(child: CircularProgressIndicator()),
                        );
                      }

                      if (state.listoFAircraftModels.isEmpty) {
                        return const Center(
                          child: Text(
                            'No models available',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        );
                      }

                      return ListView.builder(
                        controller: _scrollController,
                        padding: EdgeInsets.zero,
                        itemCount: state.listoFAircraftModels.length,
                        itemBuilder: (context, index) {
                          final model = state.listoFAircraftModels[index];

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Stack(
                              children: [
                                /// 🔹 BACKGROUND (Swipe ke time visible)
                                Positioned.fill(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.saveButtonColour,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 50,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade200,
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          child: CachedAnyImage(
                                            imagePath: model.image,
                                            contentImage: BoxFit.cover,
                                            isForPlaneList: true,
                                            width: imageWidth,
                                            height: imageHeight,
                                          ),
                                        ),

                                        const Spacer(),

                                        /// BOOKMARK ICON
                                        Icon(
                                          Icons.bookmark,
                                          color: model.isSaved
                                              ? Colors.black
                                              : Colors.white,
                                          size: 26,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                /// 🔹 FOREGROUND (Main UI)
                                Slidable(
                                  key: ValueKey(model.id),
                                  endActionPane: ActionPane(
                                    motion: const BehindMotion(),
                                    extentRatio: 0.2,
                                    children: [
                                      CustomSlidableAction(
                                        onPressed: (_) {
                                          context
                                              .read<AllPlanesCubit>()
                                              .toggleFavorite(
                                                model.id,
                                                context,
                                                model.isSaved,
                                              );

                                          AppSnackBar.custom(
                                            context,
                                            message: model.isSaved
                                                ? "Bookmark Unsaved"
                                                : "Bookmark Saved",
                                            svgAsset: "",
                                          );
                                        },
                                        backgroundColor: Colors.transparent,
                                        child: const SizedBox.shrink(),
                                      ),
                                    ],
                                  ),

                                  child: InkWell(
                                    onTap: () {
                                      AnalyticsService.instance.buttonPressed(
                                        FirebaseEvents
                                            .manufacturerListItemButton,
                                        FirebaseEvents.allPlanesListScreen,
                                      );

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => BlocProvider(
                                            create: (_) =>
                                                AirCraftDetailCubit(),
                                            child: AirCraftDetailScreen(
                                              aircraftId: model.id,
                                            ),
                                          ),
                                        ),
                                      );
                                    },

                                    child: Container(
                                      height: 60,
                                      color: Colors.white,
                                      child: Stack(
                                        children: [
                                          Positioned(
                                            right: 33,
                                            top: 32,
                                            child: Container(
                                              width: 16,
                                              height: 16,
                                              decoration: BoxDecoration(
                                                color: Colors.amber,
                                                border: Border.all(
                                                  color: Colors.black,
                                                  width: 0.5,
                                                ),
                                              ),
                                            ),
                                          ),

                                          Positioned(
                                            left: 100,
                                            right: 40,
                                            top: 40,
                                            child: Container(
                                              height: 1,
                                              color: Colors.grey.shade400,
                                            ),
                                          ),

                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              const SizedBox(width: 10),

                                              Container(
                                                width: 80,
                                                height: 50,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey.shade200,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: CachedAnyImage(
                                                  imagePath: model.image,
                                                  contentImage: BoxFit.cover,
                                                  isForPlaneList: true,
                                                  width: imageWidth,
                                                  height: imageHeight,
                                                ),
                                              ),

                                              const SizedBox(width: 12),

                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        bottom: 8,
                                                      ),
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          model.model,
                                                          style:
                                                              AppTextStyles.bold(
                                                                18,
                                                              ).copyWith(
                                                                height: 1.0,
                                                                color: AppColors
                                                                    .planListTitleColour,
                                                              ),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),

                                                      if (model
                                                          .ICAOCode
                                                          .isNotEmpty)
                                                        Container(
                                                          margin:
                                                              const EdgeInsets.only(
                                                                left: 8,
                                                              ),
                                                          padding:
                                                              const EdgeInsets.symmetric(
                                                                horizontal: 10,
                                                                vertical: 5,
                                                              ),
                                                          decoration: BoxDecoration(
                                                            color: Colors
                                                                .grey
                                                                .shade200,
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  20,
                                                                ),
                                                          ),

                                                          child: Text(
                                                            model.ICAOCode,
                                                            style:
                                                                AppTextStyles.medium(
                                                                  18,
                                                                ).copyWith(
                                                                  height: 1.0,
                                                                  color: AppColors
                                                                      .planListTitleColour,
                                                                ),
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                                ),
                                              ),

                                              const SizedBox(width: 60),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
