import 'package:avionics_internal/bloc/Home/AllPlanesBloc/AllPlanes_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../../../Constants/AppColors.dart';
import '../../../../Helpers/CacheManger/CachedImageFile.dart';
import '../../../../Helpers/SearchBarWidget.dart';
import '../../../../bloc/Home/AirCraftDetail/airCraftDetail_cubit.dart';
import '../../../../bloc/Home/AllPlanesBloc/AllPlanes_cubit.dart';
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
    context.read<AllPlanesCubit>().loadListOAllAirbusModels(
      selectedAirbusId: widget.selectedAirbusId,
      context: context,
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
    final cubit = context.read<AllPlanesCubit>();
    cubit.loadListOAllAirbusModels(
      context: context,
      query: value,
      page: 1,
      selectedAirbusId: widget.selectedAirbusId,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900), // Web max width
            child: Column(
              children: [
                const SizedBox(height: 10),
                SearchBarWidget(
                  enableBackArrow: true,
                  enableFilter: false,
                  enableCloseScreen: false,
                  controller: searchController,
                  onChanged: _onSearch,
                  searchTitle: 'Search ${widget.manufacturerName} Models',
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'All ${widget.manufacturerName} Models',
                      style: TextStyle(
                        fontSize: screenWidth > 600 ? 18 : 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
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
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 30,
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
                                      size: 25,
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
                                                model.id,
                                                context,
                                              );
                                          debugPrint("Tapped delete");
                                        },
                                        backgroundColor: Colors.transparent,
                                        child: const SizedBox.shrink(),
                                      ),
                                    ],
                                  ),
                                  child: Container(
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
                                    child: ListTile(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 10,
                                          ),
                                      leading: CachedAnyImage(
                                        imagePath: model.image,
                                        width: screenWidth * 0.18,
                                        height: screenWidth * 0.1,
                                        contentImage: BoxFit.fill,
                                      ),
                                      title: Wrap(
                                        crossAxisAlignment:
                                            WrapCrossAlignment.center,
                                        spacing: 8,
                                        runSpacing: 4,
                                        children: [
                                          Text(
                                            model.model,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: screenWidth > 600
                                                  ? 18
                                                  : 16,
                                            ),
                                          ),
                                          if (model.ICAOCode.isNotEmpty)
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 6,
                                                    vertical: 2,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                boxShadow: const [
                                                  BoxShadow(
                                                    color: Colors.grey,
                                                    spreadRadius: 0.1,
                                                  ),
                                                ],
                                              ),
                                              child: Text(
                                                model.ICAOCode,
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),

                                      trailing: const Icon(
                                        Icons.arrow_forward_ios,
                                        size: 15,
                                      ),
                                      onTap: () {
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

                                        // Navigator.push(
                                        //   context,
                                        //   MaterialPageRoute(
                                        //     builder: (context) =>
                                        //         AirCraftDetailScreen(
                                        //           aircraftId: model.id,
                                        //         ),
                                        //   ),
                                        // );
                                      },
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