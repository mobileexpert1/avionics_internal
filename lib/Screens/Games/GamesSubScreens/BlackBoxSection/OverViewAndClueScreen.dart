import 'package:avionics_internal/CustomFiles/CustomAppBar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../Constants/ApiClass/ApiErrorModel.dart';
import '../../../../Constants/ApiClass/FirebaseAnalytics/analytics_service.dart';
import '../../../../Constants/ApiClass/FirebaseAnalytics/event_names.dart';
import '../../../../Constants/AppColors.dart';
import '../../../../Constants/ConstantStrings.dart';
import '../../../../Constants/constantImages.dart';
import '../../../../CustomFiles/CustomBottomButton.dart';
import '../../../../Helpers/AppTextStyles/AppTextStyles.dart';
import '../../../../Helpers/CustomHeaderViewExpandable.dart';
import '../../../../bloc/Games/SubGameSection/BlackBox_Section/blackBox_state.dart'
    hide CommonApiStatus;
import '../../../../bloc/Games/SubGameSection/BlackBox_Section/blackbox_cubit.dart';
import 'BlackBoxQuestionScreen.dart';

class OverviewAndClueDeckScreen extends StatefulWidget {
  final int gameNo;

  const OverviewAndClueDeckScreen({super.key, required this.gameNo});

  @override
  State<OverviewAndClueDeckScreen> createState() =>
      _OverviewAndClueDeckScreenState();
}

class _OverviewAndClueDeckScreenState extends State<OverviewAndClueDeckScreen> {
  int subTab = 0;
  int _currentPage = 0;
  final PageController _pageController = PageController();

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

  void _changePage(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    setState(() {
      _currentPage = index;
      subTab = index;
    });
  }

