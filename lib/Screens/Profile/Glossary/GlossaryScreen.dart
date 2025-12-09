import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Constants/ApiClass/FirebaseAnalytics/analytics_service.dart';
import '../../../Constants/ApiClass/FirebaseAnalytics/event_names.dart';
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: ConstantStrings.glossaryTitle,
        leftButton: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
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
          const SizedBox(height: 10),
          Expanded(
            child: BlocBuilder<GlossaryCubit, GlossaryState>(
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

                return ListView.builder(
                  itemCount: glossaryData.length,
                  itemBuilder: (context, index) {
                    final entry = glossaryData.entries.elementAt(index);
                    final String letter = entry.key;
                    final List<GlossaryItem> items = entry.value;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          color: const Color(0xFFD2E6FC),
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: Text(
                            letter,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        ...items.map((item) {
                          final key = '$letter-${item.title}';
                          final isExpanded = _expandedItems[key] ?? false;

                          return Column(
                            children: [
                              ExpansionTile(
                                tilePadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                childrenPadding: const EdgeInsets.only(
                                  left: 16,
                                  right: 16,
                                  bottom: 12,
                                ),
                                title: Text(
                                  item.title,
                                  style: const TextStyle(
                                    color: Color(0xFF3F3D56),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                initiallyExpanded: isExpanded,
                                onExpansionChanged: (expanded) {
                                  setState(() {
                                    _expandedItems[key] = expanded;
                                  });
                                },
                                children: [
                                  Text(
                                    item.description,
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      height: 1.4,
                                    ),
                                  ),
                                ],
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
