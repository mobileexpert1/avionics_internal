import 'package:avionics_internal/Home/AppBarFilter/FilterScreen.dart';
import 'package:avionics_internal/Home/SavedFlights/SavedFlighScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../Constants/constantImages.dart';
import '../Helpers/AircraftCard.dart';
import '../Helpers/AppListTileCard.dart';
import '../Helpers/AppText.dart';
import '../Helpers/CustomDivider.dart';
import '../Helpers/SearchBarWidget.dart';
import 'HomeAirbus/ChatBotScreen.dart';
import '../bloc/AircraftComparison/AircraftComparisonCubit.dart';
import '../bloc/home/home_cubit.dart';
import '../bloc/home/home_state.dart';
import 'Manufacturer/ManufacturerScreen.dart';
import 'HomeAirbus/AircraftComparisonScreen.dart';
import 'HomeAirbus/AirbusScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;

    return BlocProvider(
      create: (_) => AircraftComparisonCubit(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight + 50),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: SearchBarWidget(
                    enableBackArrow: false,
                    enableFilter: true,
                    enableCloseScreen: false,
                    controller: searchController,
                    onFilterTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        backgroundColor: Colors.transparent,
                        builder: (context) {
                          return FractionallySizedBox(
                            heightFactor: 0.9,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                              child: FilterScreen(),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                SizedBox(height: screenWidth * 0.04),
                const Divider(
                  height: 1.5,
                  thickness: 1.5,
                  color: Color(0xFFDDDDDD),
                ),
              ],
            ),
          ),
        ),

        body: SafeArea(
          child: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              return SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: screenWidth * 0.05),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                      child: Text(
                        "Welcome Onboard",
                        style: TextStyle(
                          fontSize: screenWidth * 0.05,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),

                    SizedBox(height: screenWidth * 0.04),

                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(screenWidth * 0.05),
                      color: const Color(0xFF3F3D51),
                      child: SvgPicture.asset(
                        CommonUi.setSvgImage(AssetsPath.avionicaHome),
                        fit: BoxFit.fill,
                      ),
                    ),

                    SizedBox(height: screenWidth * 0.07),
                    _buildSectionTitle("Model Comparison", AssetsPath.comparsion, screenWidth),

                    SizedBox(height: screenWidth * 0.045),

                    AppListTileCard(
                      title: "Select model for comparison",
                      imagePath: CommonUi.setSvgImage(AssetsPath.selectModel),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => AircraftComparisonScreen()),
                      ),
                      isSvg: true,
                    ),

                    SizedBox(height: screenWidth * 0.06),
                    CustomDivider(),
                    SizedBox(height: screenWidth * 0.05),

                    _buildSectionTitle("Manufacturer", AssetsPath.manufacturer, screenWidth),
                    SizedBox(height: screenWidth * 0.045),

                    AppListTileCard(
                      title: "Airbus",
                      imagePath: CommonUi.setPngImage(AssetsPath.airbus),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => AirbusScreen()),
                      ),
                      isSvg: false,
                    ),

                    SizedBox(height: screenWidth * 0.045),

                    AppListTileCard(
                      title: "Aquila Aviation",
                      imagePath: CommonUi.setSvgImage(AssetsPath.manufacturer),
                      onTap: () {},
                      isSvg: true,
                    ),

                    SizedBox(height: screenWidth * 0.02),

                    Center(
                      child: TextButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => ManufacturerScreen()),
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

                    SizedBox(height: screenWidth * 0.025),
                    CustomDivider(),
                    SizedBox(height: screenWidth * 0.05),

                    _buildSectionTitle("Flying in the area", AssetsPath.flyingareaicon, screenWidth),
                    SizedBox(height: screenWidth * 0.045),

                    AircraftCard.buildAircraftCard(
                      imagePath: CommonUi.setPngImage(AssetsPath.aeroplane),
                      model: 'A-320-200',
                      badge: 'A320',
                      manufacturer: 'Airbus',
                      registrationNumber:'A35819',
                    ),

                    SizedBox(height: screenWidth * 0.02),

                    AircraftCard.buildAircraftCard(
                      imagePath: CommonUi.setPngImage(AssetsPath.aeroplane2),
                      model: 'A-319',
                      badge: 'A319',
                      manufacturer: 'Airbus',
                      registrationNumber: 'A35819',
                    ),

                    SizedBox(height: screenWidth * 0.02),

                    AircraftCard.buildAircraftCard(
                      imagePath: CommonUi.setPngImage(AssetsPath.aeroplane3),
                      model: 'A-319',
                      badge: 'A319',
                      manufacturer: 'Airbus',
                      registrationNumber:'A35819',
                    ),

                    SizedBox(height: screenWidth * 0.02),

                    Center(
                      child: TextButton(
                        onPressed: () {},
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

                    SizedBox(height: screenWidth * 0.025),
                    CustomDivider(),
                    SizedBox(height: screenWidth * 0.05),

                    _buildSectionTitle("Favourites", AssetsPath.star,
                        screenWidth, fontSize: 0.055, imageSize: 0.09),

                    SizedBox(height: screenWidth * 0.045),

                    AppListTileCard(
                      title: "Airbus",
                      imagePath: CommonUi.setSvgImage(AssetsPath.manufacturer),
                      onTap: () {},
                      isSvg: true,
                    ),

                    SizedBox(height: screenWidth * 0.045),

                    AppListTileCard(
                      title: "A-319B",
                      imagePath: CommonUi.setSvgImage(AssetsPath.aeroplaneIcon),
                      onTap: () {},
                      isSvg: true,
                    ),

                    SizedBox(height: screenWidth * 0.02),

                    Center(
                      child: TextButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => SavedFlighScreen(showTabs: false)),
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
                  ],
                ),
              );
            },
          ),
        ),
        floatingActionButton: Padding(
          padding: EdgeInsets.only(right: 7),
          child: SizedBox(
            width: 70,
            height: 70,
            child: FloatingActionButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AskWilcoScreen()),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
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

  Widget _buildSectionTitle(String text, String iconPath, double screenWidth,
      {double fontSize = 0.048, double imageSize = 0.065}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
      child: AppTexts(
        text: text,
        imageName: CommonUi.setSvgImage(iconPath),
        font: 'Roboto',
        side: 'left',
        color: Colors.black,
        weight: FontWeight.w600,
        fontSize: screenWidth * fontSize,
        imageSize: screenWidth * imageSize,
      ),
    );
  }

}