  // AppBar back:
  // - Index 0 → screen se bahar
  // - Index 1+ → directly index 0 pe jump (Overview)
  void _handleBackButton() {
    if (_currentPage > 0) {
      _pageController.jumpToPage(0);
      setState(() {
        _currentPage = 0;
        subTab = 0;
      });
    } else {
      Navigator.of(context).pop();
    }
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
          centerTitle: false,
          //Index 0 pe "Overview", index 1+ pe "Clue Deck"
          title: _currentPage == 0 ? 'Overview' : 'Clue Deck',
          leftButton: IconButton(
            icon: SvgPicture.asset(
              CommonUi.setSvgImage(AssetsPath.backArrowButton),
              fit: BoxFit.cover,
            ),
            onPressed: _handleBackButton,
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
                                    style: AppTextStyles.bold(
                                      18,
                                    ).copyWith(height: 1.4, color: Colors.red),
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
                            return Center(
                              child: Text(
                                'No blackbox models available',
                                style: AppTextStyles.bold(18).copyWith(
                                  height: 1.4,
                                  color: AppColors.grayMedium,
                                ),
                              ),
                            );
                          }

                          final clues = blackboxList
                              .expand((b) => b.data ?? [])
                              .toList();
                          if (clues.isEmpty) {
                            return Center(
                              child: Text(
                                'No clues available',
                                style: AppTextStyles.bold(18).copyWith(
                                  height: 1.4,
                                  color: AppColors.primaryValueColour,
                                ),
                              ),
                            );
                          }

                          final bool isLastPage =
                              _currentPage == clues.length - 1;

                          // Progress dots sirf clue pages ke liye
                          // Total clue count = clues.length - 1  (index 0 = overview, skip karo)
                          // Active dot = _currentPage - 1   (clue pages 0-based)
                          final int totalClueDots = clues.length - 1;
                          final int activeDotIndex = _currentPage - 1;

                          return Column(
                            children: [
                              Expanded(
                                child: NotificationListener<ScrollNotification>(
                                  onNotification: (notification) {
                                    // Agar user clue 1 (index 1) pe hai
                                    // aur left swipe karke index 0 pe jane ki try kare
                                    if (_currentPage == 1 &&
                                        notification
                                            is ScrollUpdateNotification &&
                                        _pageController.page != null &&
                                        _pageController.page! < 1) {
                                      // Force back to index 1
                                      WidgetsBinding.instance
                                          .addPostFrameCallback((_) {
                                            if (_pageController.hasClients) {
                                              _pageController.jumpToPage(1);
                                            }
                                          });

                                      return false;
                                    }
                                    return false;
                                  },
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
                                      // Sirf index 0 pe gesture disable,
                                      // index 1+ pe normal swipe enable
                                      physics: _currentPage == 0
                                          ? const NeverScrollableScrollPhysics()
                                          : const ClampingScrollPhysics(),
                                      onPageChanged: (index) {
                                        setState(() {
                                          _currentPage = index;
                                          subTab = index;
                                        });
                                      },
                                      itemCount: clues.length,
                                      itemBuilder: (context, index) {
                                        final clue = clues[index];

                                        return Card(
                                          color: Colors.white,
                                          clipBehavior: Clip.hardEdge,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          elevation: 2,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // Index 0 = Overview (blue), 1+ = Clue (yellow)
                                              Container(
                                                height: 10,
                                                width: double.infinity,
                                                color: index == 0
                                                    ? AppColors.primaryBlue
                                                    : AppColors.extraDarkYellow,
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                    16.0,
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      if (_currentPage !=
                                                          0) ...[
                                                        Text(
                                                          'Clue#$index',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style:
                                                              AppTextStyles.bold(
                                                                20,
                                                              ).copyWith(
                                                                height: 1,
                                                                color: AppColors
                                                                    .extraDarkYellow,
                                                              ),
                                                        ),
                                                        const SizedBox(
                                                          height: 20,
                                                        ),
                                                      ],
                                                      Text(
                                                        clue.title ??
                                                            'No Title',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: _currentPage == 0
                                                            ? AppTextStyles.bold(
                                                                18,
                                                              ).copyWith(
                                                                height: 1,
                                                                color: AppColors
                                                                    .primaryValueColour,
                                                              )
                                                            : AppTextStyles.regular(
                                                                16,
                                                              ).copyWith(
                                                                height: 1.4,
                                                                color: AppColors
                                                                    .primaryValueColour,
                                                              ),
                                                      ),
                                                      const SizedBox(
                                                        height: 20,
                                                      ),
                                                      Expanded(
                                                        child: SingleChildScrollView(
                                                          child: Text(
                                                            clue.description ??
                                                                'No Description',
                                                            style:
                                                                AppTextStyles.regular(
                                                                  14,
                                                                ).copyWith(
                                                                  height: 1.9,
                                                                  color: AppColors
                                                                      .grayMedium,
                                                                ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),

                              // Index 0  → hidden (sirf neeche button)
                              // Index 1  → spacer | progress bar | right arrow
                              // Index 2+ → left arrow | progress bar | right arrow (ya spacer agar last)
                              if (_currentPage > 0 && clues.length > 1) ...[
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Left arrow: index 2+ pe dikhao, index 1 pe spacer
                                    if (_currentPage >= 2)
                                      IconButton(
                                        icon: const Icon(Icons.arrow_back_ios),
                                        onPressed: () =>
                                            _changePage(_currentPage - 1),
                                      )
                                    else
                                      const SizedBox(width: 48),

                                    // Progress bar index 1 se dikhao
                                    // Dots = totalClueDots, active = activeDotIndex (0-based)
                                    if (totalClueDots > 0)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 7,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.primaryDark,
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: List.generate(
                                            totalClueDots,
                                            (dotIndex) {
                                              final isActive =
                                                  activeDotIndex == dotIndex;
                                              return AnimatedContainer(
                                                duration: const Duration(
                                                  milliseconds: 250,
                                                ),
                                                curve: Curves.easeInOut,
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 4,
                                                    ),
                                                width: isActive ? 20 : 6,
                                                height: 6,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),

                                    // Right arrow: last page pe spacer, warna arrow
                                    if (!isLastPage)
                                      IconButton(
                                        icon: const Icon(
                                          Icons.arrow_forward_ios,
                                        ),
                                        onPressed: () =>
                                            _changePage(_currentPage + 1),
                                      )
                                    else
                                      const SizedBox(width: 48),
                                  ],
                                ),
                              ],
                            ],
                          );
                        },
                      ),
                    ),

                    // ── Bottom Button ────────────────────────────────────────
                    // Sirf index 0 (Overview) aur last page pe dikhao
                    const SizedBox(height: 16),
                    BlocBuilder<BlackboxCubit, BlackBoxState>(
                      builder: (context, state) {
                        final clues =
                            state.blackboxModels
                                ?.expand((b) => b.data ?? [])
                                .toList() ??
                            [];

                        final bool isFirstPage = _currentPage == 0;
                        final bool isLastPage =
                            clues.isNotEmpty &&
                            _currentPage == clues.length - 1;

                        if (!isFirstPage && !isLastPage) {
                          return const SizedBox.shrink();
                        }

                        // Last page → CustomHeaderViewExpandable
                        if (isLastPage) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30.0,
                            ),
                            child: CustomHeaderViewExpandable(
                              textAlign: TextAlign.center,
                              isNeedToShowLeftRightBottomBorder: false,
                              isNeedToShowLeftImage: false,
                              isExpanded: false,
                              title: ConstantStrings.startInvestigationText,
                              headerColor: AppColors.primaryDark,
                              arrowBackgroundColor: AppColors.extraDarkYellow,
                              arrowFrontColor: Colors.black,
                              isExpandedViewAvailable: true,
                              fontStyle: AppTextStyles.regular(18).copyWith(
                                height: 1.4,
                                color: AppColors.white,
                                letterSpacing: 0.2,
                              ),
                              onHeaderTap: () async {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BlackBoxScreen(
                                      gameId: 'black_box',
                                      summarySetId: state
                                          .blackboxModels!
                                          .single
                                          .summarySetId!,
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
                              },
                            ),
                          );
                        }
                        // Index 0 (Overview) → "Start Investigation" button
                        return Center(
                          child: SizedBox(
                            width: kIsWeb
                                ? MediaQuery.of(context).size.width * 0.5
                                : double.infinity,
                            child: CustomBottomButton(
                              fontStyle: AppTextStyles.regular(
                                21.46,
                              ).copyWith(height: 1.0, color: Colors.white),
                              title: ConstantStrings.beginAnalysisText,
                              backgroundColor: AppColors.primaryDark,
                              textColor: Colors.white,
                              icon: const SizedBox(width: 0),
                              onPressed: () => _changePage(1),
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
