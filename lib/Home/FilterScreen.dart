import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/Filter/filter_cubit.dart';
import '../bloc/Filter/filter_model.dart';
import '../bloc/Filter/filter_state.dart';

class FilterScreen extends StatefulWidget {
  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  @override
  void initState() {
    super.initState();
    // Load filter data when the screen initializes.
    context.read<FilterCubit>().loadFilters();
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
          BlocBuilder<FilterCubit, FilterState>(
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
                  // This button visually indicates applied filters.
                  // The actual "apply" logic would typically happen when the screen is popped
                  // or a dedicated "Apply" button is pressed (which we don't have here,
                  // but could be added in the bottom section instead of "Reset Filter").
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
                      Text(
                        selectedCount > 0 ? ' Applied ' : ' Applied ',
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<FilterCubit, FilterState>(
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
                    final List<FilterOption> optionsToDisplay =
                        category.isExpanded
                        ? category.options
                        : category.options
                              .take(visibleOptionCountWhenCollapsed)
                              .toList();

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                category.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                ),
                              ),
                              // "Show Less/More" button
                              TextButton(
                                onPressed: () {
                                  context
                                      .read<FilterCubit>()
                                      .toggleCategoryExpansion(category.id);
                                },
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.blue,
                                      minRadius: 13,
                                      maxRadius: 13,
                                      child: Center(
                                        child: Text(
                                          "88",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      ' Applied ',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ],
                                ),

                                // Text(
                                //   category.isExpanded
                                //       ? 'Show Less'
                                //       : 'Show More',
                                //   style: const TextStyle(color: Colors.blue),
                                // ),
                              ),
                            ],
                          ),
                        ),
                        // Conditionally display options based on expansion state
                        if (category.isExpanded)
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
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                  Checkbox(
                                    value: option.isSelected,
                                    onChanged: (bool? value) {
                                      context
                                          .read<FilterCubit>()
                                          .toggleFilterOption(
                                            category.id,
                                            option.id,
                                          );
                                    },
                                    activeColor: Colors.blue,
                                  ),
                                ],
                              ),
                            );
                          }).toList()
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
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                  Checkbox(
                                    value: option.isSelected,
                                    onChanged: (bool? value) {
                                      context
                                          .read<FilterCubit>()
                                          .toggleFilterOption(
                                            category.id,
                                            option.id,
                                          );
                                    },
                                    activeColor: Colors.blue,
                                  ),
                                ],
                              ),
                            );
                          }).toList(),

                        // If category is not expanded and there are more options than visibleOptionCountWhenCollapsed,
                        // show a "..." or similar indicator if desired. For now, the "Show More" button handles this.
                        if (index < state.filterCategories.length - 1)
                          Divider(height: 1, color: Colors.grey[300]),
                      ],
                    );
                  },
                ),
              ),
              // Reset Filter button at the bottom
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    context.read<FilterCubit>().resetFilters();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blue,
                    side: const BorderSide(color: Colors.blue),
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
