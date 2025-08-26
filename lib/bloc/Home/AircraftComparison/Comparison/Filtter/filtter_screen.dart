import 'package:avionics_internal/Constants/constantImages.dart';
import 'package:avionics_internal/CustomFiles/CustomAppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'filtter_cubit.dart';
import 'filtter_model.dart';
import 'filtter_state.dart';

class FilterScreen1 extends StatefulWidget {
  final bool isAlreadyProcessing;
  final FilterState1? modelResponse;

  const FilterScreen1({
    super.key,
    required this.isAlreadyProcessing,
    this.modelResponse,
  });

  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen1> {
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
      appBar: CustomAppBar(
        title: "Filter",
        leftButton: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        rightButton: BlocBuilder<ComparisonFilterCubit1, FilterState1>(
          builder: (context, state) {
            final selectedCount = state.filterCategories.fold<int>(
              0,
              (previousValue, category) =>
                  previousValue +
                  category.options.where((option) => option.isSelected).length,
            );

            return Row(
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(state.filterCategories);
                  },
                  child: Row(
                    children: [
                      if (selectedCount != 0) ...[
                        CircleAvatar(
                          backgroundColor: Colors.blue,
                          minRadius: 13,
                          maxRadius: 13,
                          child: Center(
                            child: Text(
                              "$selectedCount",
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                      ],
                      const Text(
                        'Apply',
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
      body: BlocBuilder<ComparisonFilterCubit1, FilterState1>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const SizedBox(height: 15),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: state.filterCategories.length,
                  itemBuilder: (context, index) {
                    final category = state.filterCategories[index];
                    final List<FilterOption1> optionsToDisplay =
                        category.isExpanded ? category.options : [];

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Category Row (Title + All Checkbox + Arrow)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: Row(
                            children: [
                              /// Title
                              Expanded(
                                child: Text(
                                  category.name,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: Color.fromRGBO(63, 81, 86, 1.0),
                                  ),
                                ),
                              ),

                              /// All + checkbox
                              Row(
                                children: [
                                  Checkbox(
                                    value: category.options.every(
                                      (opt) => opt.isSelected,
                                    ),
                                    onChanged: (bool? newValue) {
                                      final updatedOptions = category.options
                                          .map(
                                            (opt) => opt.copyWith(
                                              isSelected: newValue ?? false,
                                            ),
                                          )
                                          .toList();

                                      context
                                          .read<ComparisonFilterCubit1>()
                                          .updateSelectedFilters(
                                            state.filterCategories.map((cat) {
                                              if (cat.id == category.id) {
                                                return cat.copyWith(
                                                  options: updatedOptions,
                                                );
                                              }
                                              return cat;
                                            }).toList(),
                                          );
                                    },
                                    activeColor: Colors.blue,
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                ],
                              ),

                              /// Arrow
                              GestureDetector(
                                onTap: () {
                                  context
                                      .read<ComparisonFilterCubit1>()
                                      .toggleCategoryExpansion(category.id);
                                },
                                child: SvgPicture.asset(
                                  CommonUi.setSvgImage(
                                    category.isExpanded
                                        ? AssetsPath.upArrow
                                        : AssetsPath.downArrow,
                                  ),
                                  fit: BoxFit.fill,
                                  width: 22,
                                  height: 22,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),

                        /// Options (only when expanded)
                        if (category.isExpanded)
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 0.0,
                              right: 22,
                            ),
                            child: Column(
                              children: optionsToDisplay.map((option) {
                                return Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        option.name,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          color: Color.fromRGBO(
                                            63,
                                            81,
                                            86,
                                            1.0,
                                          ),
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
                                      activeColor: Colors.blue,
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),

              /// Reset Button
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30.0,
                  vertical: 20.0,
                ),
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    context.read<ComparisonFilterCubit1>().resetFilters();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    side: const BorderSide(color: Colors.black),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Reset Filter",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
