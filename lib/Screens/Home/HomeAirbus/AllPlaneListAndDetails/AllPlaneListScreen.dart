import 'package:avionics_internal/bloc/Home/AllPlanesBloc/AllPlanes_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../Constants/AppColors.dart';
import '../../../../Constants/constantImages.dart';
import '../../../../Helpers/SearchBarWidget.dart';
import '../../../../bloc/Home/AllPlanesBloc/AllPlanes_cubit.dart';
import '../AirCraftSection/AirCraftDetailScreen.dart';

class AllPlanesListScreen extends StatefulWidget {
  final String selectedAirbusId;

  const AllPlanesListScreen({super.key, required this.selectedAirbusId});

  @override
  State<AllPlanesListScreen> createState() => _AllPlanesScreenState();
}

class _AllPlanesScreenState extends State<AllPlanesListScreen> {
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<AllPlanesCubit>().loadListOAllAirbusModels(
      selectedAirbusId: widget.selectedAirbusId,
      context: context,
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
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'ALL AIRBUS MODELS',
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
                                      leading: _buildLeadingImage(
                                        screenWidth * 0.15,
                                        screenWidth * 0.15,
                                        model.image!,
                                        (model.image ?? '').contains(
                                          ".svg",
                                        ),
                                        !(model.image ?? '').contains(
                                          ".svg",
                                        ),
                                      ),
                                      title: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              model.model,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: screenWidth > 600
                                                    ? 18
                                                    : 16,
                                              ),
                                            ),
                                          ),
                                          if ((model.model).isNotEmpty)
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
                                            builder: (context) =>
                                                AirCraftDetailScreen(
                                                  aircraftId: model.id,
                                                  airCraftName: model.model,
                                                  // aircraftId: model.id,
                                                  // aircraftName: model.model,
                                                ),
                                          ),
                                        );
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

Widget _buildLeadingImage(
  double width,
  double height,
  String imagePath,
  bool isLocalSvgAsset,
  bool isNetwork,
) {
  if (isLocalSvgAsset) {
    if (imagePath.contains("assets")) {
      return SizedBox(
        width: width,
        height: height,
        child: SvgPicture.asset(
          imagePath,
          fit: BoxFit.contain,
          alignment: Alignment.center,
        ),
      );
    } else {
      return SizedBox(
        width: width,
        height: height,
        child: SvgPicture.network(
          imagePath,
          fit: BoxFit.contain,
          alignment: Alignment.center,
          placeholderBuilder: (context) => SvgPicture.asset(
            CommonUi.setSvgImage(AssetsPath.manuFirstImage),
            height: height,
            width: width,
            fit: BoxFit.contain,
          ),
        ),
      );
    }
  } else if (isNetwork) {
    return Image.network(
      imagePath,
      height: height,
      width: width,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) => SvgPicture.asset(
        CommonUi.setSvgImage(AssetsPath.manuFirstImage),
        height: height,
        width: width,
        fit: BoxFit.contain,
      ),
    );
  } else {
    return Image.asset(
      imagePath,
      height: height,
      width: width,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) => SvgPicture.asset(
        CommonUi.setSvgImage(AssetsPath.manuFirstImage),
        height: height,
        width: width,
        fit: BoxFit.contain,
      ),
    );
  }
}
