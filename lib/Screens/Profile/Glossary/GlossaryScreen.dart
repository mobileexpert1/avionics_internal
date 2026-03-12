import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Constants/ApiClass/ApiErrorModel.dart';
import '../../../Constants/ApiClass/FirebaseAnalytics/analytics_service.dart';
import '../../../Constants/ApiClass/FirebaseAnalytics/event_names.dart';
import '../../../Constants/AppColors.dart';
import '../../../Helpers/CustomHeaderViewExpandable.dart';
import '../../../Helpers/SearchBarWidget.dart';
import '../../../bloc/Profile/Glossary/glossary_cubit.dart';
import '../../../bloc/Profile/Glossary/glossary_model.dart';
import '../../../bloc/Profile/Glossary/glossary_state.dart';
import 'package:avionics_internal/Constants/ConstantStrings.dart';
import 'package:avionics_internal/CustomFiles/CustomAppBar.dart';

class GlossaryScreen extends StatefulWidget {
  const GlossaryScreen({super.key});

  @override
  State<GlossaryScreen> createState() => _GlossaryScreenState();
}

class _GlossaryScreenState extends State<GlossaryScreen> {
  final Map<String, bool> _expandedItems = {};
  late TextEditingController _searchController;

  bool isSelectedExpanded = false;

  List<String> get alphabets =>
      List.generate(26, (index) => String.fromCharCode(65 + index));

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController.addListener(_onSearchChanged);
    AnalyticsService.instance.logVisibleScreen(FirebaseEvents.glossaryScreen);
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim();
    context.read<GlossaryCubit>().loadGlossary(query: query, context: context);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double maxWidth = MediaQuery.of(context).size.width > 1500
        ? 1500
        : MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: ConstantStrings.glossaryTitle,
        leftButton: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Column(
            children: [
              const SizedBox(height: 5),

              SearchBarWidget(
                searchTitle: 'Search Glossary...',
                enableBackArrow: false,
                enableFilter: false,
                enableCloseScreen: false,
                controller: _searchController,
                onChanged: (value) {
                  context.read<GlossaryCubit>().loadGlossary(
                    query: value.trim(),
                    context: context,
                  );
                },
              ),
              //const SizedBox(height: 10),
              Expanded(
                child: BlocConsumer<GlossaryCubit, GlossaryState>(
                  listenWhen: (previous, current) =>
                      previous.status != current.status,
                  listener: (context, state) {
                    if (state.status == CommonApiStatus.failure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            state.errorMessage ?? "Something went wrong",
                          ),
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    final glossaryData = state.glossaryData;

                    if (state.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (glossaryData.isEmpty) {
                      return const Center(
                        child: Text(
                          'No glossary terms found.',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      );
                    }

                    return ListView(
                      padding: const EdgeInsets.all(14),
                      children: [
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final screenWidth = constraints.maxWidth;
                            const horizontalSpacing = 5.0;
                            final itemsPerRow =
                                (screenWidth / (kIsWeb ? 56 : 27)).floor();
                            final itemWidth =
                                (screenWidth -
                                    (horizontalSpacing * (itemsPerRow - 1))) /
                                itemsPerRow;
                            return Wrap(
                              spacing: horizontalSpacing,
                              runSpacing: 8,
                              children: alphabets.map((letter) {
                                final isSelected =
                                    state.selectedLetter == letter;
                                return SizedBox(
                                  width: itemWidth,
                                  child: _alphabetItem(letter, isSelected),
                                );
                              }).toList(),
                            );
                          },
                        ),

                        const SizedBox(height: 10),

                        CustomHeaderViewExpandable(
                          isNeedToShowLeftRightBottomBorder: true,
                          isNeedToShowLeftImage: false,
                          title: "See All",
                          headerColor: AppColors.primaryDark,
                          arrowBackgroundColor: AppColors.extraDarkYellow,
                          arrowFrontColor: Colors.black,
                          isExpandedViewAvailable: true,
                          isExpanded: isSelectedExpanded,
                          onHeaderTap: () {
                            setState(() {
                              isSelectedExpanded = !isSelectedExpanded;
                            });
                          },

                          child: Column(
                            children: [
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: glossaryData.length,
                                itemBuilder: (context, index) {
                                  final entry = glossaryData.entries.elementAt(
                                    index,
                                  );
                                  final String letter = entry.key;
                                  final List<GlossaryItem> items = entry.value;

                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ...items.map((item) {
                                        final key = '$letter-${item.title}';
                                        final isExpanded =
                                            _expandedItems[key] ?? false;

                                        return Column(
                                          children: [
                                            Theme(
                                              data: Theme.of(context).copyWith(
                                                dividerColor:
                                                    Colors.transparent,
                                              ),
                                              child: ExpansionTile(
                                                showTrailingIcon: isExpanded ? true : false,
                                                shape: const Border(),
                                                collapsedShape: const Border(),
                                                backgroundColor:
                                                    Colors.transparent,
                                                collapsedBackgroundColor:
                                                    Colors.transparent,
                                                tilePadding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 16,
                                                    ),
                                                childrenPadding:
                                                    const EdgeInsets.only(
                                                      left: 16,
                                                      right: 16,
                                                      bottom: 12,
                                                    ),
                                                title: Text(
                                                  item.title,
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                initiallyExpanded: isExpanded,
                                                onExpansionChanged: (expanded) {
                                                  setState(() {
                                                    _expandedItems[key] =
                                                        expanded;
                                                  });
                                                },
                                                children: [
                                                  Text(
                                                    item.description,
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      height: 1.4,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const Divider(
                                              height: 0,
                                              thickness: 1,
                                              color: Color(0xFFE0E0E0),
                                              indent: 16,
                                              endIndent: 16,
                                            ),
                                          ],
                                        );
                                      }),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _alphabetItem(String letter, bool isSelected) {
    return InkWell(
      onTap: () {
        setState(() {
          if (context.read<GlossaryCubit>().state.selectedLetter == letter) {
            context.read<GlossaryCubit>().state.selectedLetter = null;
            isSelectedExpanded = false;
          } else {
            context.read<GlossaryCubit>().state.selectedLetter = letter;
            isSelectedExpanded = true;
          }
        });

        context.read<GlossaryCubit>().filterByLetter(
          letter: context.read<GlossaryCubit>().state.selectedLetter ?? "",
          context: context,
        );
      },
      borderRadius: BorderRadius.circular(3),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 25,
        height: 25,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryDark : AppColors.extraLightGrey,
          borderRadius: BorderRadius.circular(3),
        ),
        child: Text(
          letter,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}
