import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../Constants/ApiClass/ApiErrorModel.dart';
import '../../../../Constants/ApiClass/FirebaseAnalytics/analytics_service.dart';
import '../../../../Constants/ApiClass/FirebaseAnalytics/event_names.dart';
import '../../../../Constants/AppColors.dart';
import '../../../../Constants/constantImages.dart';
import '../../../../CustomFiles/CustomAppBar.dart';
import '../../../../Helpers/AppTextStyles/AppTextStyles.dart';
import '../../../../Helpers/CustomHeaderViewExpandable.dart';
import '../../../../bloc/Profile/ConversionSection/conversion_cubit.dart';
import '../../../../bloc/Profile/ConversionSection/conversion_model.dart';
import '../../../../bloc/Profile/ConversionSection/conversion_state.dart';

class UnitConversionsScreen extends StatefulWidget {
  const UnitConversionsScreen({super.key});

  @override
  State<UnitConversionsScreen> createState() => _UnitConversionsScreenState();
}

class _UnitConversionsScreenState extends State<UnitConversionsScreen> {
  late ConversionCubit _cubit;
  Map<int, bool> expandedMap = {};

  @override
  void initState() {
    super.initState();
    _cubit = ConversionCubit();
    _cubit.loadConversions();
    AnalyticsService.instance.logVisibleScreen(FirebaseEvents.conversionScreen);
  }

  @override
  void dispose() {
    _cubit.close();
    expandedMap = {};
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          title: 'Unit Conversion',
          centerTitle: false,
          leftButton: IconButton(
            icon: SvgPicture.asset(
              CommonUi.setSvgImage(AssetsPath.backArrowButton),
              fit: BoxFit.cover,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),

        body: BlocConsumer<ConversionCubit, ConversionState>(
          listenWhen: (previous, current) => previous.status != current.status,
          listener: (context, state) {
            if (state.status == CommonApiStatus.failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage ?? "Something went wrong"),
                ),
              );
            }
          },
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.categories.isEmpty) {
              return const Center(child: Text("No conversions found"));
            }

            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: kIsWeb ? 1300 : double.infinity,
                ),
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.categories.length,
                  itemBuilder: (context, index) {
                    final category = state.categories[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: CustomHeaderViewExpandable(
                        isNeedToShowLeftRightBottomBorder: false,
                        isNeedToShowLeftImage: false,
                        isExpanded: expandedMap[index] ?? false,
                        fontStyle: AppTextStyles.regular(
                          16,
                        ).copyWith(height: 1.4, color: AppColors.white),
                        title: category.title,
                        headerColor: expandedMap[index] ?? false
                            ? AppColors.primaryDark
                            : AppColors.grayMedium,
                        arrowBackgroundColor: expandedMap[index] ?? false
                            ? AppColors.extraDarkYellow
                            : AppColors.lightGreyWithAlphaDecreased,
                        arrowFrontColor: expandedMap[index] ?? false
                            ? AppColors.black
                            : AppColors.white,
                        isExpandedViewAvailable: true,
                        onHeaderTap: () {
                          setState(() {
                            expandedMap[index] = !(expandedMap[index] ?? false);
                          });
                        },
                        child: _buildConversionBody(category),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildConversionBody(ConversionCategory category) {
    return Column(
      children: [
        Container(
          color: AppColors.greyForConversionScreen,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  textAlign: TextAlign.center,
                  "From ⇄ To",
                  style: AppTextStyles.regular(
                    16,
                  ).copyWith(height: 1.4, color: AppColors.black),
                ),
              ),
              Expanded(
                child: Text(
                  textAlign: TextAlign.center,
                  "Conversion",
                  style: AppTextStyles.regular(
                    16,
                  ).copyWith(height: 1.4, color: AppColors.black),
                ),
              ),
            ],
          ),
        ),

        ...List.generate(category.items.length, (index) {
          final item = category.items[index];
          return Column(
            children: [
              Container(
                color: AppColors.grayLight,
                child: IntrinsicHeight(
                  child: Row(
                    children: [
                      Expanded(
                        child: Center(
                          child: TextButton(
                            onPressed: () {},
                            child: Text(
                              item.fromTo,
                              style: AppTextStyles.regular(
                                16,
                              ).copyWith(height: 1.4, color: AppColors.black),
                            ),
                          ),
                        ),
                      ),

                      const VerticalDivider(
                        width: 1,
                        thickness: 1,
                        color: Colors.white,
                      ),

                      Expanded(
                        child: Center(
                          child: TextButton(
                            onPressed: () {},
                            child: Text(
                              textAlign: TextAlign.center,
                              item.formula,
                              style: AppTextStyles.regular(
                                16,
                              ).copyWith(height: 1.4, color: AppColors.black),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                color: AppColors.greyForConversionScreen,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Example: ${item.example}",
                        textAlign: TextAlign.center,
                        style: AppTextStyles.regular(
                          16,
                        ).copyWith(height: 1.4, color: AppColors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ],
    );
  }
}