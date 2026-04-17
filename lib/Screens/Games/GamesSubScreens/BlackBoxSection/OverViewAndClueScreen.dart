import 'package:avionics_internal/CustomFiles/CustomAppBar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../Constants/ApiClass/ApiErrorModel.dart';
import '../../../../Constants/ApiClass/FirebaseAnalytics/analytics_service.dart';
import '../../../../Constants/ApiClass/FirebaseAnalytics/event_names.dart';
import '../../../../CustomFiles/CustomBottomButton.dart';
import '../../../../Helpers/AppTextStyles/AppTextStyles.dart';
import '../../../../bloc/Games/SubGameSection/BlackBox_Section/blackBox_state.dart'
    hide CommonApiStatus;
import '../../../../bloc/Games/SubGameSection/BlackBox_Section/blackbox_cubit.dart';
import '../../../../Constants/AppColors.dart';
import '../../../../Constants/ConstantStrings.dart';
import 'BlackBoxQuestionScreen.dart';

class OverviewAndClueDeckScreen extends StatefulWidget {
  final int gameNo;

  const OverviewAndClueDeckScreen({super.key, required this.gameNo});

  @override
  State<OverviewAndClueDeckScreen> createState() =>
      _OverviewAndClueDeckScreenState();
}

class _OverviewAndClueDeckScreenState extends State<OverviewAndClueDeckScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    AnalyticsService.instance.logVisibleScreen(
      FirebaseEvents.blackBoxOverViewClueScreen,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          BlackboxCubit()
            ..loadBlackboxSummary(context: context, gameNo: widget.gameNo),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          title: 'Overview & Clue Deck',
          leftButton: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1500),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2),
                      child: Text(
                        kIsWeb
                            ? 'These data cards provide the essential facts review carefully before drawing conclusions.'
                            : 'These data cards provide the essential facts—\nreview carefully before drawing conclusions.',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: BlocBuilder<BlackboxCubit, BlackBoxState>(
                        builder: (context, state) {
                          if (state.isLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (state.status == CommonApiStatus.failure) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    state.errorMessage ?? 'An error occurred',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.red,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  ElevatedButton(
                                    onPressed: () {
                                      context
                                          .read<BlackboxCubit>()
                                          .loadBlackboxSummary(
                                            context: context,
                                            gameNo: widget.gameNo,
                                          );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          AppColors.customBottomEnabledColour,
                                      foregroundColor: Colors.white,
                                    ),
                                    child: const Text('Retry'),
                                  ),
                                ],
                              ),
                            );
                          }

                          final blackboxList = state.blackboxModels ?? [];
                          if (blackboxList.isEmpty) {
                            return const Center(
                              child: Text(
                                'No blackbox models available',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            );
                          }

                          final clues = blackboxList
                              .expand((b) => b.data ?? [])
                              .toList();

                          if (clues.isEmpty) {
                            return const Center(
                              child: Text(
                                'No clues available',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            );
                          }

                          return Column(
                            children: [
                              Expanded(
                                child: ScrollConfiguration(
                                  behavior: ScrollConfiguration.of(context)
                                      .copyWith(
                                        dragDevices: {
                                          PointerDeviceKind.touch,
                                          PointerDeviceKind.mouse,
                                          PointerDeviceKind.trackpad,
                                        },
                                      ),
                                  child: PageView.builder(
                                    controller: _pageController,
                                    onPageChanged: (index) {
                                      setState(() => _currentPage = index);
                                    },
                                    itemCount: clues.length,
                                    itemBuilder: (context, index) {
                                      final clue = clues[index];

                                      return Card(
                                        color: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        elevation: 2,
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                clue.title ?? 'No Title',
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFF1E80F2),
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Expanded(
                                                child: SingleChildScrollView(
                                                  child: Text(
                                                    clue.description ??
                                                        'No Description',
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Color(0xFF3E3C55),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),

                              const SizedBox(height: 16),

                              SmoothPageIndicator(
                                controller: _pageController,
                                count: clues.length,
                                effect: const WormEffect(
                                  dotHeight: 8,
                                  dotWidth: 8,
                                  activeDotColor: Color(0xFF3E3C55),
                                  dotColor: Colors.grey,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 16),

                    BlocBuilder<BlackboxCubit, BlackBoxState>(
                      builder: (context, state) {
                        final clues =
                            state.blackboxModels
                                ?.expand((b) => b.data ?? [])
                                .toList() ??
                            [];
                        final isLastPage = _currentPage == clues.length - 1;

                        return Center(
                          child: SizedBox(
                            width: kIsWeb
                                ? MediaQuery.of(context).size.width * 0.5
                                : double.infinity,
                            child: CustomBottomButton(
                              fontStyle: AppTextStyles.regular(21.46).copyWith(
                                height: 1.0,
                                color: true
                                    ? Colors.white
                                    : Colors.grey.shade600,
                              ),

                              title: ConstantStrings.next,
                              backgroundColor: isLastPage
                                  ? AppColors.customBottomEnabledColour
                                  : Colors.grey.shade400,
                              textColor: Colors.white,
                              icon: const SizedBox(width: 0),
                              onPressed: () {
                                if (isLastPage) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BlackBoxScreen(
                                        gameId: 'black_box',
                                        summarySetId:
                                            state.blackboxModels!.single.summarySetId!,
                                        summaryGameNumber: widget.gameNo,
                                      ),
                                    ),
                                  ).then((reset) {
                                    if (reset == true) {
                                      _pageController.jumpToPage(0);
                                      setState(() => _currentPage = 0);
                                    }
                                  });
                                  AnalyticsService.instance.buttonPressed(
                                    FirebaseEvents.blackBoxOverViewClueScreen,
                                    FirebaseEvents.blackBoxOverViewClueButton,
                                  );
                                }
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
