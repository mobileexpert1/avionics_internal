import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../Constants/constantImages.dart';
import '../../../CustomFiles/CustomAppBar.dart';
import '../../../bloc/MapSection/FilterMap/filter_Map_Cubit.dart';
import '../../../bloc/MapSection/FilterMap/filter_Map_State.dart';

class FilterForMapScreen extends StatefulWidget {
  @override
  _filterMapScreenState createState() => _filterMapScreenState();
}

class _filterMapScreenState extends State<FilterForMapScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FilterMapCubit(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          isHideTopGradient: true,
          leftButton: BlocBuilder<FilterMapCubit, FilterMapState>(
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.only(left: 10, top: 10),
                child: Text(
                  "Filter",
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            },
          ),
          title: "",
          rightButton: BlocBuilder<FilterMapCubit, FilterMapState>(
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.only(right: 16, top: 10),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    state.selectedCategories.isEmpty
                        ? "No Filter"
                        : "${state.selectedCategories.length} Selected",
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        body: const Padding(
          padding: EdgeInsets.all(25.0),
          child: _FilterContent(),
        ),
      ),
    );
  }
}

class _FilterContent extends StatelessWidget {
  const _FilterContent();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FilterMapCubit, FilterMapState>(
      builder: (context, state) {
        final cubit = context.read<FilterMapCubit>();

        return ListView(
          children: [
            ExpandableSection(
              title: "CATEGORIES",
              expanded: state.showCategories,
              onToggle: cubit.toggleCategoriesSection,
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: state.categories.map((cat) {
                  final isSelected = state.selectedCategories.contains(cat);
                  return CategoryChip(
                    label: cat,
                    isSelected: isSelected,
                    onTap: () => cubit.toggleCategory(cat),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 30),

            /// Map Section
            ExpandableSection(
              title: "MAP",
              expanded: state.showMap,
              onToggle: cubit.toggleMapSection,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(
                        CommonUi.setSvgImage(AssetsPath.mapLayers),
                        height: 20,
                        width: 20,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        "Map Type",
                        style: TextStyle(fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SegmentedControl(
                    options: const ['Standard', 'Satellite', 'Hybrid'],
                    selectedValue: cubit.getMapTypeName(),
                    onChanged: cubit.changeMapTypeByName,
                  ),
                ],
              ),
            ),

            /// Aircraft Labels
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      CommonUi.setSvgImage(AssetsPath.blueAeroPlane),
                      height: 25,
                      width: 25,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      "Aircraft Labels",
                      style: TextStyle(fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                Transform.scale(
                  scale: 0.8,
                  child: Switch(
                    value: state.showAircraftLabels,
                    onChanged: (_) => cubit.toggleAircraftLabels(),
                    activeColor: Colors.white,
                    activeTrackColor: Colors.black,
                    inactiveThumbColor: Colors.black,
                    inactiveTrackColor: Colors.white,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 50),

            /// Reset Button
            ElevatedButton(
              onPressed: cubit.resetFilter,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                side: const BorderSide(color: Colors.black),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              child: const Text("Reset Filter", style: TextStyle(fontSize: 16)),
            ),
          ],
        );
      },
    );
  }
}

/// 🔹 Expandable Section with Show More/Less toggle
class ExpandableSection extends StatelessWidget {
  final String title;
  final bool expanded;
  final VoidCallback onToggle;
  final Widget child;

  const ExpandableSection({
    Key? key,
    required this.title,
    required this.expanded,
    required this.onToggle,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w400)),
            InkWell(
              onTap: onToggle,
              child: Row(
                children: [
                  Text(expanded ? "Show Less" : "Show More"),
                  const SizedBox(width: 4),
                  Icon(
                    expanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size: 20,
                  ),
                ],
              ),
            ),
          ],
        ),
        if (expanded) ...[const SizedBox(height: 20), child],
      ],
    );
  }
}

/// 🔹 Reusable Category Chip
class CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryChip({
    Key? key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(5),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: isSelected ? Colors.black : Colors.grey),
          borderRadius: BorderRadius.circular(6),
          color: isSelected ? Colors.blue.withOpacity(0.3) : Colors.white,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected
                  ? Icons.check_box_outlined
                  : Icons.check_box_outline_blank_sharp,
              color: isSelected ? Colors.black : Colors.grey,
              size: 15,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 🔹 Segmented Control
class SegmentedControl extends StatelessWidget {
  final List<String> options;
  final String selectedValue;
  final Function(String) onChanged;

  const SegmentedControl({
    Key? key,
    required this.options,
    required this.selectedValue,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: options.map((option) {
          final isSelected = option == selectedValue;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(option),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 7),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Text(
                  option,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

