import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:avionics_internal/Constants/AppColors.dart';
import 'package:avionics_internal/Constants/constantImages.dart';
import '../../../../../Helpers/AppTextStyles/AppTextStyles.dart';
import '../../../../../bloc/Home/AircraftComparison/Comparison/Filtter/filtter_cubit.dart';
import '../../../../../bloc/Home/AircraftComparison/Comparison/Filtter/filtter_state.dart';

class FilterScreenForComparison extends StatefulWidget {
  final bool isAlreadyProcessing;
  final FilterState1? modelResponse;

  const FilterScreenForComparison({
    super.key,
    required this.isAlreadyProcessing,
    this.modelResponse,
  });

  @override
  _FilterScreenForComparisonState createState() =>
      _FilterScreenForComparisonState();
}

class _FilterScreenForComparisonState extends State<FilterScreenForComparison> {
  @override
  void initState() {
    super.initState();
    context.read<ComparisonFilterCubit1>().loadFiltersFromComparison1(
      widget.isAlreadyProcessing,
      widget.modelResponse,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: BlocBuilder<ComparisonFilterCubit1, FilterState1>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 16, 6),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Filter",
                        style: AppTextStyles.bold(
                          24,
                        ).copyWith(height: 1.0, color: AppColors.black),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: const Icon(
                        Icons.close,
                        size: 27,
                        color: AppColors.primaryValueColour,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    itemCount: state.filterCategories.length,
                    itemBuilder: (context, index) {
                      final category = state.filterCategories[index];
                      final optionsToDisplay = category.isExpanded
                          ? category.options
                          : [];

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  CommonUi.setSvgImage(
                                    category.id == "technical_data"
                                        ? AssetsPath.technicalCompare
                                        : AssetsPath.generalCompare,
                                  ),
                                  width: 28,
                                  height: 28,
                                ),

                                const SizedBox(width: 10),

                                Expanded(
                                  child: Text(
                                    category.name,
                                    style: AppTextStyles.regular(16).copyWith(
                                      height: 1.0,
                                      color: AppColors.primaryValueColour,
                                    ),
                                  ),
                                ),

                                GestureDetector(
                                  onTap: () {
                                    context
                                        .read<ComparisonFilterCubit1>()
                                        .toggleCategoryExpansion(category.id);
                                  },
                                  child: Text(
                                    category.isExpanded
                                        ? "Show less"
                                        : "Show more",
                                    style: AppTextStyles.regular(16).copyWith(
                                      height: 1.0,
                                      color: AppColors.primaryBlue,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          if (category.isExpanded)
                            Column(
                              children: optionsToDisplay.map((option) {
                                return Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            option.name,
                                            style: AppTextStyles.regular(14)
                                                .copyWith(
                                                  height: 1.0,
                                                  color: AppColors.black,
                                                ),
                                          ),
                                        ),
                                        Checkbox(
                                          value: option.isSelected,
                                          onChanged: (bool? newValue) {
                                            context
                                                .read<ComparisonFilterCubit1>()
                                                .toggleOption(
                                                  categoryId: category.id,
                                                  optionId: option.id,
                                                  isSelected: newValue ?? false,
                                                );
                                          },
                                          activeColor: AppColors.primaryBlue,
                                        ),
                                      ],
                                    ),
                                    const Divider(
                                      thickness: 1,
                                      height: 1,
                                      color: AppColors
                                          .dividerLineColourForComparison,
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                          const SizedBox(height: 8),
                        ],
                      );
                    },
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop(state.filterCategories);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          side: const BorderSide(color: Colors.black),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          "Apply Filter",
                          textAlign: TextAlign.center,
                          style: AppTextStyles.semiBold(
                            16,
                          ).copyWith(height: 1.4, color: AppColors.black),
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<ComparisonFilterCubit1>().resetFilters();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          side: const BorderSide(color: Colors.black),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          "Reset Filter",
                          textAlign: TextAlign.center,
                          style: AppTextStyles.semiBold(
                            16,
                          ).copyWith(height: 1.4, color: AppColors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],
          );
        },
      ),
    );
  }
}
