import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../../../Constants/ApiClass/FirebaseAnalytics/analytics_service.dart';
import '../../../../Constants/ApiClass/FirebaseAnalytics/event_names.dart';
import '../../../../Constants/AppColors.dart';
import '../../../../CustomFiles/Custom_SnackBar.dart';
import '../../../../Helpers/CacheManger/CachedImageFile.dart';
import '../../../../Helpers/SearchBarWidget.dart';
import '../../../../bloc/Home/AirCraftDetail/airCraftDetail_cubit.dart';
import '../../../../bloc/Home/AllPlanesBloc/AllPlanes_cubit.dart';
import '../../../../bloc/Home/AllPlanesBloc/AllPlanes_state.dart';
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
    AnalyticsService.instance.logVisibleScreen(FirebaseEvents.airCraftDetailScreen);
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

    double titleFontSize = kIsWeb ? screenWidth * 0.02 : 18;
    double bodyFontSize = kIsWeb ? screenWidth * 0.015 : 16;
    double paddingHorizontal = kIsWeb ? screenWidth * 0.02 : 20;

    // card height for web
    double cardHeight = kIsWeb ? 120 : 80;
    double imageWidth = kIsWeb ? screenWidth * 0.12 : screenWidth * 0.22;
    double imageHeight = cardHeight - 20;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
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
                searchTitle: 'Search ${widget.manufacturerName} Models',
                onBackButtonTap: () {
                  Navigator.pop(context);
                },
              )
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1500),
            child: Column(
              children: [
                SizedBox(height: kIsWeb ? 15 : 10),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: paddingHorizontal),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'All ${widget.manufacturerName} Models',
                      style: TextStyle(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: kIsWeb ? 10 : 10),
                Expanded(
                  child: BlocBuilder<AllPlanesCubit, AllPlanesState>(
                    builder: (context, state) {
                      if (state.isLoading) {
                        return const Center(child: CircularProgressIndicator());
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
                          double cardHorizontalPadding =
                          kIsWeb ? screenWidth * 0.02 : 30;

                          return Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: kIsWeb ? 8 : 10,
                              horizontal: cardHorizontalPadding,
                            ),
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.saveButtonColour,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    alignment: Alignment.centerRight,
                                    padding: const EdgeInsets.only(right: 13),
                                    child: Icon(
                                      Icons.bookmark,
                                      color: (model.isFavorite == true
                                          ? Colors.black
                                          : Colors.white),
                                      size: kIsWeb ? 22 : 25,
                                    ),
                                  ),
                                ),
                                Slidable(
                                  key: ValueKey(model.id),
                                  endActionPane: ActionPane(
                                    motion: const BehindMotion(),
                                    extentRatio: 0.15,
                                    children: [
                                      CustomSlidableAction(
                                          onPressed: (_) {
                                            context
                                                .read<AllPlanesCubit>()
                                                .toggleFavorite(
                                                model.id, context);

                                            AppSnackBar.custom(
                                              context,
                                              message: model.isFavorite ? "Bookmark Unsaved" : "Bookmark Saved",
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


                                      AnalyticsService.instance.buttonPressed(FirebaseEvents.manufacturerListItemButton,FirebaseEvents.allPlanesListScreen);



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
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        children: [
                                          /// CODE 1
                                          CachedAnyImage(
                                            imagePath: model.image,
                                            width: imageWidth,
                                            height: imageHeight,
                                            contentImage: BoxFit.cover,
                                          ),
                                          /// CODE 2
                                          // CachedNetworkImage(
                                          //   imageUrl: model.image ?? '',
                                          //   width: imageWidth,
                                          //   height: imageHeight,
                                          //   fit: BoxFit.cover,
                                          //   httpHeaders: const {
                                          //     'User-Agent': 'Mozilla/5.0',
                                          //     'Accept': 'image/*',
                                          //   },
                                          //   placeholder: (context, url) =>
                                          //   const Center(child: CircularProgressIndicator()),
                                          //   errorWidget: (context, url, error) =>
                                          //   const Icon(Icons.broken_image),
                                          // )
                                          /// CODE 3
                                          // CachedNetworkImage(
                                          //   imageUrl: normalizeWikiImage(model.image ?? ''),
                                          //   width: imageWidth,
                                          //   height: imageHeight,
                                          //   fit: BoxFit.cover,
                                          //   placeholder: (_, __) => const Center(child: CircularProgressIndicator()),
                                          //   errorWidget: (_, __, ___) => const Icon(Icons.broken_image),
                                          // ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                              kIsWeb ? CrossAxisAlignment.center: CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              children: [
                                                Flexible(
                                                  child: Wrap(
                                                    crossAxisAlignment:
                                                    WrapCrossAlignment.center,
                                                    spacing: 8,
                                                    runSpacing: 4,
                                                    children: [
                                                      Text(
                                                        model.model,
                                                        style: TextStyle(
                                                          fontWeight:
                                                          FontWeight.w600,
                                                          fontSize: bodyFontSize,
                                                        ),
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                      if (model.ICAOCode.isNotEmpty)
                                                        Container(
                                                          padding:
                                                          const EdgeInsets
                                                              .symmetric(
                                                            horizontal: 6,
                                                            vertical: 2,
                                                          ),
                                                          decoration:
                                                          BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(4),
                                                            boxShadow: const [
                                                              BoxShadow(
                                                                color:
                                                                Colors.grey,
                                                                spreadRadius: 0.1,
                                                              ),
                                                            ],
                                                          ),
                                                          child: Text(
                                                            model.ICAOCode,
                                                            style:
                                                            const TextStyle(
                                                              fontSize: 12,
                                                              fontWeight:
                                                              FontWeight.w500,
                                                            ),
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Icon(Icons.arrow_forward_ios,
                                              size: kIsWeb ? 30 :15),
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
