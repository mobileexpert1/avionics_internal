import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../Constants/constantImages.dart';
import '../../../../Helpers/AppText.dart';
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
  State<AircraftComparisonScreen> createState() => _AircraftComparisonScreenState();
}

class _AircraftComparisonScreenState extends State<AircraftComparisonScreen> {
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void _onSearch(String value) {
    context.read<AircraftComparisonCubit>().loadAircraftModels(
      context: context,
      query: value,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return BlocProvider(
      create: (_) => AircraftComparisonCubit()..loadAircraftModels(context: context),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: BlocBuilder<AircraftComparisonCubit, AircraftState>(
            builder: (context, state) {
              final models = state.aircraftList.where((model) {
                final selected1 = widget.selectedModel1;
                final selected2 = widget.selectedModel2;
                final currentId = model.id;
                return currentId != selected1 && currentId != selected2;
              }).toList();
              if (state.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: screenWidth * 0.0),

                  /// 🔍 Search Bar
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                    child: SearchBarWidget(
                      enableBackArrow: true,
                      enableFilter: false,
                      enableCloseScreen: false,
                      controller: searchController,
                      onChanged: _onSearch,
                      onFilterTap: () {
                        context.read<AircraftComparisonCubit>().loadAircraftModels(
                          context: context,
                          query: searchController.text,
                        );
                      },
                      searchTitle: 'Search Models',
                    ),
                  ),

                  SizedBox(height: screenWidth * 0.04),

                  /// 🧾 Title
                  Padding(
                    padding: EdgeInsets.only(left: screenWidth * 0.06),
                    child: AppTexts(
                      text: "Select Model for Comparison",
                      imageName: null,
                      font: 'Roboto',
                      side: 'left',
                      color: const Color(0xFF3F3D56),
                      weight: FontWeight.w600,
                      fontSize: screenWidth * 0.04,
                      imageSize: screenWidth * 0.04,
                    ),
                  ),

                  SizedBox(height: screenWidth * 0.03),

                  /// 🛩 Aircraft List
                  Expanded(
                    child: models.isEmpty
                        ? const Center(
                      child: Text(
                        'No Compare models available',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                        : ListView.builder(
                      padding: EdgeInsets.only(
                        bottom: screenWidth * 0.05,
                        left: screenWidth * 0.025,
                        right: screenWidth * 0.025,
                      ),
                      physics: const BouncingScrollPhysics(),
                      itemCount: models.length,
                      itemBuilder: (context, index) {
                        final model = models[index];
                        return Padding(
                          key: ValueKey(model.id),
                          padding: EdgeInsets.symmetric(
                            vertical: screenWidth * 0.017,
                          ),
                          child: SimpleAircraftCard(
                            imagePath: _buildLeadingImage(
                              screenWidth * 0.15,
                              screenWidth * 0.15,
                              model.image ?? '',
                              (model.image ?? '').contains(".svg"),
                              !(model.image ?? '').contains(".svg"),
                            ),
                            model: model.aircraftModel,
                            badge: model.icaoTypeCode,
                            manufacturer: model.manufacturer?.companyName,
                            airline: null,
                            airlineImagePath: _buildLeadingImage(
                              screenWidth * 0.05,
                              screenWidth * 0.05,
                              model.manufacturer?.logo ?? '',
                              (model.manufacturer?.logo ?? '').contains(".svg"),
                              !(model.manufacturer?.logo ?? '').contains(".svg"),
                            ),
                            onTap: () {
                              Navigator.pop(context, model);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  /// ⬇️ Image Rendering Helper
  Widget _buildLeadingImage(
      double width,
      double height,
      String imagePath,
      bool isLocalSvgAsset,
      bool isNetwork,
      ) {
    if (isLocalSvgAsset) {
      return SizedBox(
        width: width,
        height: height,
        child: SvgPicture.asset(
          imagePath,
          fit: BoxFit.contain,
          alignment: Alignment.center,
        ),
      );
    } else if (isNetwork) {
      if (imagePath.contains(".svg")) {
        return SizedBox(
          width: width,
          height: height,
          child: SvgPicture.network(
            imagePath,
            fit: BoxFit.fill,
            alignment: Alignment.center,
            placeholderBuilder: (context) => SvgPicture.asset(
              CommonUi.setSvgImage(AssetsPath.manuFirstImage),
              height: height,
              width: width,
              fit: BoxFit.contain,
            ),
          ),
        );
      } else {
        return Image.network(
          imagePath,
          height: height,
          width: width,
          fit: BoxFit.fill,
          errorBuilder: (context, error, stackTrace) => SvgPicture.asset(
            CommonUi.setSvgImage(AssetsPath.manuFirstImage),
            height: height,
            width: width,
            fit: BoxFit.contain,
          ),
        );
      }
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

}
