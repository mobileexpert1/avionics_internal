import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../CustomFiles/CustomAppBar.dart';
import '../../../bloc/Profile/ConversionSection/conversion_cubit.dart';
import '../../../bloc/Profile/ConversionSection/conversion_state.dart';

class ConversionsScreen extends StatelessWidget {
  const ConversionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ConversionCubit()..loadConversions(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F7),
        appBar: CustomAppBar(
          title: 'Conversions Table',
          leftButton: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: BlocBuilder<ConversionCubit, ConversionState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.categories.length,
              itemBuilder: (context, index) {
                final category = state.categories[index];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Title
                    Center(
                      child: Text(
                        category.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF32377D),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Scrollbar(
                      thumbVisibility: true,
                      trackVisibility: true,
                      interactive: true,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(minWidth: 600),
                          child: Column(
                            children: [
                              // Header Row
                              Container(
                                decoration: const BoxDecoration(
                                  color: Color(0xFF1E80F2),
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(8),
                                  ),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 12),
                                child: const Row(
                                  children: [
                                    SizedBox(
                                      width: 200,
                                      child: Text(
                                        "From → To",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 200,
                                      child: Text(
                                        "Conversion",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 200,
                                      child: Text(
                                        "Example",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Data Rows
                              Column(
                                children: List.generate(category.items.length, (i) {
                                  final item = category.items[i];
                                  final isEven = i % 2 == 0;
                                  return Container(
                                    color: isEven
                                        ? const Color(0xFFF9F9FF)
                                        : Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 12),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                            width: 200,
                                            child: Text(item.fromTo)),
                                        SizedBox(
                                            width: 200,
                                            child: Text(item.formula)),
                                        SizedBox(
                                            width: 200,
                                            child: Text(item.example)),
                                      ],
                                    ),
                                  );
                                }),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),
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
