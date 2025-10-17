import 'package:avionics_internal/Screens/Home/HomeAirbus/AirCraftSection/SelectModelCompareScreen.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Constants/AppColors.dart';
import '../../Constants/constantImages.dart';
import '../../Helpers/AircraftCard.dart';
import '../../Helpers/AppListTileCard.dart';
import '../../Helpers/AppText.dart';
import '../../Helpers/SearchBarWidget.dart';
import '../../bloc/MapSection/flight_Map_Cubit.dart';
import '../../bloc/home/homeBloc/home_cubit.dart';
import '../../bloc/home/homeBloc/home_state.dart';
import '../../bloc/home/manufacturer/manufacturer_cubit.dart';
import '../MapSection/FlightMapScreen.dart';
import '../MapSection/MapHelpers/MapTrackingModePopup.dart';
import '../MapSection/MapHelpers/TrackAndSeacrhFlight.dart';
import 'AppBarFilterAndMapFilter/FilterScreen.dart';
import 'HomeAirbus/AllPlaneListAndDetails/AllPlaneListScreen.dart';
import 'HomeAirbus/ChatSection/ChatBotScreen.dart';
import 'Manufacturer/ManufacturerListScreen.dart';
import 'Manufacturer/ManufacturerDetailScreen.dart';
import 'SavedFlights/SavedFlighScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController = TextEditingController();
  late HomeCubit homeCubit;

  @override
  void initState() {
    super.initState();
    homeCubit = HomeCubit();
    homeCubit.fetchHomeData(context);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;

    return MultiBlocProvider(
      providers: [BlocProvider<HomeCubit>(create: (_) => homeCubit)],
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(right: 10, bottom: 10),
          child: FloatingActionButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              final token = prefs.getString('UserAccessTokenKey');

              if (token != null && token.isNotEmpty) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AskWilcoScreen(
                      accessToken: token,
                      isComeFromTab: false,
                      sessionId: '',
                      title: '',
                    ),
                  ),
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
              CommonUi.setSvgImage(AssetsPath.Chatbot),
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
          ),
        ),

        //
        // appBar: PreferredSize(
        //   preferredSize: Size.fromHeight(kIsWeb ? 120 : 110),
        //   child: SafeArea(
        //     child: Column(
        //       mainAxisSize: MainAxisSize.min,
        //       children: [
        //         // SearchBarWidget(
        //         //   enableBackArrow: false,
        //         //   enableFilter: true,
        //         //   enableCloseScreen: false,
        //         //   controller: searchController,
        //         //   onFilterTap: () {
        //         //     showModalBottomSheet(
        //         //       context: context,
        //         //       isScrollControlled: true,
        //         //       shape: const RoundedRectangleBorder(
        //         //         borderRadius: BorderRadius.vertical(
        //         //           top: Radius.circular(20),
        //         //         ),
        //         //       ),
        //         //       backgroundColor: Colors.transparent,
        //         //       builder: (context) => FractionallySizedBox(
        //         //         heightFactor: 0.9,
        //         //         child: ClipRRect(
        //         //           borderRadius: const BorderRadius.vertical(
        //         //             top: Radius.circular(20),
        //         //           ),
        //         //           child: FilterScreen(),
        //         //         ),
        //         //       ),
        //         //     );
        //         //   },
        //         //   searchTitle: 'Search...',
        //         // ),
        //         //
        //       ],
        //     ),
        //   ),
        // ),
        body: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is HomeError) {
              return Center(child: Text('Error: ${state.message}'));
            } else if (state is HomeLoaded) {
              return Align(
                alignment: Alignment.topCenter,
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1500),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: kIsWeb ? 30 : 60),
                          //SizedBox(height: screenWidth * 0.03),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: kIsWeb
                                  ? screenWidth * 0.01
                                  : screenWidth * 0.05,
                            ),
                            child: Text(
                              "Welcome Onboard",
                              style: TextStyle(
                                fontSize: kIsWeb
                                    ? screenWidth * 0.02
                                    : screenWidth * 0.04,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ),

                          SizedBox(
                            height: kIsWeb
                                ? screenWidth * 0.01
                                : screenWidth * 0.05,
                          ),
                          Container(
                            width: kIsWeb ? size.width : double.infinity,
                            height: kIsWeb
                                ? screenWidth * 0.09
                                : screenWidth * 0.50,
                            color: const Color(0xFF3F3D51),
                            child: SvgPicture.asset(
                              CommonUi.setSvgImage(
                                kIsWeb
                                    ? AssetsPath.WebAppLogo
                                    : AssetsPath.avionicaHome,
                              ),
                              fit: kIsWeb ? BoxFit.contain : BoxFit.cover,
                            ),
                          ),

                          SizedBox(
                            height: kIsWeb
                                ? screenWidth * 0.02
                                : screenWidth * 0.06,
                          ),

                          /// Model Comparison
                          _buildSectionTitle(
                            "Model Comparison",
                            AssetsPath.comparsion,
                            screenWidth,
                          ),
                          SizedBox(
                            height: kIsWeb
                                ? screenWidth * 0.02
                                : screenWidth * 0.035,
                          ),
                          AppListTileCard(
                            title: "Select model for comparison",
                            imagePath: CommonUi.setSvgImage(
                              AssetsPath.selectModel,
                            ),
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => SelectModelCompareScreen(),
                              ),
                            ),
                            isSvg: true,
                          ),

                          SizedBox(
                            height: kIsWeb
                                ? screenWidth * 0.02
                                : screenWidth * 0.045,
                          ),
                          const Divider(
                            height: 0,
                            thickness: 3,
                            color: AppColors.sepratorColourAppBar,
                          ),

                          SizedBox(
                            height: kIsWeb
                                ? screenWidth * 0.02
                                : screenWidth * 0.045,
                          ),

                          /// Manufacturer Section
                          _buildSectionTitle(
                            'Manufacturer',
                            AssetsPath.manufacturer,
                            screenWidth,
                          ),
                          SizedBox(
                            height: kIsWeb
                                ? screenWidth * 0.02
                                : screenWidth * 0.045,
                          ),
                          if (state.manufacturers.isNotEmpty) ...[
                            ...state.manufacturers
                                .take(2)
                                .map(
                                  (m) => AppListTileCard(
                                    title: m.companyName,
                                    imagePath: (m.icon ?? ''),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => BlocProvider(
                                            create: (_) => ManufacturerCubit(),
                                            child: ManufacturerDetailScreen(
                                              manufacturerDetailId: m.id,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    isSvg: (m.icon ?? '').contains(".svg"),
                                    isNetwork: true,
                                  ),
                                ),
                            Center(
                              child: TextButton(
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => BlocProvider(
                                      create: (_) => ManufacturerCubit(),
                                      child: ManufacturerScreen(),
                                    ),
                                  ),
                                ),
                                child: Text(
                                  'See All',
                                  style: TextStyle(
                                    fontSize: kIsWeb
                                        ? screenWidth * 0.02
                                        : screenWidth * 0.04,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textColour,
                                  ),
                                ),
                              ),
                            ),
                          ] else
                            _emptyRow(
                              'No manufacturers available yet.',
                              screenWidth,
                            ),

                          const Divider(
                            height: 0,
                            thickness: 3,
                            color: AppColors.sepratorColourAppBar,
                          ),

                          SizedBox(
                            height: kIsWeb
                                ? screenWidth * 0.02
                                : screenWidth * 0.045,
                          ),

                          /// Flying in the area
                          _buildSectionTitle(
                            'Flying in the area',
                            AssetsPath.flyingareaicon,
                            screenWidth,
                          ),

                          const SizedBox(height: 12),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 25,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Flying in the Area Button
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => BlocProvider(
                                          create: (_) {
                                            final mapCubit = FlightMapCubit();
                                            final firstFlight =
                                                mapCubit.state.flights?.first;
                                            if (firstFlight != null) {
                                              mapCubit.setSelectedFlight(
                                                firstFlight,
                                              );
                                              mapCubit
                                                  .clearSelectedFlightDetail();
                                            }
                                            return mapCubit;
                                          },
                                          child: FlightMapScreen(
                                            onGoToFirstTab: () {},
                                            skipInitialPopup: true,
                                            openMode: 1,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: AppColors.facebookButton,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                          CommonUi.setSvgImage(
                                            AssetsPath.mapPopupAircraft,
                                          ),
                                          height: 32,
                                          width: 32,
                                          fit: BoxFit.contain,
                                        ),
                                        const SizedBox(width: 12),
                                        const Expanded(
                                          child: Text(
                                            "Flying in the Area",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                        const Icon(
                                          Icons.arrow_forward_ios,
                                          size: 16,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 6),
                                const Text(
                                  "Click to view flights currently flying in this area on the map",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13,
                                  ),
                                  textAlign: TextAlign.start,
                                ),

                                const SizedBox(height: 16),
                                // Track a Flight Button
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => BlocProvider(
                                          create: (_) {
                                            final mapCubit = FlightMapCubit();
                                            final flightToTrack =
                                                mapCubit.state.flights?.first;
                                            if (flightToTrack != null) {
                                              mapCubit.startTrackingFlight(
                                                flightToTrack.id,
                                                context,
                                              );
                                            }
                                            return mapCubit;
                                          },
                                          child: FlightMapScreen(
                                            onGoToFirstTab: () {},
                                            skipInitialPopup: true,
                                            openMode: 2,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color:
                                          AppColors.customBottomEnabledColour,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                          CommonUi.setSvgImage(
                                            AssetsPath.mapPopupLivearea,
                                          ),
                                          height: 25,
                                          width: 25,
                                          fit: BoxFit.fitWidth,
                                        ),
                                        const SizedBox(width: 12),
                                        const Expanded(
                                          child: Text(
                                            "Track a Flight",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                        const Icon(
                                          Icons.arrow_forward_ios,
                                          size: 16,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 6),
                                const Text(
                                  "View real-time status, route, and updates for a flight.",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            height: kIsWeb
                                ? screenWidth * 0.02
                                : screenWidth * 0.045,
                          ),

                          // if (state.flights.isNotEmpty) ...[
                          //   ...state.flights
                          //       .take(2)
                          //       .map(
                          //         (f) => AircraftCard.buildAircraftCard(
                          //           imagePath: (f.image ?? ''),
                          //           model: f.model,
                          //           badge: f.code,
                          //           manufacturer: f.companyName,
                          //           manufacturerLogoPath: f.logo ?? '',
                          //           registrationNumber: f.flightId,
                          //         ),
                          //       ),
                          //   Center(
                          //     child: TextButton(
                          //       onPressed: () {},
                          //       child: Text(
                          //         'See All',
                          //         style: TextStyle(
                          //           fontSize: kIsWeb
                          //               ? screenWidth * 0.02
                          //               : screenWidth * 0.04,
                          //           fontWeight: FontWeight.w600,
                          //           color: AppColors.textColour,
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          // ] else
                          //   _emptyRow(
                          //     'No flights found in this area.',
                          //     screenWidth,
                          //   ),

                          const Divider(
                            height: 0,
                            thickness: 3,
                            color: AppColors.sepratorColourAppBar,
                          ),

                          SizedBox(
                            height: kIsWeb
                                ? screenWidth * 0.02
                                : screenWidth * 0.045,
                          ),

                          /// Favourites
                          _buildSectionTitle(
                            'Favourites',
                            AssetsPath.star,
                            screenWidth,
                          ),
                          SizedBox(
                            height: kIsWeb
                                ? screenWidth * 0.02
                                : screenWidth * 0.045,
                          ),
                          if (state.favourites.isNotEmpty) ...[
                            ...state.favourites
                                .take(2)
                                .map(
                                  (f) => AppListTileCard(
                                    title: f.aircraftModel,
                                    imagePath: (f.image),
                                    onTap: () {},
                                    isSvg: (f.image).contains(".svg"),
                                    isNetwork: true,
                                  ),
                                ),
                            Center(
                              child: TextButton(
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        SavedFlighScreen(showTabs: false),
                                  ),
                                ),
                                child: Text(
                                  'See All',
                                  style: TextStyle(
                                    fontSize: kIsWeb
                                        ? screenWidth * 0.02
                                        : screenWidth * 0.04,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF626262),
                                  ),
                                ),
                              ),
                            ),
                          ] else
                            _emptyRow('No favourites saved yet.', screenWidth),
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

  Widget _buildSectionTitle(
    String text,
    String iconPath,
    double screenWidth, {
    double fontSize = (kIsWeb ? 0.02 : 0.045),
    double imageSize = (kIsWeb ? 0.02 : 0.060),
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: kIsWeb ? screenWidth * 0.00 : screenWidth * 0.05,
      ),
      child: AppTexts(
        text: text,
        imageName: CommonUi.setSvgImage(iconPath),
        font: 'Roboto',
        side: 'left',
        color: Colors.black,
        weight: FontWeight.w500,
        fontSize: screenWidth * fontSize,
        imageSize: screenWidth * imageSize,
      ),
    );
  }
}
