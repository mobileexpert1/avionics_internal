import 'package:avionics_internal/Constants/constantImages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../Helpers/CustomDivider.dart';
import '../Helpers/Custom_widget.dart';
import 'AllPlanesScreen.dart';

class AirbusScreen extends StatefulWidget {
  const AirbusScreen({super.key});

  @override
  State<AirbusScreen> createState() => _AirbusScreenState();
}

class _AirbusScreenState extends State<AirbusScreen> {
  bool showMoreGeneralInfo = false;
  bool showMoreAboutInfo = false;
  bool showMoreHistory = false;
  bool showMoreProducts = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Stack(
              children: [
                Column(
                  children: [
                    Image.asset(
                      CommonUi.setPngImage(AssetsPath.AirbusPageImage),
                      width: double.infinity,
                      height: screenHeight * 0.3,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(height: 50,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         Padding(
                           padding: const EdgeInsets.symmetric(horizontal: 20),
                           child: Text("Airbus", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                         ),
                        const SizedBox(height: 4),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text("European aircraft manufacturer", style: TextStyle(fontSize: 16)),
                        ),
                        const SizedBox(height: 24),

                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const AllPlanesScreen()));
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 3, offset: Offset(0, 1))],
                              color: Colors.white,
                            ),
                            child: Row(
                              children: [
                                SvgPicture.asset(CommonUi.setSvgImage(AssetsPath.Plane1), width: screenWidth * 0.08),
                                const SizedBox(width: 12),
                                const Expanded(
                                  child: Text("List of All Planes", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                ),
                                const Icon(Icons.chevron_right),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: _buildSectionHeader(
                            title: "GENERAL INFORMATION",
                            isExpanded: showMoreGeneralInfo,
                            onTap: () => setState(() => showMoreGeneralInfo = !showMoreGeneralInfo),
                          ),
                        ),
                        Divider(
                          height: 0,
                          color: Colors.grey,
                          thickness: 2,
                          indent : 20,
                          endIndent : 20,
                        ),
                        const SizedBox(height: 8),
                        showMoreGeneralInfo ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: _buildGeneralInfo(screenWidth),
                        ) : const SizedBox.shrink(),

                        const SizedBox(height: 8),

                        const CustomDivider(),

                        const SizedBox(height: 10),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: _buildSectionHeader(
                            title: "ABOUT THE COMPANY",
                            isExpanded: showMoreAboutInfo,
                            onTap: () => setState(() => showMoreAboutInfo = !showMoreAboutInfo),
                          ),
                        ),
                        Divider(
                          height: 0,
                          color: Colors.grey,
                          thickness: 2,
                          indent : 20,
                          endIndent : 20,
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            showMoreAboutInfo
                                ? "Airbus SE is a multinational aerospace corporation. Airbus designs, manufactures and sells civil and military aerospace products worldwide. "
                                "The company is a leading aircraft manufacturer and operates globally with major facilities in Europe and production lines in Asia and North America."
                                : "Airbus SE is a multinational aerospace corporation. Airbus designs, manufactures and sells civil and military aerospace products worldwide...",
                            style: const TextStyle(height: 1.5),
                          ),
                        ),
                        const CustomDivider(),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: _buildSectionHeader(
                            title: "HISTORY",
                            isExpanded: showMoreHistory,
                            onTap: () => setState(() => showMoreHistory = !showMoreHistory),
                          ),
                        ),
                        Divider(
                          height: 0,
                          color: Colors.grey,
                          thickness: 2,
                          indent : 20,
                          endIndent : 20,
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            showMoreHistory
                                ? "The current company is the product of consolidation in the European aerospace industry tracing back to 1970. Airbus was formally established as a European consortium of French, German, Spanish and UK aerospace companies to compete with American manufacturers. Over the years, it has grown through mergers and joint ventures..."
                                : "The current company is the product of consolidation in the European aerospace industry tracing back to 1970...",
                            style: const TextStyle(height: 1.5),
                          ),
                        ),

                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: _buildImageScroller(),
                        ),
                        const CustomDivider(),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: _buildSectionHeader(
                            title: "PRODUCTS",
                            isExpanded: showMoreProducts,
                            onTap: () => setState(() => showMoreProducts = !showMoreProducts),
                          ),
                        ),
                        Divider(
                          height: 0,
                          color: Colors.grey,
                          thickness: 2,
                          indent : 20,
                          endIndent : 20,
                        ),
                        const SizedBox(height: 8),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: const Text("Civilian", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        ),
                        const SizedBox(height: 4),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            showMoreProducts
                                ? "The Airbus product line started with the A300 in 1972, the world's first twin-aisle, twin-engined aircraft. "
                                "A shorter, re-winged, re-engined variant of the A300 is the A310. The family evolved into the A320, A330, A340, and the iconic double-decker A380."
                                : "The Airbus product line started with the A300 in 1972, the world's first twin-aisle, twin-engined aircraft...",
                            style: const TextStyle(height: 1.5),
                          ),
                        ),

                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: const Text("Military", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        ),
                        const SizedBox(height: 4),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            showMoreProducts
                                ? "In the late 1990s, Airbus became increasingly interested in developing and selling to the military aviation market. "
                                "It embarked on two main fields of development: aerial refueling tankers such as the A330 MRTT, and tactical airlifters such as the A400M Atlas."
                                : "In the late 1990s, Airbus became increasingly interested in developing and selling to the military aviation market...",
                            style: const TextStyle(height: 1.5),
                          ),
                        ),
                        const CustomDivider(),
                        const SizedBox(height: 40),
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
                    child: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                  ),
                ),
                Positioned(
                  top: screenHeight * 0.25,
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
            )
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18));
  }

  Widget _buildGeneralInfo(double screenWidth) {
    return Column(
      children: [
        Row(
          children: [
            customField(label: 'Headquarters', text: 'Leiden, Netherlands', width: screenWidth * 0.4),
            const SizedBox(width: 12),
            customField(label: 'CEO', text: 'Guillaume Faury', width: screenWidth * 0.4),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            customField(label: 'Founding Date', text: '1970', width: screenWidth * 0.4),
            const SizedBox(width: 12),
            customField(label: 'Last year revenue', text: '52.15 bil EUR', width: screenWidth * 0.4),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required bool isExpanded,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Row(
              children: [
                Text(
                  isExpanded ? "Show Less" : "Show More",
                  style: const TextStyle(color: Colors.black, fontSize: 14),
                ),
                Icon(isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
              ],
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildImageScroller() {
    return SizedBox(
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
    );
  }
}
