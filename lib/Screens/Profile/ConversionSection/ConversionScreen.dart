// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../../CustomFiles/CustomAppBar.dart';
// import '../../../bloc/Profile/ConversionSection/conversion_cubit.dart';
// import '../../../bloc/Profile/ConversionSection/conversion_state.dart';
//
// class ConversionsScreen extends StatelessWidget {
//   const ConversionsScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final screenSize = MediaQuery.of(context).size;
//     print("screenSize : ${screenSize.height}");
//     return BlocProvider(
//       create: (_) => ConversionCubit()..loadConversions(),
//       child: Scaffold(
//         backgroundColor: const Color(0xFFF5F5F7),
//         appBar: CustomAppBar(
//           title: 'Conversions Table',
//           leftButton: IconButton(
//             icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
//             onPressed: () => Navigator.of(context).pop(),
//           ),
//         ),
//         body: BlocBuilder<ConversionCubit, ConversionState>(
//           builder: (context, state) {
//             if (state.isLoading) {
//               return const Center(child: CircularProgressIndicator());
//             }
//
//             return ListView.builder(
//               padding: const EdgeInsets.all(16),
//               itemCount: state.categories.length,
//               itemBuilder: (context, index) {
//                 final category = state.categories[index];
//                 final horizontalController = ScrollController();
//
//                 return Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     Center(
//                       child: Text(
//                         category.title,
//                         style: const TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: Color(0xFF32377D),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 12),
//                     // ScrollbarTheme(
//                     //   data: ScrollbarThemeData(
//                     //     thumbColor: WidgetStateProperty.all(
//                     //       const Color(0xFF1E80F2),
//                     //     ),
//                     //     radius: const Radius.circular(6),
//                     //     thickness: WidgetStateProperty.all(3),
//                     //     crossAxisMargin: 4,
//                     //     mainAxisMargin: 2,
//                     //   ),
//                     //   child: Scrollbar(
//                     //     controller: horizontalController,
//                     //     thumbVisibility: true,
//                     //     trackVisibility: false,
//                     //     child: Padding(
//                     //       padding: const EdgeInsets.only(bottom: 5),
//                     //       child: SingleChildScrollView(
//                     //         controller: horizontalController,
//                     //         scrollDirection: Axis.horizontal,
//                     //         child: ConstrainedBox(
//                     //           constraints: const BoxConstraints(minWidth: 600),
//                     //           child: Column(
//                     //             children: [
//                     //               Container(
//                     //                 decoration: const BoxDecoration(
//                     //                   color: Color(0xFF1E80F2),
//                     //                   borderRadius: BorderRadius.vertical(
//                     //                     top: Radius.circular(8),
//                     //                   ),
//                     //                 ),
//                     //                 padding: const EdgeInsets.symmetric(
//                     //                   vertical: 10,
//                     //                   horizontal: 12,
//                     //                 ),
//                     //                 child: const Row(
//                     //                   children: [
//                     //                     SizedBox(
//                     //                       width: 200,
//                     //                       child: Text(
//                     //                         "From → To",
//                     //                         style: TextStyle(
//                     //                           color: Colors.white,
//                     //                           fontWeight: FontWeight.w600,
//                     //                         ),
//                     //                       ),
//                     //                     ),
//                     //                     SizedBox(
//                     //                       width: 200,
//                     //                       child: Text(
//                     //                         "Conversion",
//                     //                         style: TextStyle(
//                     //                           color: Colors.white,
//                     //                           fontWeight: FontWeight.w600,
//                     //                         ),
//                     //                       ),
//                     //                     ),
//                     //                     SizedBox(
//                     //                       width: 200,
//                     //                       child: Text(
//                     //                         "Example",
//                     //                         style: TextStyle(
//                     //                           color: Colors.white,
//                     //                           fontWeight: FontWeight.w600,
//                     //                         ),
//                     //                       ),
//                     //                     ),
//                     //                   ],
//                     //                 ),
//                     //               ),
//                     //               ...List.generate(category.items.length, (i) {
//                     //                 final item = category.items[i];
//                     //                 final isEven = i % 2 == 0;
//                     //                 return Container(
//                     //                   color: isEven
//                     //                       ? const Color(0xFFF9F9FF)
//                     //                       : Colors.white,
//                     //                   padding: const EdgeInsets.symmetric(
//                     //                     vertical: 10,
//                     //                     horizontal: 12,
//                     //                   ),
//                     //                   child: Row(
//                     //                     children: [
//                     //                       SizedBox(
//                     //                         width: 200,
//                     //                         child: Text(item.fromTo),
//                     //                       ),
//                     //                       SizedBox(
//                     //                         width: 200,
//                     //                         child: Text(item.formula),
//                     //                       ),
//                     //                       SizedBox(
//                     //                         width: 200,
//                     //                         child: Text(item.example),
//                     //                       ),
//                     //                     ],
//                     //                   ),
//                     //                 );
//                     //               }),
//                     //             ],
//                     //           ),
//                     //         ),
//                     //       ),
//                     //     ),
//                     //   ),
//                     // ),
//                     /// 2)
//                     // ScrollbarTheme(
//                     //   data: ScrollbarThemeData(
//                     //     thumbColor: WidgetStateProperty.all(const Color(0xFF1E80F2)),
//                     //     radius: const Radius.circular(6),
//                     //     thickness: WidgetStateProperty.all(3),
//                     //     crossAxisMargin: 4,
//                     //     mainAxisMargin: 2,
//                     //   ),
//                     //   child: LayoutBuilder(
//                     //     builder: (context, constraints) {
//                     //       // Determine if screen is small
//                     //       final isSmallDevice = constraints.maxWidth < 600;
//                     //
//                     //       return Padding(
//                     //         padding: EdgeInsets.only(bottom: isSmallDevice ? 6 : 0), // ✅ Adaptive padding
//                     //         child: Scrollbar(
//                     //           controller: horizontalController,
//                     //           thumbVisibility: true,
//                     //           trackVisibility: false,
//                     //           child: SingleChildScrollView(
//                     //             controller: horizontalController,
//                     //             scrollDirection: Axis.horizontal,
//                     //             child: ConstrainedBox(
//                     //               constraints: const BoxConstraints(minWidth: 600),
//                     //               child: Column(
//                     //                 children: [
//                     //                   Container(
//                     //                     decoration: const BoxDecoration(
//                     //                       color: Color(0xFF1E80F2),
//                     //                       borderRadius:
//                     //                       BorderRadius.vertical(top: Radius.circular(8)),
//                     //                     ),
//                     //                     padding:  EdgeInsets.symmetric(
//                     //                         vertical: 10, horizontal: 12),
//                     //                     child: Row(
//                     //                       children: [
//                     //                         const SizedBox(
//                     //                             width: 200,
//                     //                             child: Text("From → To",
//                     //                                 style: TextStyle(
//                     //                                     color: Colors.white,
//                     //                                     fontWeight: FontWeight.w600))),
//                     //                         const SizedBox(
//                     //                             width: 200,
//                     //                             child: Text("Conversion",
//                     //                                 style: TextStyle(
//                     //                                     color: Colors.white,
//                     //                                     fontWeight: FontWeight.w600))),
//                     //                         const SizedBox(
//                     //                             width: 200,
//                     //                             child: Text("Example",
//                     //                                 style: TextStyle(
//                     //                                     color: Colors.white,
//                     //                                     fontWeight: FontWeight.w600))),
//                     //                       ],
//                     //                     ),
//                     //                   ),
//                     //                   ...List.generate(category.items.length, (i) {
//                     //                     final item = category.items[i];
//                     //                     final isEven = i % 2 == 0;
//                     //                     return Container(
//                     //                       color: isEven
//                     //                           ? const Color(0xFFF9F9FF)
//                     //                           : Colors.white,
//                     //                       padding: EdgeInsets.symmetric(
//                     //                           vertical: screenSize.height * 0.013, horizontal: 12),
//                     //                       child: Row(
//                     //                         children: [
//                     //                           SizedBox(width: 200, child: Text(item.fromTo)),
//                     //                           SizedBox(width: 200, child: Text(item.formula)),
//                     //                           SizedBox(width: 200, child: Text(item.example)),
//                     //                         ],
//                     //                       ),
//                     //                     );
//                     //                   }),
//                     //                 ],
//                     //               ),
//                     //             ),
//                     //           ),
//                     //         ),
//                     //       );
//                     //     },
//                     //   ),
//                     // ),
//                     ///
//                     LayoutBuilder(
//                       builder: (context, constraints) {
//                         final isSmallDevice = constraints.maxWidth < 600;
//
//                         return Container(
//                           margin: EdgeInsets.only(bottom: isSmallDevice ? 8 : 0), // ✅ gap below table
//                           child: ScrollbarTheme(
//                             data: ScrollbarThemeData(
//                               thumbColor: WidgetStateProperty.all(const Color(0xFF1E80F2)),
//                               radius: const Radius.circular(6),
//                               thickness: WidgetStateProperty.all(3),
//                               crossAxisMargin: screenSize.height > 760 ? -14 : 2,
//                               mainAxisMargin: 4,
//                             ),
//                             child: Scrollbar(
//                               controller: horizontalController,
//                               thumbVisibility: true,
//                               trackVisibility: false,
//                               child: SingleChildScrollView(
//                                 controller: horizontalController,
//                                 scrollDirection: Axis.horizontal,
//                                 // ✅ Wrap in ClipRRect to prevent scroll from overlapping inner area
//                                 child: ClipRRect(
//                                   borderRadius: const BorderRadius.vertical(bottom: Radius.circular(8)),
//                                   child: ConstrainedBox(
//                                     constraints: const BoxConstraints(minWidth: 600),
//                                     child: Column(
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: [
//                                         // ✅ HEADER
//                                         Container(
//                                           decoration: const BoxDecoration(
//                                             color: Color(0xFF1E80F2),
//                                             borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
//                                           ),
//                                           padding:
//                                           const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
//                                           child: const Row(
//                                             children: [
//                                               SizedBox(
//                                                 width: 200,
//                                                 child: Text(
//                                                   "From → To",
//                                                   style: TextStyle(
//                                                     color: Colors.white,
//                                                     fontWeight: FontWeight.w600,
//                                                   ),
//                                                 ),
//                                               ),
//                                               SizedBox(
//                                                 width: 200,
//                                                 child: Text(
//                                                   "Conversion",
//                                                   style: TextStyle(
//                                                     color: Colors.white,
//                                                     fontWeight: FontWeight.w600,
//                                                   ),
//                                                 ),
//                                               ),
//                                               SizedBox(
//                                                 width: 200,
//                                                 child: Text(
//                                                   "Example",
//                                                   style: TextStyle(
//                                                     color: Colors.white,
//                                                     fontWeight: FontWeight.w600,
//                                                   ),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                         // ✅ BODY
//                                         ...List.generate(category.items.length, (i) {
//                                           final item = category.items[i];
//                                           final isEven = i % 2 == 0;
//                                           return Container(
//                                             color:
//                                             isEven ? const Color(0xFFF9F9FF) : Colors.white,
//                                             padding: const EdgeInsets.symmetric(
//                                                 vertical: 10, horizontal: 12),
//                                             child: Row(
//                                               children: [
//                                                 SizedBox(width: 200, child: Text(item.fromTo)),
//                                                 SizedBox(width: 200, child: Text(item.formula)),
//                                                 SizedBox(width: 200, child: Text(item.example)),
//                                               ],
//                                             ),
//                                           );
//                                         }),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                     const SizedBox(height: 24),
//                   ],
//                 );
//               },
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Constants/ApiClass/FirebaseAnalytics/analytics_service.dart';
import '../../../Constants/ApiClass/FirebaseAnalytics/event_names.dart';
import '../../../CustomFiles/CustomAppBar.dart';
import '../../../bloc/Profile/ConversionSection/conversion_cubit.dart';
import '../../../bloc/Profile/ConversionSection/conversion_state.dart';

class ConversionsScreen extends StatefulWidget {
  const ConversionsScreen({super.key});

  @override
  State<ConversionsScreen> createState() => _ConversionsScreenState();
}

class _ConversionsScreenState extends State<ConversionsScreen> {
  late ConversionCubit _cubit;

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    print("screenSize : ${screenSize.height}");

    return BlocProvider.value(
      value: _cubit,
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
                final horizontalController = ScrollController();

                return Column(
                  crossAxisAlignment: kIsWeb
                      ? CrossAxisAlignment.center
                      : CrossAxisAlignment.stretch,
                  children: [
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

                    LayoutBuilder(
                      builder: (context, constraints) {
                        final isSmallDevice = constraints.maxWidth < 600;

                        return Center(
                          child: Container(
                            margin: EdgeInsets.only(
                              bottom: isSmallDevice ? 8 : 0,
                            ),
                            child: ScrollbarTheme(
                              data: _scrollbarTheme(context, screenSize.height),
                              child: Scrollbar(
                                controller: horizontalController,
                                thumbVisibility: true,
                                trackVisibility: true,
                                interactive: true,
                                scrollbarOrientation:
                                ScrollbarOrientation.bottom,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    bottom: !kIsWeb && Platform.isIOS ? 40 : 0,
                                  ),
                                  child: SingleChildScrollView(
                                    controller: horizontalController,
                                    scrollDirection: Axis.horizontal,
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: IntrinsicWidth(
                                        child: ClipRRect(
                                          borderRadius:
                                          const BorderRadius.vertical(
                                            bottom: Radius.circular(8),
                                          ),
                                          child: _buildConversionTable(
                                            category,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
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

  // --- Table UI unchanged ---

  Widget _buildConversionTable(category) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: kIsWeb ? 1200 : 600,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFF1E80F2),
              borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
            ),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            child: Row(
              children: [
                SizedBox(
                    width: kIsWeb ? 350 : 200,
                    child: const Text(
                      "From → To",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    )),
                SizedBox(
                    width: kIsWeb ? 350 : 200,
                    child: const Text(
                      "Conversion",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    )),
                SizedBox(
                    width: kIsWeb ? 350 : 200,
                    child: const Text(
                      "Example",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    )),
              ],
            ),
          ),

          ...List.generate(category.items.length, (i) {
            final item = category.items[i];
            final isEven = i % 2 == 0;

            return Container(
              color: isEven ? const Color(0xFFF9F9FF) : Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              child: Row(
                children: [
                  SizedBox(width: kIsWeb ? 350 : 200, child: Text(item.fromTo)),
                  SizedBox(width: kIsWeb ? 350 : 200, child: Text(item.formula)),
                  SizedBox(width: kIsWeb ? 350 : 200, child: Text(item.example)),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  ScrollbarThemeData _scrollbarTheme(
      BuildContext context, double screenHeight) {
    return ScrollbarThemeData(
      thumbColor: WidgetStateProperty.all(const Color(0xFF1E80F2)),
      trackColor: WidgetStateProperty.all(Colors.transparent),
      trackBorderColor: WidgetStateProperty.all(Colors.transparent),
      radius: const Radius.circular(6),
      thickness: WidgetStateProperty.all(3),
      crossAxisMargin: screenHeight > 760 ? -16 : -10,
      mainAxisMargin: 4,
    );
  }
}
