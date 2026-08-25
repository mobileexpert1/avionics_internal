import 'package:avionics_internal/Screens/Profile/SettingScreen/SettingMenuScreen/3_AddOnPacks/AddOnPacksScreen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:video_player/video_player.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../../Constants/ApiClass/FirebaseAnalytics/analytics_service.dart';
import '../../../../../Constants/ApiClass/FirebaseAnalytics/event_names.dart';
import '../../../../../Constants/ConstantStrings.dart';
import '../../../../../Constants/constantImages.dart';
import '../../../../../CustomFiles/CustomAppBar.dart';
import '../../../../../Helpers/WebAndMobileBrowser/web_iframe_widget.dart';
import '../../../../../bloc/Profile/ManageAccount/manageAcc_cubit.dart';
import '../../../../../bloc/Profile/ManageAccount/manageAcc_state.dart';
import '../../../../Constants/ApiClass/shared_prefs_helper.dart';
import '../../../../Constants/AppColors.dart';
import '../../../../CustomFiles/CustomBottomButton.dart';
import '../../../../Helpers/AppNavigator.dart';
import '../../../../Helpers/AppTextStyles/AppTextStyles.dart';
import '../QuizSection/QuizQuestionScreen.dart';

class JettingAroundTheBoardingPass extends StatefulWidget {
  const JettingAroundTheBoardingPass({
    super.key,
    required this.isComeFromHistoryScreen,
    required this.boardingPassId,
    required this.isNeedToShowOnlyBoardingPass,
  });

  final bool isComeFromHistoryScreen;
  final String boardingPassId;
  final bool isNeedToShowOnlyBoardingPass;

  @override
  State<JettingAroundTheBoardingPass> createState() =>
      _JettingAroundTheBoardingState();
}

