import 'package:avionics_internal/Screens/Home/HomeAirbus/AirCraftSection/SelectModelCompareScreen.dart';
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
import '../../bloc/home/homeBloc/home_cubit.dart';
import '../../bloc/home/homeBloc/home_state.dart';
import '../../bloc/home/manufacturer/manufacturer_cubit.dart';
import 'AppBarFilter/FilterScreen.dart';
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
      providers: [
        BlocProvider<HomeCubit>(create: (_) => homeCubit),
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(110),
          // adjust to fit your search bar height
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SearchBarWidget(
                  enableBackArrow: false,
                  enableFilter: true,
                  enableCloseScreen: false,
                  controller: searchController,
                  onFilterTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      backgroundColor: Colors.transparent,
                      builder: (context) {
                        return FractionallySizedBox(
                          heightFactor: 0.9,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                            child: FilterScreen(),
                          ),
                        );
                      },
                    );
                  }, searchTitle: 'Search...',
                ),
                SizedBox(height: screenWidth * 0.04),
              ],
            ),
          ),
        ),

        body: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is HomeError) {
              return Center(child: Text('Error: ${state.message}'));
            } else if (state is HomeLoaded) {
              return SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: screenWidth * 0.03),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.05,
                      ),
                      child: Text(
                        "Welcome Onboard",
                        style: TextStyle(
                          fontSize: screenWidth * 0.04,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),

                    SizedBox(height: screenWidth * 0.05),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(screenWidth * 0.05),
                      color: const Color(0xFF3F3D51),
                      child: SvgPicture.asset(
                        CommonUi.setSvgImage(AssetsPath.avionicaHome),
                        fit: BoxFit.fill,
                      ),
                    ),

                    SizedBox(height: screenWidth * 0.06),

                    /// Model Comparison
                    _buildSectionTitle(
                      "Model Comparison",
                      AssetsPath.comparsion,
                      screenWidth,
                    ),
                    SizedBox(height: screenWidth * 0.035),
                    AppListTileCard(
                      title: "Select model for comparison",
                      imagePath: CommonUi.setSvgImage(AssetsPath.selectModel),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SelectModelCompareScreen(),
                        ),
                      ),
                      isSvg: true,
                    ),
                    SizedBox(height: screenWidth * 0.045),

                    const Divider(
                      height: 0,
                      thickness: 3,
                      color: AppColors.sepratorColourAppBar,
                    ),
                    // Manufacturer
                    SizedBox(height: screenWidth * 0.045),

                    /* ───────────── Manufacturer ───────────── */
                    _buildSectionTitle(
                      'Manufacturer',
                      AssetsPath.manufacturer,
                      screenWidth,
                    ),
                    SizedBox(height: screenWidth * 0.045),
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
                                      )
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
                              fontSize: screenWidth * 0.04,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textColour,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: screenWidth * 0.03),
                    ] else
                      _emptyRow('No manufacturers available yet.', screenWidth),
                    const Divider(
                      height: 0,
                      thickness: 3,
                      color: AppColors.sepratorColourAppBar,
                    ),

                    SizedBox(height: screenWidth * 0.05),

                    /* ────────── Flying in the area ─────────── */
                    _buildSectionTitle(
                      'Flying in the area',
                      AssetsPath.flyingareaicon,
                      screenWidth,
                    ),
                    SizedBox(height: screenWidth * 0.045),

                    if (state.flights.isNotEmpty) ...[
                      ...state.flights
                          .take(2)
                          .map(
                            (f) => AircraftCard.buildAircraftCard(
                              imagePath: (f.image ?? ''),
                              model: f.model,
                              badge: f.code,
                              manufacturer: f.companyName,
                              manufacturerLogoPath: f.logo ?? '',
                              registrationNumber: f.flightId,
                            ),
                          ),

                      Center(
                        child: TextButton(
                          onPressed: () {},
                          child: Text(
                            'See All',
                            style: TextStyle(
                              fontSize: screenWidth * 0.04,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textColour,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: screenWidth * 0.03),
                    ] else
                      _emptyRow('No flights found in this area.', screenWidth),

                    const Divider(
                      height: 0,
                      thickness: 3,
                      color: AppColors.sepratorColourAppBar,
                    ),

                    /* ───────────────── Favourites ──────────── */
                    SizedBox(height: screenWidth * 0.045),

                    _buildSectionTitle(
                      'Favourites',
                      AssetsPath.star,
                      screenWidth,
                    ),
                    SizedBox(height: screenWidth * 0.045),
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
                              builder: (_) => SavedFlighScreen(showTabs: false),
                            ),
                          ),
                          child: Text(
                            'See All',
                            style: TextStyle(
                              fontSize: screenWidth * 0.045,
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
              );
            }
            return const SizedBox();
          },
        ),
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
      ),
    );
  }

  Widget _emptyRow(String message, double screenWidth) => Padding(
    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
    child: Text(
      message,
      style: TextStyle(
        fontSize: screenWidth * 0.042,
        color: const Color(0xFF9E9E9E),
      ),
    ),
  );

  Widget _buildSectionTitle(
    String text,
    String iconPath,
    double screenWidth, {
    double fontSize = 0.045,
    double imageSize = 0.060,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
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
