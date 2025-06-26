import 'package:avionics_internal/Constants/AppColors.dart';
import 'package:avionics_internal/Constants/constantImages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../Helpers/CustomDivider.dart';
import '../../Helpers/Custom_widget.dart';
import 'AllPlanesScreen.dart';

class AirbusScreen extends StatefulWidget {
  const AirbusScreen({super.key});

  @override
  State<AirbusScreen> createState() => _AirbusScreenState();
}

class _AirbusScreenState extends State<AirbusScreen> {
  bool showMoreGeneralInfo = true;
  bool showMoreAboutInfo = false;
  bool showMoreHistory = false;
  bool showMoreProducts = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              children: [
                Image.asset(
                  CommonUi.setPngImage(AssetsPath.AirbusPageImage),
                  width: double.infinity,
                  height: screenHeight * 0.26,
                  fit: BoxFit.cover,
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Image and Circle Image With Name And Description.
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      // Remove horizontal padding if needed
                      child: Container(
                        width: double.infinity, // Full screen width
                        color: Colors.grey.shade100, // Background color
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 8,
                        ), // Internal padding
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 45),
                            Text(
                              "Airbus",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "European aircraft manufacturer",
                              style: TextStyle(fontSize: 14),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // All List Of Airplane
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AllPlanesScreen(),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 25,
                          vertical: 5,
                        ),

                        child: Row(
                          children: [
                            SvgPicture.asset(
                              CommonUi.setSvgImage(AssetsPath.Plane1),
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Text(
                                "List of All Planes",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            const Icon(Icons.chevron_right),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    const Divider(
                      height: 0,
                      thickness: 3,
                      color: AppColors.sepratorColourAppBar,
                    ),

                    _buildSectionHeader(
                      title: "GENERAL INFORMATION",
                      isExpanded: showMoreGeneralInfo,
                      onTap: () => setState(
                        () => showMoreGeneralInfo = !showMoreGeneralInfo,
                      ),
                    ),

                    showMoreGeneralInfo
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: _buildGeneralInfo(),
                          )
                        : const SizedBox.shrink(),

                    Divider(
                      height: 0,
                      color: AppColors.sepratorColourAppBar,
                      thickness: 3,
                    ),

                    _buildSectionHeader(
                      title: "ABOUT THE COMPANY",
                      isExpanded: showMoreAboutInfo,
                      onTap: () => setState(
                        () => showMoreAboutInfo = !showMoreAboutInfo,
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Airbus SE is a multinational aerospace corporation. Airbus designs, manufactures and sells civil and military aerospace products worldwide. "
                            "The company is a leading aircraft manufacturer and operates globally with major facilities in Europe and production lines in Asia and North America.",
                            style: const TextStyle(height: 1.5),
                            maxLines: showMoreAboutInfo ? null : 2,
                            // null = show full text
                            overflow: showMoreAboutInfo
                                ? TextOverflow.visible
                                : TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 15),
                        ],
                      ),
                    ),

                    Divider(
                      height: 0,
                      color: AppColors.sepratorColourAppBar,
                      thickness: 3,
                    ),

                    _buildSectionHeader(
                      title: "HISTORY",
                      isExpanded: showMoreHistory,
                      onTap: () =>
                          setState(() => showMoreHistory = !showMoreHistory),
                    ),

                    // Text Section (always shown with toggle logic)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "The current company is the product of consolidation in the European aerospace industry tracing back to 1970. Airbus was formally established as a European consortium of French, German, Spanish and UK aerospace companies to compete with American manufacturers. Over the years, it has grown through mergers and joint ventures...",
                            style: const TextStyle(height: 1.5),
                            maxLines: showMoreHistory ? null : 2,
                            overflow: showMoreHistory
                                ? TextOverflow.visible
                                : TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),

                    // Image Scroller (only shown when expanded)
                    _buildImageScroller(),

                    Divider(
                      height: 0,
                      color: AppColors.sepratorColourAppBar,
                      thickness: 3,
                    ),

                    _buildSectionHeader(
                      title: "PRODUCTS",
                      isExpanded: showMoreProducts,
                      onTap: () =>
                          setState(() => showMoreProducts = !showMoreProducts),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Civilian",
                            style: TextStyle(fontSize: 15),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "The Airbus product line started with the A300 in 1972, the world's first twin-aisle, twin-engined aircraft. A shorter, re-winged, re-engined variant of the A300 is the A310. The family evolved into the A320, A330, A340, and the iconic double-decker A380.",
                            style: const TextStyle(height: 1.5),
                            maxLines: showMoreProducts ? null : 2,
                            overflow: showMoreProducts ? TextOverflow.visible : TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            "Military",
                            style: TextStyle(fontSize: 15),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "In the late 1990s, Airbus became increasingly interested in developing and selling to the military aviation market. It embarked on two main fields of development: aerial refueling tankers such as the A330 MRTT, and tactical airlifters such as the A400M Atlas.",
                            style: const TextStyle(height: 1.5),
                            maxLines: showMoreProducts ? null : 2,
                            overflow: showMoreProducts ? TextOverflow.visible : TextOverflow.ellipsis,
                          ),

                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 50),
              ],
            ),
            Positioned(
              top: screenHeight * 0.06,
              left: screenWidth * 0.05,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                ),
              ),
            ),
            Positioned(
              top: screenHeight * 0.21,
              left: screenWidth * 0.06,
              child: ClipOval(
                child: Image.asset(
                  CommonUi.setPngImage(AssetsPath.manufacturerLogo),
                  width: screenWidth * 0.22,
                  height: screenWidth * 0.22,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGeneralInfo() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: customField(
                label: 'Headquarters',
                text: 'Leiden, Netherlands',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: customField(label: 'CEO', text: 'Guillaume Faury'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: customField(label: 'Founding Date', text: '1970'),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: customField(
                label: 'Last year revenue',
                text: '52.15 bil EUR',
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _infoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.only(bottom: 4),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Color(0xFFE0E0E0), width: 1),
            ),
          ),
          child: Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Color(0xFF2D2C42),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required bool isExpanded,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 15),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: GestureDetector(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(child: Text(title)),
                  Row(
                    children: [
                      Text(
                        isExpanded ? "Show Less" : "Show More",
                        style: const TextStyle(fontSize: 13),
                      ),
                      Icon(
                        isExpanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),

        Divider(
          height: 0,
          color: AppColors.sepratorColourAppBar,
          thickness: 2,
          indent: 20,
          endIndent: 20,
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildImageScroller() {
    return Padding(
      padding: const EdgeInsets.only(top: 15, left: 25, right: 25),
      child: SizedBox(
        height: 120,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 3,
          itemBuilder: (context, index) => Container(
            margin: EdgeInsets.only(right: index == 2 ? 0 : 10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                CommonUi.setPngImage(AssetsPath.HistoryImg),
                width: 300,
                height: 120,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
