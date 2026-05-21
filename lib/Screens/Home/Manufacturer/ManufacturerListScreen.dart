import 'package:avionics_internal/Constants/AppColors.dart';
import 'package:avionics_internal/CustomFiles/CustomAppBar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../Constants/ApiClass/FirebaseAnalytics/analytics_service.dart';
import '../../../Constants/ApiClass/FirebaseAnalytics/event_names.dart';
import '../../../Constants/constantImages.dart';
import '../../../Helpers/AppNavigator.dart';
import '../../../Helpers/AppTextStyles/AppTextStyles.dart';
import '../../../Helpers/CacheManger/CachedImageFile.dart';
import '../../../Helpers/SearchBarWidget.dart';
import '../../../bloc/Home/manufacturer/manufacturer_cubit.dart';
import '../../../bloc/Home/manufacturer/manufacturer_state.dart';
import '../../Profile/SettingScreen/SettingScreen.dart';
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
        context: context,
      );
    });

    AnalyticsService.instance.logVisibleScreen(
      FirebaseEvents.manufacturerScreen,
    );
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

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Manufacturers Library',
        centerTitle: false,
        leftButton: IconButton(
          icon: SvgPicture.asset(
            CommonUi.setSvgImage(AssetsPath.backArrowButton),
            fit: BoxFit.cover,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        rightButton: IconButton(
          icon: SvgPicture.asset(
            CommonUi.setSvgImage(AssetsPath.homeRightSetting),
            width: 35,
            height: 31,
          ),
          onPressed: () {
            AppNavigator.push(context, SettingScreen(), disableSwipeBack: true);
          },
        ),
      ),

      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1500),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: SearchBarWidget(
                    enableBackArrow: false,
                    enableFilter: false,
                    enableCloseScreen: false,
                    controller: searchController,
                    onChanged: (value) {
                      context.read<ManufacturerCubit>().loadListOfManufacturers(
                        context: context,
                        query: value.trim(),
                      );
                    },
                    searchTitle: "Search Manufacturer",
                  ),
                ),

                BlocBuilder<ManufacturerCubit, ManufacturerState>(
                  builder: (context, state) {
                    final cubit = context.read<ManufacturerCubit>();

                    return Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: kIsWeb
                            ? screenWidth * 0.02
                            : screenWidth * 0.05,
                      ),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: (state.categories ?? []).map((label) {
                          final isSelected = state.selectedCategories.contains(
                            label,
                          );

                          return Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(14),
                              onTap: () {
                                debugPrint("Tapped: $label");

                                cubit.toggleCategory(label, context);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 7,
                                  vertical: 7,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.extraDarkYellow
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: AppColors.black,
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  label,
                                  style: AppTextStyles.regular(15.67).copyWith(
                                    height: 1.0,
                                    color: AppColors.primaryDark,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 20),

                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: kIsWeb
                          ? screenWidth * 0.02
                          : screenWidth * 0.03,
                    ),
                    child: BlocBuilder<ManufacturerCubit, ManufacturerState>(
                      builder: (context, state) {
                        if (state.isLoading && state.manufacturers.isEmpty) {
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

                              return GestureDetector(
                                onTap: () {
                                  AnalyticsService.instance.buttonPressed(
                                    FirebaseEvents.allAirbusModelsButton,
                                    FirebaseEvents.manufacturerScreen,
                                  );

                                  AppNavigator.push(
                                    context,
                                    ManufacturerDetailScreen(
                                      key: ValueKey(item.id),
                                      manufacturerDetailId: item.id,
                                    ),
                                    multiBlocProviders: [
                                      BlocProvider(
                                        create: (_) => ManufacturerCubit(),
                                      ),
                                    ],
                                    disableSwipeBack: true,
                                  );
                                },
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 11,
                                        horizontal: 10,
                                      ),
                                      child: Row(
                                        children: [
                                          item.icon != null
                                              ? CachedAnyImage(
                                                  imagePath: item.icon ?? "",
                                                  width: 40,
                                                  height: 40,
                                                  contentImage: BoxFit.contain,
                                                )
                                              : SvgPicture.asset(
                                                  CommonUi.setSvgImage(
                                                    AssetsPath.manuFirstImage,
                                                  ),
                                                  width: 40,
                                                  height: 40,
                                                ),
                                          const SizedBox(width: 50),
                                          Expanded(
                                            child: Text(
                                              item.companyName,
                                              style:
                                                  AppTextStyles.regular(
                                                    14.09,
                                                  ).copyWith(
                                                    height: 1.0,
                                                    color: AppColors.black,
                                                  ),

                                              // const TextStyle(
                                              //   fontSize: 14,
                                              //   fontWeight: FontWeight.w500,
                                              //   color: Color(0xFF3F3D56),
                                              // ),
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
                            } else {
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
