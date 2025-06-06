import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/Profile/Glossary/glossary_cubit.dart';
import '../../bloc/Profile/Glossary/glossary_model.dart';
import '../../bloc/Profile/Glossary/glossary_state.dart';



class GlossaryScreen extends StatefulWidget {
  const GlossaryScreen({super.key});

  @override
  State<GlossaryScreen> createState() => _GlossaryScreenState();
}

class _GlossaryScreenState extends State<GlossaryScreen> {
  final Map<String, bool> _expandedItems = {};

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GlossaryCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Glossary'),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: BlocBuilder<GlossaryCubit, GlossaryState>(
          builder: (context, state) {
            final glossaryData = state.glossaryData;

            if (glossaryData.isEmpty) {
              return const Center(child: CircularProgressIndicator());
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
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Text(
                        letter,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                    ...items.map((item) {
                      final key = '$letter-${item.title}';
                      final isExpanded = _expandedItems[key] ?? false;

                      return Column(
                        children: [
                          ExpansionTile(
                            tilePadding: const EdgeInsets.symmetric(horizontal: 16),
                            childrenPadding: const EdgeInsets.only(
                                left: 16, right: 16, bottom: 12),
                            backgroundColor: Colors.transparent,
                            collapsedBackgroundColor: Colors.transparent,
                            title: Text(
                              item.title,
                              style: const TextStyle(
                                color: Colors.black87,
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
                              if (item.description.isNotEmpty)
                                Text(
                                  item.description,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    height: 1.4,
                                  ),
                                ),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Divider(
                              height: 0,
                              thickness: 1,
                              color: Color(0xFFE0E0E0),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
