import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Constants/ApiClass/ApiErrorModel.dart';
import '../../../Constants/ApiClass/FirebaseAnalytics/analytics_service.dart';
import '../../../Constants/ApiClass/FirebaseAnalytics/event_names.dart';
import '../../../Constants/AppColors.dart';
import '../../../CustomFiles/CustomAppBar.dart';
import '../../../Helpers/CustomHeaderViewExpandable.dart';
import '../../../bloc/Profile/ConversionSection/conversion_cubit.dart';
import '../../../bloc/Profile/ConversionSection/conversion_state.dart';

class ConversionsScreen extends StatefulWidget {
  const ConversionsScreen({super.key});

  @override
  State<ConversionsScreen> createState() => _ConversionsScreenState();
}

class _ConversionsScreenState extends State<ConversionsScreen> {
  late ConversionCubit _cubit;

  /// expand collapse map
  Map<int, bool> expandedMap = {};

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
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: Colors.white,

        appBar: CustomAppBar(
          title: 'Conversions Table',
          leftButton: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),

        body: BlocConsumer<ConversionCubit, ConversionState>(
          listenWhen: (previous, current) => previous.status != current.status,
          listener: (context, state) {
            if (state.status == CommonApiStatus.failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage ?? "Something went wrong"),
                ),
              );
            }
          },
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.categories.isEmpty) {
              return const Center(child: Text("No conversions found"));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.categories.length,
              itemBuilder: (context, index) {
                final category = state.categories[index];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: CustomHeaderViewExpandable(
                    // HEADER CONFIG
                    isNeedToShowLeftRightBottomBorder: false,
                    isNeedToShowLeftImage: false,
                    isExpanded: expandedMap[index] ?? true,
                    title: category.title,
                    headerColor: expandedMap[index] ?? true
                        ? AppColors.primaryDark
                        : AppColors.grayMedium,
                    arrowBackgroundColor: expandedMap[index] ?? true
                        ? AppColors.extraDarkYellow
                        : AppColors.lightGreyWithAlphaDecreased,
                    arrowFrontColor: Colors.white,
                    isExpandedViewAvailable: true,
                    onHeaderTap: () {
                      setState(() {
                        expandedMap[index] = !(expandedMap[index] ?? true);
                      });
                    },
                    // BODY
                    child: _buildConversionBody(category),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildConversionBody(category) {
    return Column(
      children: [
        // HEADER ROW
        Container(
          color: AppColors.greyForConversionScreen,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: const Row(
            children: [
              Expanded(
                child: Text(
                  textAlign: TextAlign.center,
                  "From ⇄ To",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              Expanded(
                child: Text(
                  textAlign: TextAlign.center,
                  "Conversion",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),

        // DATA ROWS
        ...List.generate(category.items.length, (index) {
          final item = category.items[index];
          return Column(
            children: [
              // CONVERSION ROW
              Container(
                color: index.isEven
                    ? AppColors.grayLight
                    : AppColors.greyForConversionScreen,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(item.fromTo, style: TextStyle(fontSize: 13)),
                    ),
                    Expanded(
                      child: Text(item.formula, style: TextStyle(fontSize: 10)),
                    ),
                  ],
                ),
              ),

              // EXAMPLE ROW
              Container(
                color: AppColors.greyForConversionScreen,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Example: ${item.example}",
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ],
    );
  }
}
