import 'package:avionics_internal/Constants/constantImages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../../Constants/ConstantStrings.dart';
import '../../../Helpers/AppText.dart';
import '../../../Helpers/SearchBarWidget.dart';
import '../../../bloc/manufacturer/manufacturer_cubit.dart';
import '../../../bloc/manufacturer/manufacturer_state.dart';
import '../HomeScreen.dart';
import 'ManufacturerDetailScreen.dart';


class ManufacturerScreen extends StatefulWidget {
  @override
  _ManufacturerScreenState createState() => _ManufacturerScreenState();
}

class _ManufacturerScreenState extends State<ManufacturerScreen> {
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ManufacturerCubit>().loadListOfManufacturers(context: context);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    double titleFontSize = screenWidth * 0.05;
    double bodyFontSize = screenWidth * 0.035;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: screenHeight * 0.03),
              child: SearchBarWidget(
                enableBackArrow: false,
                enableFilter: true,
                enableCloseScreen: true,
                controller: searchController,
                onFilterTap: () {},
                onChanged: (value) {
                  context.read<ManufacturerCubit>().loadListOfManufacturers(
                    context: context,
                    query: value.trim(),
                  );
                },
              ),
            ),

            SizedBox(height: screenHeight * 0.02),

            Padding(
              padding: EdgeInsets.only(left: screenWidth * 0.06),
              child: Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: AppTexts(
                    text: "  Manufacturer",
                    imageName: CommonUi.setSvgImage(AssetsPath.BackIcon),
                    font: 'Roboto',
                    side: 'left',
                    color: Colors.black,
                    weight: FontWeight.w400,
                    fontSize: titleFontSize,
                    imageSize: 15,
                  ),
                ),
              ),
            ),

            SizedBox(height: screenHeight * 0.02),

            /// Expanded scrollable list
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                child: BlocBuilder<ManufacturerCubit, ManufacturerState>(
                  builder: (context, state) {
                    if (state.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state.manufacturers.isEmpty) {
                      return const Center(
                        child: Text("No manufacturers available."),
                      );
                    }

                    return ListView.builder(
                      itemCount: state.manufacturers.length,
                      itemBuilder: (context, index) {
                        final item = state.manufacturers[index];

                        return Card(
                          color: Colors.white,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.05,
                              vertical: screenHeight * 0.006,
                            ),
                            leading: item.icon != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: Image.network(
                                      item.icon!,
                                      width: screenWidth * 0.1,
                                      height: screenWidth * 0.1,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Icon(Icons.broken_image),
                                    ),
                                  )
                                : const Icon(Icons.image_not_supported),
                            title: Text(
                              item.companyName,
                              style: TextStyle(
                                fontSize: bodyFontSize,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ManufacturerDetailScreen(manufacturerDetailId: item.id),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
