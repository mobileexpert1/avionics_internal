import 'package:avionics_internal/Constants/constantImages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'filtter_cubit.dart';
import 'filtter_model.dart';
import 'filtter_state.dart';

class FilterScreen1 extends StatefulWidget {
  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen1> {
  @override
  void initState() {
    super.initState();
    context.read<ComparisonFilterCubit1>().loadFiltersFromComparison1();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text("Filter", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        actions: [
          BlocBuilder<ComparisonFilterCubit1, FilterState1>(
            builder: (context, state) {
              // Calculate the number of applied filters
              final selectedCount = state.filterCategories.fold<int>(
                0,
                    (previousValue, category) =>
                previousValue +
                    category.options
                        .where((option) => option.isSelected)
                        .length,
              );
              return TextButton(
                onPressed: () {
                  final cubit = context.read<ComparisonFilterCubit1>();
                  final filters = cubit.state.filterCategories;
                  cubit.updateSelectedFilters(filters, isApplied: true);
                  Navigator.of(context).pop(filters);
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
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      Text(' Applied ', style: TextStyle(color: Colors.black)),
                    ],
                  ],
                ),
              );

            },
          ),
        ],
      ),
      body: BlocBuilder<ComparisonFilterCubit1, FilterState1>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: state.filterCategories.length,
                  itemBuilder: (context, index) {
                    final category = state.filterCategories[index];
                    // Define how many options to show when collapsed
                    const int visibleOptionCountWhenCollapsed = 0;

                    // Get the list of options to display based on expansion state
                    final List<FilterOption1> optionsToDisplay =
                    category.isExpanded
                        ? category.options
                        : category.options
                        .take(visibleOptionCountWhenCollapsed)
                        .toList();

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 0.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                category.name,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Color.fromRGBO(63, 81, 86, 1.0),
                                ),
                              ),
                              // "Show Less/More" button
                              TextButton(
                                onPressed: () {
                                  context
                                      .read<ComparisonFilterCubit1>()
                                      .toggleCategoryExpansion(category.id);
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      category.isExpanded
                                          ? 'Show Less'
                                          : 'Show More',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    const SizedBox(width: 5),
                                    SvgPicture.asset(
                                      CommonUi.setSvgImage(
                                        category.isExpanded
                                            ? AssetsPath.upArrow
                                            : AssetsPath.downArrow,
                                      ),
                                      fit: BoxFit.fill,
                                      width: 16,
                                      height: 16,
                                      color: Colors.black,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        if (category.isExpanded)
                          ...optionsToDisplay.map((option) {
                            return CheckboxListTile(
                              dense: true,
                              controlAffinity: ListTileControlAffinity.trailing,
                              value: option.isSelected,
                              title: Text(
                                option.name,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Color.fromRGBO(63, 81, 86, 1.0),
                                ),
                              ),
                              onChanged: (bool? newValue) {
                                context.read<ComparisonFilterCubit1>().toggleOption(
                                  categoryId: category.id,
                                  optionId: option.id,
                                  isSelected: newValue ?? false,
                                );
                              },
                              activeColor: Colors.blue,
                            );
                          })
                        else if (optionsToDisplay
                            .isNotEmpty) // Show limited options when collapsed
                          ...optionsToDisplay.map((option) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 4.0,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      option.name,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  Checkbox(
                                    value: option.isSelected,
                                    onChanged: (bool? value) {
                                      context.read<ComparisonFilterCubit1>().toggleFilterOption(
                                        category.id,
                                        option.id,
                                      );
                                    },
                                    activeColor: Colors.blue,
                                  ),
                                ],
                              ),
                            );
                          }),
                      ],
                    );
                  },
                ),
              ),
              // Reset Filter button at the bottom
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

