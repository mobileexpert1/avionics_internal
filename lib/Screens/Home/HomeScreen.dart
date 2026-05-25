import 'package:avionics_internal/Screens/Home/HomeAirbus/AirCraftSection/SelectModelCompareScreen.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Constants/ApiClass/FirebaseAnalytics/analytics_service.dart';
import '../../Constants/ApiClass/FirebaseAnalytics/event_names.dart';
import '../../Constants/ApiClass/alertHelperForSubsPopup.dart';
import '../../Constants/AppColors.dart';
import '../../Constants/constantImages.dart';
import '../../CustomFiles/CustomAppBar.dart';
import '../../Helpers/AppListTileCard.dart';
import '../../Helpers/AppNavigator.dart';
import '../../Helpers/AppTextStyles/AppTextStyles.dart';
import '../../Helpers/CreditManager/CreditManager.dart';
import '../../Helpers/CustomHeaderViewExpandable.dart';
import '../../bloc/MapSection/flight_Map_Cubit.dart';
import '../../bloc/home/homeBloc/home_cubit.dart';
import '../../bloc/home/homeBloc/home_state.dart';
import '../../bloc/home/manufacturer/manufacturer_cubit.dart';
import '../../bloc/home/manufacturer/manufacturer_list_model.dart';
import '../MapSection/FlightMapScreen.dart';
import '../Onboarding/Subscription/SubscriptionPlanDetailScreen.dart';
import '../Profile/SettingScreen/SettingScreen.dart';
import '../WilcoBoat/ChatHistoryScreen/ChatBotScreen.dart';
import 'Manufacturer/ManufacturerDetailScreen.dart';
import 'Manufacturer/ManufacturerListScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController = TextEditingController();
  late HomeCubit homeCubit;
  bool expandedManufacturerTab = false;
  bool expandFlyingInTheAreaTab = true;
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    homeCubit = HomeCubit();
    homeCubit.fetchHomeData(context);
    homeCubit.repository.getMapKeyValueFromServer();
    AnalyticsService.instance.logVisibleScreen(FirebaseEvents.exploreScreen);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;

    return MultiBlocProvider(
      providers: [BlocProvider<HomeCubit>(create: (_) => homeCubit)],
      child: Scaffold(
        appBar: CustomAppBar(
          isForHomeScreen: true,
          title: '',
          leftButton: IconButton(
            icon: SvgPicture.asset(
              CommonUi.setSvgImage(AssetsPath.homeLeftMainLogo),
              width: 120,
              height: 31,
              fit: BoxFit.cover,
            ),
            onPressed: () {},
          ),
          rightButton: IconButton(
            icon: SvgPicture.asset(
              CommonUi.setSvgImage(AssetsPath.homeRightSetting),
              width: 35,
              height: 31,
              fit: BoxFit.cover,
            ),
            onPressed: () async {
              AppNavigator.push(
                context,
                SettingScreen(),
                disableSwipeBack: true,
              );
            },
          ),
        ),
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(right: 10, bottom: 10),
          child: FloatingActionButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              final token = prefs.getString('UserAccessTokenKey');
              if (token != null && token.isNotEmpty) {
                AnalyticsService.instance.buttonPressed(
                  FirebaseEvents.openAskWilcoChatButton,
                  FirebaseEvents.exploreScreen,
                );
                AppNavigator.push(
                  context,
                  AskWilcoScreen(
                    accessToken: token,
                    isComeFromTab: false,
                    sessionId: '',
                    title: '',
                  ),
                  disableSwipeBack: true,
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Access token not found")),
                );
              }
            },
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: SvgPicture.asset(
              CommonUi.setSvgImage(AssetsPath.homeWilco),
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
          ),
        ),
        body: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return const Scaffold(
                backgroundColor: Colors.white,
                body: Center(child: CircularProgressIndicator()),
              );
            } else if (state is HomeError) {
              return Center(child: Text(state.message));
            } else if (state is HomeLoaded) {
              return Align(
                alignment: Alignment.topCenter,
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1500),
                    child: SingleChildScrollView(
                      controller: scrollController,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: kIsWeb
                                ? screenWidth * 0.01
                                : screenWidth * 0.05,
                          ),
                          SizedBox(
                            width: kIsWeb ? size.width : double.infinity,
                            height: kIsWeb
                                ? screenWidth * 0.09
                                : screenWidth * 0.53,
                            child: SvgPicture.asset(
                              CommonUi.setSvgImage(
                                kIsWeb
                                    ? AssetsPath.WebAppLogo
                                    : AssetsPath.avionicaHome,
                              ),
                              fit: kIsWeb ? BoxFit.contain : BoxFit.fill,
                            ),
                          ),

                          SizedBox(
                            height: kIsWeb
                                ? screenWidth * 0.02
                                : screenWidth * 0.05,
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              children: [
                                // Compare Aircraft
                                CustomHeaderViewExpandable(
                                  isNeedToShowLeftRightBottomBorder: true,
                                  isNeedToShowLeftImage: true,
                                  isLeftImage: IconButton(
                                    icon: SvgPicture.asset(
                                      CommonUi.setSvgImage(
                                        AssetsPath.homeCompareAircraft,
                                      ),
                                      width: 30,
                                      height: 30,
                                      fit: BoxFit.cover,
                                    ),
                                    onPressed: () async {},
                                  ),
                                  title: "Compare Aircraft",
                                  headerColor: AppColors.primaryDark,
                                  arrowBackgroundColor:
                                      AppColors.extraDarkYellow,
                                  arrowFrontColor: Colors.black,
                                  isExpandedViewAvailable: true,
                                  isExpanded: false,
                                  fontStyle: AppTextStyles.regular(16).copyWith(
                                    height: 1.0,
                                    color: AppColors.whiteWithExpandableTitle,
                                  ),
                                  onHeaderTap: () {
                                    AnalyticsService.instance.buttonPressed(
                                      FirebaseEvents.selectModelCompareScreen,
                                      FirebaseEvents.exploreScreen,
                                    );
                                    AppNavigator.push(
                                      context,
                                      SelectModelCompareScreen(),
                                      disableSwipeBack: true,
                                    );
                                  },
                                ),

                                SizedBox(
                                  height: kIsWeb
                                      ? screenWidth * 0.02
                                      : screenWidth * 0.04,
                                ),

                                if (state.manufacturers.isNotEmpty) ...[
                                  CustomHeaderViewExpandable(
                                    isNeedToShowLeftRightBottomBorder: false,
                                    isNeedToShowLeftImage: true,
                                    isExpanded: expandedManufacturerTab,
                                    title: "Manufacturer Library",
                                    headerColor: AppColors.primaryDark,
                                    arrowBackgroundColor:
                                        AppColors.extraDarkYellow,
                                    arrowFrontColor: Colors.black,
                                    isExpandedViewAvailable: true,
                                    fontStyle: AppTextStyles.regular(16)
                                        .copyWith(
                                          height: 1.0,
                                          color: AppColors
                                              .whiteWithExpandableTitle,
                                        ),
                                    isLeftImage: IconButton(
                                      icon: SvgPicture.asset(
                                        CommonUi.setSvgImage(
                                          AssetsPath.homeManufacturerLibrary,
                                        ),
                                        width: 30,
                                        height: 30,
                                        fit: BoxFit.cover,
                                      ),
                                      onPressed: () async {},
                                    ),
                                    onHeaderTap: () {
                                      setState(() {
                                        expandedManufacturerTab =
                                            !expandedManufacturerTab;
                                      });
                                    },
                                    child: _buildManufacturerBody(
                                      state.manufacturers,
                                      screenWidth,
                                    ),
                                  ),
                                ] else
                                  _emptyRow(
                                    'No manufacturers available yet.',
                                    screenWidth,
                                  ),

                                SizedBox(
                                  height: kIsWeb
                                      ? screenWidth * 0.02
                                      : screenWidth * 0.045,
                                ),

                                CustomHeaderViewExpandable(
                                  isNeedToShowLeftRightBottomBorder: false,
                                  isNeedToShowLeftImage: true,
                                  isExpanded: expandFlyingInTheAreaTab,
                                  title: "Flight Tracker",
                                  headerColor: AppColors.primaryDark,
                                  arrowBackgroundColor:
                                      AppColors.extraDarkYellow,
                                  arrowFrontColor: Colors.black,
                                  isExpandedViewAvailable: true,
                                  fontStyle: AppTextStyles.regular(16).copyWith(
                                    height: 1.0,
                                    color: AppColors.whiteWithExpandableTitle,
                                  ),
                                  isLeftImage: IconButton(
                                    icon: SvgPicture.asset(
                                      CommonUi.setSvgImage(
                                        AssetsPath.flyingareaicon,
                                      ),
                                      width: 30,
                                      height: 30,
                                      fit: BoxFit.cover,
                                      color: Colors.white,
                                    ),
                                    onPressed: () async {},
                                  ),
                                  onHeaderTap: () async {
                                    setState(() {
                                      expandFlyingInTheAreaTab =
                                          !expandFlyingInTheAreaTab;
                                    });

                                    if (expandFlyingInTheAreaTab) {
                                      await Future.delayed(
                                        const Duration(milliseconds: 100),
                                      );

                                      if (scrollController.hasClients) {
                                        scrollController.animateTo(
                                          scrollController
                                              .position
                                              .maxScrollExtent,
                                          duration: const Duration(
                                            milliseconds: 500,
                                          ),
                                          curve: Curves.easeInOut,
                                        );
                                      }
                                    }
                                  },
                                  child: _buildFlyingInTheAreaBody(screenWidth),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(
                            height: kIsWeb
                                ? screenWidth * 0.02
                                : screenWidth *
                                      ((expandedManufacturerTab == true &&
                                              expandFlyingInTheAreaTab == true)
                                          ? 0.0
                                          : 0.4),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildManufacturerBody(
    List<ManufacturerListModel> category,
    double screenWidth,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.greyForConversionScreen,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        children: [
          ...List.generate(category.length, (index) {
            final formula = category[index];
            return AppListTileCard(
              title: formula.companyName,
              imagePath: (formula.icon ?? ''),
              onTap: () {
                AnalyticsService.instance.buttonPressed(
                  FirebaseEvents.manufacturerDetailScreen,
                  FirebaseEvents.exploreScreen,
                );
                AppNavigator.push(
                  context,
                  ManufacturerDetailScreen(manufacturerDetailId: formula.id),
                  multiBlocProviders: [
                    BlocProvider(create: (_) => ManufacturerCubit()),
                  ],
                  disableSwipeBack: true,
                );
              },
              isSvg: (formula.icon ?? '').contains(".svg"),
              isNetwork: true,
            );
          }),

          Center(
            child: TextButton(
              onPressed: () {
                AnalyticsService.instance.buttonPressed(
                  FirebaseEvents.manufacturerScreen,
                  FirebaseEvents.exploreScreen,
                );

                AppNavigator.push(
                  context,
                  ManufacturerScreen(),
                  disableSwipeBack: true,
                );
              },
              child: Text(
                'See All',
                style: AppTextStyles.bold(
                  kIsWeb ? screenWidth * 0.02 : 16,
                ).copyWith(height: 1.0, color: AppColors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFlyingInTheAreaBody(double screenWidth) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.04,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: AppColors.greyForConversionScreen,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Choose Your Tracking Mode",
            style: AppTextStyles.bold(
              18,
            ).copyWith(height: 1.0, color: AppColors.black),
          ),

          SizedBox(height: screenWidth * 0.02),

          CustomHeaderViewExpandable(
            isNeedToShowLeftRightBottomBorder: false,
            isNeedToShowLeftImage: true,
            isExpanded: false,
            title: "Flying in the Area",
            headerColor: AppColors.primaryBlue,
            arrowBackgroundColor: AppColors.extraDarkYellow,
            arrowFrontColor: Colors.black,
            isExpandedViewAvailable: true,
            fontStyle: AppTextStyles.regular(
              18,
            ).copyWith(height: 1.4, color: AppColors.white, letterSpacing: 0.2),
            isLeftImage: IconButton(
              icon: SvgPicture.asset(
                CommonUi.setSvgImage(AssetsPath.mapPopupAircraft),
                width: 30,
                height: 30,
                fit: BoxFit.cover,
                color: Colors.white,
              ),
              onPressed: () async {},
            ),
            onHeaderTap: () async {
              final bool success = await CreditManager().tryUseCredit(
                amount: 8,
                isComeFromTabbar: true,
                onError: (String message) async {
                  if (mounted) {
                    Future.microtask(() {
                      AlertHelperForSubsPopup.showSubscriptionEndAlert(
                        context: context,
                        title: "Subscription Required",
                        message: message,
                        navigateTo: const SubscriptionPlanDetailScreen(
                          isComeFromSignup: true,
                        ),
                      );
                    });
                  }
                },
              );

              if (success && mounted) {
                AnalyticsService.instance.buttonPressed(
                  FirebaseEvents.flightMapScreen,
                  FirebaseEvents.exploreScreen,
                );

                AppNavigator.push(
                  context,
                  FlightMapScreen(
                    onGoToFirstTab: () {},
                    skipInitialPopup: true,
                    openMode: 1,
                  ),
                  multiBlocProviders: [
                    BlocProvider(
                      create: (_) {
                        final mapCubit = FlightMapCubit();
                        final firstFlight = mapCubit.state.flights?.first;
                        if (firstFlight != null) {
                          mapCubit.setSelectedFlight(firstFlight);
                          mapCubit.clearSelectedFlightDetail();
                        }
                        return mapCubit;
                      },
                    ),
                  ],
                  disableSwipeBack: true,
                );
              }
            },
          ),

          const SizedBox(height: 6),
          Text(
            "Click to view flights currently flying in this area on the map",
            style: AppTextStyles.regular(
              14,
            ).copyWith(height: 1.4, color: AppColors.textHomeColour),
            textAlign: TextAlign.start,
          ),

          SizedBox(height: kIsWeb ? screenWidth * 0.01 : screenWidth * 0.03),

          CustomHeaderViewExpandable(
            isNeedToShowLeftRightBottomBorder: false,
            isNeedToShowLeftImage: true,
            isExpanded: false,
            title: "Track a Flight",
            headerColor: AppColors.primaryBlue,
            arrowBackgroundColor: AppColors.extraDarkYellow,
            arrowFrontColor: Colors.black,
            isExpandedViewAvailable: true,
            fontStyle: AppTextStyles.regular(
              18,
            ).copyWith(height: 1.4, color: AppColors.white, letterSpacing: 0.2),
            isLeftImage: IconButton(
              icon: SvgPicture.asset(
                CommonUi.setSvgImage(AssetsPath.homeLiveTracking),
                width: 30,
                height: 30,
                fit: BoxFit.cover,
                color: Colors.white,
              ),
              onPressed: () async {},
            ),
            onHeaderTap: () async {
              final bool success = await CreditManager().tryUseCredit(
                amount: 8,
                isComeFromTabbar: true,
                onError: (String message) async {
                  if (mounted) {
                    Future.microtask(() {
                      AlertHelperForSubsPopup.showSubscriptionEndAlert(
                        context: context,
                        title: "Subscription Required",
                        message: message,
                        navigateTo: const SubscriptionPlanDetailScreen(
                          isComeFromSignup: true,
                        ),
                      );
                    });
                  }
                },
              );

              if (success && mounted) {
                AnalyticsService.instance.buttonPressed(
                  FirebaseEvents.flightMapScreen,
                  FirebaseEvents.exploreScreen,
                );

                AppNavigator.push(
                  context,
                  FlightMapScreen(
                    onGoToFirstTab: () {},
                    skipInitialPopup: true,
                    openMode: 2,
                  ),
                  multiBlocProviders: [
                    BlocProvider(
                      create: (_) {
                        final mapCubit = FlightMapCubit();
                        final firstFlight = mapCubit.state.flights?.first;
                        if (firstFlight != null) {
                          mapCubit.setSelectedFlight(firstFlight);
                          mapCubit.clearSelectedFlightDetail();
                        }
                        return mapCubit;
                      },
                    ),
                  ],
                  disableSwipeBack: true,
                );
              }
            },
          ),
          const SizedBox(height: 6),
          Text(
            "View real-time status, route, and updates for a flight",
            style: AppTextStyles.regular(
              14,
            ).copyWith(height: 1.4, color: AppColors.textHomeColour),
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }

  Widget _emptyRow(String message, double screenWidth) => Padding(
    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
    child: Text(
      message,
      style: TextStyle(
        fontSize: kIsWeb ? screenWidth * 0.02 : screenWidth * 0.042,
        color: const Color(0xFF9E9E9E),
      ),
    ),
  );
}
