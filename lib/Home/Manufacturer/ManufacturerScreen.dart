import 'package:avionics_internal/Constants/constantImages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../Helpers/AppText.dart';
import '../../Helpers/CustomDivider.dart';
import '../../Helpers/SearchBarWidget.dart';
import '../../bloc/manufacturer/manufacturer_cubit.dart';
import '../../bloc/manufacturer/manufacturer_state.dart';
import '../HomeScreen.dart';

class ManufacturerScreen extends StatefulWidget {
  @override
  _ManufacturerScreenState createState() => _ManufacturerScreenState();
}

class _ManufacturerScreenState extends State<ManufacturerScreen> {
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ManufacturerCubit>().loadManufacturers();
  }

  @override
  Widget build(BuildContext context) {
    // Responsive units
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    double titleFontSize = screenWidth * 0.05;
    double bodyFontSize = screenWidth * 0.035;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(bottom: screenHeight * 0.02),
          child: Column(
            children: [
              SearchBarWidget(
                controller: searchController,
                onFilterTap: () {},
              ),
              // CustomDivider(),
              SizedBox(height: screenHeight * 0.02),

              // Expanded to allow list rendering
              Expanded(
                child: BlocBuilder<ManufacturerCubit, ManufacturerState>(
                  builder: (context, state) {
                    if (state.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state.manufacturers.isEmpty) {
                      return const Center(child: Text("No manufacturers available."));
                    }

                    return ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                      itemCount: state.manufacturers.length,
                      itemBuilder: (context, index) {
                        final item = state.manufacturers[index];

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (index == 0) ...[
                              Padding(
                                padding: EdgeInsets.only(left: screenWidth * 0.02),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pushReplacement(
                                    context,
                                     MaterialPageRoute(builder: (context) => HomeScreen()), // Navigate to HomeScreen
                                  );
                                },
                                child: AppTexts(
                                  text: "  Manufacturer",
                                  imageName: CommonUi.setSvgImage(AssetsPath.BackIcon),
                                  font: 'Roboto',
                                  side: 'left',
                                  color: Colors.black,
                                  weight: FontWeight.w400,
                                  fontSize: titleFontSize,
                                  imageSize: 18,
                                ),
                              ),
                              ),
                              SizedBox(height: screenHeight * 0.018),
                            ],
                            Card(
                              color: Colors.white,
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.04,
                                  vertical: screenHeight * 0.012,
                                ),
                                leading: SvgPicture.asset(
                                  CommonUi.setSvgImage(item.icon!),
                                  width: screenWidth * 0.1,
                                  height: screenWidth * 0.1,
                                ),
                                title: Text(
                                  item.name,
                                  style: TextStyle(
                                    fontSize: bodyFontSize,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                                onTap: () {
                                  // TODO: Navigate to details screen
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
