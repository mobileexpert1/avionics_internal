import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Helpers/AppText.dart';
import '../../../Helpers/CacheManger/CachedImageFile.dart';
import '../../../Helpers/SearchBarWidget.dart';
import '../../../bloc/Home/manufacturer/manufacturer_cubit.dart';
import '../../../bloc/Home/manufacturer/manufacturer_state.dart';
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ManufacturerCubit>().loadListOfManufacturers(
          context: context);
    });
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
    final screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    final screenHeight = MediaQuery
        .of(context)
        .size
        .height;

    double titleFontSize = kIsWeb ? screenWidth * 0.015 : screenWidth * 0.05;
    double bodyFontSize = kIsWeb ? screenWidth * 0.013 : screenWidth * 0.035;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kIsWeb ? 130 : 110),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [SearchBarWidget(
              enableBackArrow: true,
              enableFilter: false,
              enableCloseScreen: false,
              controller: searchController,
              onFilterTap: () {},
              onBackButtonTap: () {
                Navigator.pop(context);
              },
              onChanged: (value) {
                context.read<ManufacturerCubit>().loadListOfManufacturers(
                  context: context,
                  query: value.trim(),
                );
              },
              searchTitle: 'Search Manufacturer...',
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: kIsWeb
                      ? screenWidth * 0.02
                      : screenWidth * 0.03,
                ),

                // Title
                Padding(
                  padding: EdgeInsets.symmetric(horizontal:kIsWeb ? screenWidth * 0.02 : screenWidth * 0.06),
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: AppTexts(
                      text: "Manufacturer",
                      imageName: null,
                      font: 'Roboto',
                      side: 'left',
                      color: const Color(0xFF3F3D56),
                      weight: FontWeight.w600,
                      fontSize: titleFontSize,
                      imageSize: 15,
                    ),
                  ),
                ),

                SizedBox(
                  height: kIsWeb
                      ? screenWidth * 0.02
                      : screenWidth * 0.03,
                ),

                // Manufacturer List
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: kIsWeb ? screenWidth * 0.02 : screenWidth *
                          0.04,
                    ),
                    child: BlocBuilder<ManufacturerCubit, ManufacturerState>(
                      builder: (context, state) {
                        if (state.isLoading) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        if (state.manufacturers.isEmpty) {
                          return const Center(
                              child: Text("No manufacturers available."));
                        }

                        final sortedManufacturers = [...state.manufacturers]
                          ..sort((a, b) =>
                              a.companyName.toLowerCase().compareTo(
                                b.companyName.toLowerCase(),
                              ));

                        return ListView.builder(
                          controller: _scrollController,
                          itemCount: sortedManufacturers.length +
                              (state.isFetchingMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index < sortedManufacturers.length) {
                              final item = sortedManufacturers[index];
                              return Card(
                                color: Colors.white,
                                margin: EdgeInsets.symmetric(
                                    vertical: kIsWeb ? 6 : 8),
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: ListTile(
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: kIsWeb
                                        ? screenWidth * 0.02
                                        : screenWidth * 0.05,
                                    vertical: screenHeight * 0.012,
                                  ),
                                  leading: item.icon != null
                                      ? ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: CachedAnyImage(
                                      imagePath: item.icon ?? "",
                                      width: kIsWeb
                                          ? screenWidth * 0.06
                                          : screenWidth * 0.15,
                                      height: kIsWeb
                                          ? screenWidth * 0.06
                                          : screenWidth * 0.15,
                                      contentImage: BoxFit.contain,
                                    ),
                                  )
                                      : const Icon(Icons.image_not_supported),
                                  title: Text(
                                    item.companyName,
                                    style: TextStyle(
                                      fontSize: bodyFontSize,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFF3F3D56),
                                    ),
                                  ),
                                  trailing: const Icon(
                                      Icons.arrow_forward_ios, size: 16),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            BlocProvider(
                                              create: (_) =>
                                                  ManufacturerCubit(),
                                              child: ManufacturerDetailScreen(
                                                key: ValueKey(item.id),
                                                manufacturerDetailId: item.id,
                                              ),
                                            ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            } else {
                              return const Padding(
                                padding: EdgeInsets.all(12.0),
                                child: Center(
                                    child: CircularProgressIndicator()),
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
