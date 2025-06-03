import 'package:avionics_internal/Helpers/AppText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Helpers/AppListTileCard.dart';
import '../bloc/home/home_cubit.dart';
import '../bloc/home/home_state.dart';
import '../Constants/constantImages.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25,vertical: 25),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: searchController,
                          decoration: InputDecoration(
                            hintText: "Try 'Airbus 320'",
                            prefixIcon: SvgPicture.asset(
                              CommonUi.setSvgImage(AssetsPath.search),
                              fit: BoxFit.fill,
                            ),
                            contentPadding: EdgeInsets.symmetric(vertical: 13),
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      SvgPicture.asset(
                        CommonUi.setSvgImage(AssetsPath.sliders),
                        fit: BoxFit.fill,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                // Welcome Text
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

                // Logo Section
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
                  svgPath: CommonUi.setSvgImage(AssetsPath.selectModel),
                  onTap: () {
                  },
                ),

                SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.only(left: 21),
                  child: AppTexts(
                    text: "Manufacturer",
                    imageName: CommonUi.setSvgImage(AssetsPath.manufacture),
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
                  svgPath: CommonUi.setSvgImage(AssetsPath.selectModel),
                  onTap: () {
                  },
                ),
                SizedBox(height: 18),
                AppListTileCard(
                  title: "Aquila Aviation",
                  svgPath: CommonUi.setSvgImage(AssetsPath.manufacture),
                  onTap: () {
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
