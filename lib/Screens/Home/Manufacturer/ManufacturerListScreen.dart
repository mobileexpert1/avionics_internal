import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../../Helpers/AppText.dart';
import '../../../Helpers/SearchBarWidget.dart';
import '../../../bloc/home/manufacturer/manufacturer_cubit.dart';
import '../../../bloc/home/manufacturer/manufacturer_state.dart';
import 'ManufacturerDetailScreen.dart';

class ManufacturerScreen extends StatefulWidget {
  @override
  _ManufacturerScreenState createState() => _ManufacturerScreenState();
}

class _ManufacturerScreenState extends State<ManufacturerScreen> {
  final TextEditingController searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<ManufacturerCubit>().loadListOfManufacturers(context: context);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      final cubit = context.read<ManufacturerCubit>();
      if (cubit.state.hasNextPage && !cubit.state.isFetchingMore) {
        cubit.loadListOfManufacturers(
          context: context,
          page: cubit.state.currentPage + 1,
          isLoadMore: true,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    double titleFontSize = screenWidth * 0.05;
    double bodyFontSize = screenWidth * 0.035;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            // 💡 Adjust max width
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: screenHeight * 0.03),
                  child: SearchBarWidget(
                    enableBackArrow: true,
                    enableFilter: false,
                    enableCloseScreen: false,
                    controller: searchController,
                    onFilterTap: () {},
                    onChanged: (value) {
                      context.read<ManufacturerCubit>().loadListOfManufacturers(
                        context: context,
                        query: value.trim(),
                      );
                    },
                    searchTitle: 'Search Manufacturer...',
                  ),
                ),

                SizedBox(height: screenHeight * 0.02),

                Padding(
                  padding: EdgeInsets.only(left: screenWidth * 0.06),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: AppTexts(
                        text: "Manufacturer",
                        imageName: null,
                        font: 'Roboto',
                        side: 'left',
                        color: Color(0xFF3F3D56),
                        weight: FontWeight.w600,
                        fontSize: titleFontSize,
                        imageSize: 15,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: screenHeight * 0.02),

                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.04,
                    ),
                    child: BlocBuilder<ManufacturerCubit, ManufacturerState>(
                      builder: (context, state) {
                        if (state.isLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (state.manufacturers.isEmpty) {
                          return const Center(
                            child: Text("No manufacturers available."),
                          );
                        }

                        final sortedManufacturers = [...state.manufacturers]
                          ..sort(
                            (a, b) => a.companyName.toLowerCase().compareTo(
                              b.companyName.toLowerCase(),
                            ),
                          );

                        return ListView.builder(
                          controller: _scrollController,
                          itemCount:
                              sortedManufacturers.length +
                              (state.isFetchingMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index < sortedManufacturers.length) {
                              final item = sortedManufacturers[index];

                              return Card(
                                color: Colors.white,
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: ListTile(
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: screenWidth * 0.05,
                                    vertical: screenHeight * 0.012,
                                  ),
                                  leading: item.icon != null
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            5,
                                          ),
                                          child: _buildLeadingImage(
                                            screenWidth * 0.15,
                                            screenWidth * 0.15,
                                            item.icon!,
                                          ),
                                        )
                                      : const Icon(Icons.image_not_supported),
                                  title: Text(
                                    item.companyName,
                                    style: TextStyle(
                                      fontSize: bodyFontSize,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF3F3D56),
                                    ),
                                  ),
                                  trailing: const Icon(
                                    Icons.arrow_forward_ios,
                                    size: 16,
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            ManufacturerDetailScreen(
                                              manufacturerDetailId: item.id,
                                            ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            } else {
                              // Loader shown when fetching more
                              return const Padding(
                                padding: EdgeInsets.all(12.0),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }
                          },
                        );
                      },
                    ),
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

Widget _buildLeadingImage(double width, double height, String imagePath) {
  if (imagePath.endsWith(".svg")) {
    if (imagePath.startsWith("assets/")) {
      return SizedBox(
        width: width,
        height: height,
        child: SvgPicture.asset(
          imagePath,
          width: width,
          height: height,
          fit: BoxFit.contain,
        ),
      );
    } else {
      return SizedBox(
        width: width,
        height: height,
        child: SvgPicture.network(
          imagePath,
          width: width,
          height: height,
          fit: BoxFit.contain,
          placeholderBuilder: (_) => const SizedBox.shrink(),
        ),
      );
    }
  } else if (imagePath.startsWith("http")) {
    return Image.network(
      imagePath,
      width: width,
      height: height,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => const SizedBox.shrink(),
    );
  } else {
    return Image.asset(
      imagePath,
      width: width,
      height: height,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => const SizedBox.shrink(),
    );
  }
}