class _JettingAroundTheBoardingState
    extends State<JettingAroundTheBoardingPass> {
  WebViewController? controller;

  String currentUserId = "";
  String userName = "";
  double tokenUsagePercentage = 0.0;
  double creditUsagePercentage = 0.0;
  String _webUrl = "";
  int isClickOnNextButton = 0;
  int currentIndexForPass = 0;
  VideoPlayerController? _videoController;

  @override
  void initState() {
    super.initState();
    AnalyticsService.instance.logVisibleScreen(
      FirebaseEvents.creditTokenScreen,
    );

    if (!kIsWeb) {
      controller = WebViewController()
        ..enableZoom(false)
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..addJavaScriptChannel(
          'Flutter',
          onMessageReceived: (JavaScriptMessage message) async {},
        );
    }

    _videoController =
        VideoPlayerController.asset(
            CommonUi.setGifAndVideoImage(AssetsPath.phaseAnimationVideo, true),
          )
          ..initialize().then((_) {
            if (mounted) {
              setState(() {});
            }
          });

    _returnCurrentCount();
  }

  Future<void> openAddOnPacksBottomSheet() async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return FractionallySizedBox(
          heightFactor: 0.70,
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: const AddOnPacksScreen(packType: AddOnPackType.both),
          ),
        );
      },
    );

    if (result == true && mounted) {
      setState(() {
        final url = _buildUrl(false);

        if (kIsWeb) {
          setState(() => _webUrl = url);
        } else {
          controller!.loadRequest(Uri.parse(url));
        }
      });
    }
  }

  Future<void> _returnCurrentCount() async {
    final count = await SharedPrefsHelper.getJettingGamesCount();
    setState(() {
      currentIndexForPass = count;
    });
  }

  String _buildUrl(bool isForFirstScreen) {
    if (isForFirstScreen) {
      final gameNoOrBoardingId = widget.isComeFromHistoryScreen
          ? "boarding_pass_id=${widget.boardingPassId}"
          : "game_no=$currentIndexForPass";
      return "${ApiBaseUrlConstant.baseUrl}${ApiFunctionUrlConstant.userService}${ApiFunctionUrlGamesConstant.boardingPass}user_id=$currentUserId&$gameNoOrBoardingId";
    }
    return ApiBaseUrlConstant.baseUrl +
        ApiFunctionUrlConstant.userService +
        ApiFunctionUrlGamesConstant.ticketUsername +
        userName;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ManageaccCubit()..fetchUserDetails(context),
      child: BlocConsumer<ManageaccCubit, ManageAccState>(
        listener: (context, state) async {
          if (!state.isLoading) {
            userName = "${state.firstName} ${state.lastName}";
            currentUserId = state.userId;
            tokenUsagePercentage = state.tokenUsagePercentage ?? 0.0;
            creditUsagePercentage = state.creditUsagePercentage ?? 0.0;
            if (userName != "") {
              final url = _buildUrl(
                widget.isComeFromHistoryScreen
                    ? true
                    : widget.isNeedToShowOnlyBoardingPass
                    ? true
                    : false,
              );
              print(url);
              if (kIsWeb) {
                setState(() => _webUrl = url);
              } else {
                controller!.loadRequest(Uri.parse(url));
              }
            }
          }
        },
        builder: (context, state) {
          if (state.isLoading) {
            return const Scaffold(
              backgroundColor: Colors.white,
              body: Center(child: CircularProgressIndicator()),
            );
          }

          return Scaffold(
            backgroundColor: Colors.white,
            appBar: CustomAppBar(
              title: isClickOnNextButton == 0
                  ? widget.isComeFromHistoryScreen
                        ? ConstantStrings.boardingPassTitle
                        : widget.isNeedToShowOnlyBoardingPass
                        ? ConstantStrings.boardingPassTitle
                        : ConstantStrings.airlineTicketTitle
                  : isClickOnNextButton == 1
                  ? ConstantStrings.jettingAroundTheWorldTitle
                  : ConstantStrings.boardingPassTitle,
              isForComparison: true,
              centerTitle: false,
              leftButton: IconButton(
                icon: SvgPicture.asset(
                  CommonUi.setSvgImage(AssetsPath.backArrowButton),
                  fit: BoxFit.cover,
                ),
                onPressed: () {
                  if (isClickOnNextButton == 1) {
                    _videoController?.pause();
                    _videoController?.seekTo(Duration.zero);

                    setState(() {
                      isClickOnNextButton = 0;
                    });
                  } else {
                    Navigator.pop(context, true);
                  }
                },
              ),
            ),
            body: Column(
              children: [
                if (isClickOnNextButton == 1) ...[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 10,
                        bottom: 20,
                        left: 10,
                        right: 10,
                      ),
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: Colors.white,
                        child:
                            _videoController != null &&
                                _videoController!.value.isInitialized
                            ? RotatedBox(
                                quarterTurns: 3,
                                child: SizedBox(
                                  width: double.infinity,
                                  height: double.infinity,
                                  child: FittedBox(
                                    fit: BoxFit.fill,
                                    clipBehavior: Clip.hardEdge,
                                    child: SizedBox(
                                      width: _videoController!.value.size.width,
                                      height:
                                          _videoController!.value.size.height,
                                      child: VideoPlayer(_videoController!),
                                    ),
                                  ),
                                ),
                              )
                            : const Center(child: CircularProgressIndicator()),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: CustomBottomButton(
                      fontStyle: AppTextStyles.regular(
                        18,
                      ).copyWith(height: 1.0, color: Colors.white),
                      title: ConstantStrings.skip,
                      backgroundColor: AppColors.primaryDark,
                      textColor: Colors.white,
                      icon: const SizedBox(width: 0),
                      isEnabled: true,
                      onPressed: () {
                        setState(() {
                          isClickOnNextButton = 3;
                          final url = _buildUrl(true);
                          if (kIsWeb) {
                            setState(() => _webUrl = url);
                          } else {
                            controller!.loadRequest(Uri.parse(url));
                          }
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 15),
                ],
                if (isClickOnNextButton == 0 || isClickOnNextButton == 3) ...[
                  Expanded(
                    child: kIsWeb
                        ? _webUrl.isEmpty
                              ? const Center(child: CircularProgressIndicator())
                              : WebIframeWidget(url: _webUrl)
                        : controller == null
                        ? const Center(child: CircularProgressIndicator())
                        : WebViewWidget(controller: controller!),
                  ),

                  const SizedBox(height: 10),
                  if (!widget.isComeFromHistoryScreen) ...[
                    Center(
                      child: SizedBox(
                        width: kIsWeb
                            ? MediaQuery.of(context).size.width * 0.45
                            : double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40.0),
                          child: CustomBottomButton(
                            fontStyle: AppTextStyles.regular(
                              18,
                            ).copyWith(height: 1.0, color: Colors.white),
                            title: ConstantStrings.readyForDepartureTitle,
                            backgroundColor: AppColors.primaryDark,
                            textColor: Colors.white,
                            icon: const SizedBox(width: 0),
                            isEnabled: true,
                            onPressed: () {
                              if (widget.isNeedToShowOnlyBoardingPass) {
                                AppNavigator.push(
                                  context,
                                  QuizQuestionScreen(
                                    sectionId: 0,
                                    sectionTitle: "Jetting Around The World",
                                    gameId: "trivia",
                                  ),
                                  disableSwipeBack: true,
                                );
                              } else {
                                if (isClickOnNextButton == 0) {
                                  setState(() {
                                    isClickOnNextButton = 1;
                                  });

                                  if (_videoController != null &&
                                      _videoController!.value.isInitialized) {
                                    _videoController!
                                      ..seekTo(Duration.zero)
                                      ..play();

                                    Future.delayed(
                                      const Duration(seconds: 12),
                                      () {
                                        setState(() {
                                          isClickOnNextButton = 3;
                                          final url = _buildUrl(true);
                                          if (kIsWeb) {
                                            setState(() => _webUrl = url);
                                          } else {
                                            controller!.loadRequest(
                                              Uri.parse(url),
                                            );
                                          }
                                        });
                                      },
                                    );
                                  }
                                } else if (isClickOnNextButton == 3) {
                                  AppNavigator.push(
                                    context,
                                    QuizQuestionScreen(
                                      sectionId: 0,
                                      sectionTitle: "Jetting Around The World",
                                      gameId: "trivia",
                                    ),
                                    disableSwipeBack: true,
                                  );
                                }
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 30),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
