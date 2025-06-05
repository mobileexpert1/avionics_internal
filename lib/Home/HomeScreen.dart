import 'package:avionics_internal/Home/FilterScreen.dart';
import 'package:avionics_internal/Home/SavedFlights/SavedFlighScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../Constants/constantImages.dart';
import '../Helpers/AircraftCard.dart';
import '../Helpers/AppListTileCard.dart';
import '../Helpers/AppText.dart';
import '../Helpers/CustomDivider.dart';
import '../Helpers/SearchBarWidget.dart';
import '../Onboarding/ChatBotScreen.dart';
import '../bloc/AircraftComparison/AircraftComparisonCubit.dart';
import '../bloc/home/home_cubit.dart';
import '../bloc/home/home_state.dart';
import 'Manufacturer/ManufacturerScreen.dart';
import '../Onboarding/AircraftComparisonScreen.dart';
import '../Onboarding/AirbusScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return _buildHomeContent();
  }

  Widget _buildHomeContent() {
    return BlocProvider(
    create: (_) => AircraftComparisonCubit(allModels: []),
    child: Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            return SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                          builder: (context) {
                            return FractionallySizedBox(
                              heightFactor: 0.9,
                              child: ClipRRect(
                                // <--- Add this!
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(20),
                                ),
                                // <--- Match the radius here
                                child: FilterScreen(),
                              ),
                            );
                          },
                          shape: const RoundedRectangleBorder(
                            // This is still good to have for the modal itself
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          backgroundColor: Colors
                              .transparent, // Sometimes setting this helps for clearer clipping
                        );
                        ;
                      },
                    ),
                    CustomDivider(),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                        "Welcome Onboard",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20),
                      color: Color(0xFF3F3D51),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            CommonUi.setSvgImage(AssetsPath.avionicaHome),
                            fit: BoxFit.fill,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 27),
                    Padding(
                      padding: const EdgeInsets.only(left: 21),
                      child: AppTexts(
                        text: "Model Comparison",
                        imageName: CommonUi.setSvgImage(AssetsPath.comparsion),
                        font: 'Roboto',
                        side: 'left',
                        color: Colors.black,
                        weight: FontWeight.w600,
                        fontSize: 19,
                        imageSize: 25,
                      ),
                    ),
                    SizedBox(height: 18),
                    AppListTileCard(
                      title: "Select model for comparison",
                      imagePath: CommonUi.setSvgImage(AssetsPath.selectModel),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AircraftComparisonScreen(),
                          ),
                        );
                      },
                      isSvg: true,
                    ),
                    SizedBox(height: 25),
                    CustomDivider(),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(left: 21),
                      child: AppTexts(
                        text: "Manufacturer",
                        imageName: CommonUi.setSvgImage(
                          AssetsPath.manufacturer,
                        ),
                        font: 'Roboto',
                        side: 'left',
                        color: Colors.black,
                        weight: FontWeight.w600,
                        fontSize: 19,
                        imageSize: 25,
                      ),
                    ),
                    SizedBox(height: 18),
                    AppListTileCard(
                      title: "Airbus",
                      imagePath: CommonUi.setPngImage(AssetsPath.airbus),
                      onTap: () {
                        Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AirbusScreen()),
                      );},
                      isSvg: false,
                    ),
                    SizedBox(height: 18),
                    AppListTileCard(
                      title: "Aquila Aviation",
                      imagePath: CommonUi.setSvgImage(AssetsPath.manufacturer),
                      onTap: () {},
                      isSvg: true,
                    ),
                    SizedBox(height: 15),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ManufacturerScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          'See All',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF626262),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    CustomDivider(),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(left: 21),
                      child: AppTexts(
                        text: "Flying in the area",
                        imageName: CommonUi.setSvgImage(
                          AssetsPath.manufacturer,
                        ),
                        font: 'Roboto',
                        side: 'left',
                        color: Colors.black,
                        weight: FontWeight.w600,
                        fontSize: 19,
                        imageSize: 25,
                      ),
                    ),
                    SizedBox(height: 18),
                    AircraftCard.buildAircraftCard(
                      imagePath: CommonUi.setPngImage(AssetsPath.aeroplane),
                      model: 'A-320-200',
                      badge: 'A320',
                      manufacturer: 'Airbus',
                      airline: null,
                    ),
                    SizedBox(height: 8),
                    AircraftCard.buildAircraftCard(
                      imagePath: CommonUi.setPngImage(AssetsPath.aeroplane2),
                      model: 'A-319',
                      badge: 'A319',
                      manufacturer: 'Airbus',
                      airline: 'Croatia Airlines',
                      airlineImagePath: CommonUi.setPngImage(
                        AssetsPath.CroatiaAirlineLogo,
                      ),
                    ),
                    SizedBox(height: 8),
                    AircraftCard.buildAircraftCard(
                      imagePath: CommonUi.setPngImage(AssetsPath.aeroplane3),
                      model: 'A-319',
                      badge: 'A319',
                      manufacturer: 'Airbus',
                      airline: 'Air France',
                      airlineImagePath: CommonUi.setPngImage(
                        AssetsPath.AirFranceLogo,
                      ),
                    ),
                    SizedBox(height: 8),
                    Center(
                      child: TextButton(
                        onPressed: () {},
                        child: const Text(
                          'See All',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF626262),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    CustomDivider(),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(left: 21),
                      child: AppTexts(
                        text: "Favourites",
                        imageName: CommonUi.setSvgImage(AssetsPath.star),
                        font: 'Roboto',
                        side: 'left',
                        color: Colors.black,
                        weight: FontWeight.w600,
                        fontSize: 22,
                        imageSize: 35,
                      ),
                    ),
                    SizedBox(height: 18),
                    AppListTileCard(
                      title: "Airbus",
                      imagePath: CommonUi.setSvgImage(AssetsPath.manufacturer),
                      onTap: () {},
                      isSvg: true,
                    ),
                    SizedBox(height: 18),
                    AppListTileCard(
                      title: "A-319B",
                      imagePath: CommonUi.setSvgImage(AssetsPath.aeroplaneIcon),
                      onTap: () {},
                      isSvg: true,
                    ),
                    SizedBox(height: 8),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  SavedFlighScreen(showTabs: false),
                            ),
                          );
                        },
                        child: const Text(
                          'See All',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF626262),
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
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 7),
        child: SizedBox(
          width: 70,
          height: 70,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AskWilcoScreen()),
              );
            },
            backgroundColor: Colors.transparent,
            elevation: 0, // optional: remove shadow
            child: SvgPicture.asset(
              CommonUi.setSvgImage(AssetsPath.Chatbot),
              width: 70,
              height: 70,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    ),
);
  }
}
