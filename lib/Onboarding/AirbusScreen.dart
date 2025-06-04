import 'package:avionics_internal/Constants/constantImages.dart';
import 'package:flutter/material.dart';

import 'AllPlanesScreen.dart';

class AirbusScreen extends StatefulWidget {
  const AirbusScreen({super.key});

  @override
  State<AirbusScreen> createState() => _AirbusScreenState();
}

class _AirbusScreenState extends State<AirbusScreen> {
  @override
  Widget build(BuildContext context) {
    // Screen size helpers
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Responsive font sizes (adjust as you like)
    double titleFontSize = screenWidth * 0.05; // example ~20 on 400 width
    double subtitleFontSize = screenWidth * 0.045;
    double sectionTitleFontSize = screenWidth * 0.035;
    double bodyFontSize = screenWidth * 0.035;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.00), // 5% horizontal padding
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Airbus banner image
                  ClipRRect(
                    child: Image.asset(
                      CommonUi.setPngImage(AssetsPath.AirbusPageImage),
                      fit: BoxFit.fill,
                      width: double.infinity,
                      height: screenHeight * 0.3, // 30% of screen height
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.07),
                  Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: Text(
                      'Airbus',
                      style: TextStyle(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: Text(
                      'European aircraft manufacturer',
                      style: TextStyle(
                        fontSize: subtitleFontSize,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.04),

                  // Aircraft list card
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.grey.shade300,
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Card(
                      color: Colors.white,
                      elevation: 0,
                      margin: EdgeInsets.zero,
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                        leading: Image.asset(
                          CommonUi.setPngImage(AssetsPath.airbusplane),
                          fit: BoxFit.contain,
                          width: screenWidth * 0.09,
                        ),
                        title: Text(
                          'List of All Planes',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth * 0.04,
                          ),
                        ),
                        trailing: Icon(
                          Icons.chevron_right,
                          size: screenWidth * 0.07,
                          color: Colors.black,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AllPlanesScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.02),
                  ..._buildExpansionTiles(sectionTitleFontSize, bodyFontSize, screenWidth),
                  SizedBox(height: screenHeight * 0.1),
                ],
              ),
              Positioned(
                top: screenHeight * 0.06,
                left: screenWidth * 0.07,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context); // Navigates back
                  },
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      size: 24,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              Positioned(
                top: screenHeight * 0.25,
                left: screenWidth * 0.07,
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
      ),
    );
  }

  List<Widget> _buildExpansionTiles(double titleFontSize, double bodyFontSize, double screenWidth) {
    return [
      // GENERAL INFORMATION
      ExpansionTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'GENERAL INFORMATION',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: titleFontSize,
              ),
            ),
            SizedBox(height: 4),
            Divider(
              thickness: 1.5,
              height: 0,
              color: Colors.grey,
            ),
          ],
        ),
        children: [
          Padding(
            padding: EdgeInsets.only(left: screenWidth * 0.00, bottom: 8),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    customField(label: 'Headquarters', text: 'Leiden, Netherlands', width: screenWidth * 0.4, fontSize: bodyFontSize),
                    SizedBox(width: 10),
                    customField(label: 'CEO', text: 'Guillaume Faury', width: screenWidth * 0.4, fontSize: bodyFontSize),
                  ],
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    customField(label: 'Founding Date', text: '1970', width: screenWidth * 0.4, fontSize: bodyFontSize),
                    SizedBox(width: 10),
                    customField(label: 'Last year revenue', text: '52.15 bil EUR', width: screenWidth * 0.4, fontSize: bodyFontSize),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),

      // ABOUT THE COMPANY
      Padding(
        padding: EdgeInsets.only(top: 8.0),
        child: ExpansionTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ABOUT THE COMPANY',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: titleFontSize,
                ),
              ),
              SizedBox(height: 4),
              Divider(
                thickness: 1.5,
                height: 0,
                color: Colors.grey,
              ),
            ],
          ),
          children: [
            Padding(
              padding: EdgeInsets.only(left: screenWidth * 0.04, bottom: 8),
              child: Text(
                "Airbus SE is a multinational aerospace corporation. Airbus designs, manufactures and sells civil and military aerospace products worldwide. "
                    "The company is a leading aircraft manufacturer and operates globally with major facilities in Europe and production lines in Asia and North America.",
                style: TextStyle(
                  fontSize: bodyFontSize,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),

      // HISTORY
      Padding(
        padding: EdgeInsets.only(top: 8.0),
        child: ExpansionTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'HISTORY',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: titleFontSize,
                ),
              ),
              SizedBox(height: 4),
              Divider(
                thickness: 1.5,
                height: 0,
                color: Colors.grey,
              ),
            ],
          ),
          children: [
            Padding(
              padding: EdgeInsets.only(left: screenWidth * 0.04, bottom: 8),
              child: Text(
                "The current company is the product of consolidation in the European aerospace industry tracing back to 1970...",
                style: TextStyle(
                  fontSize: bodyFontSize,
                  height: 1.5,
                ),
              ),
            ),
            SizedBox(height: 12),
            SizedBox(
              height: 120,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                child: Row(
                  children: List.generate(
                    3,
                        (index) => Padding(
                      padding: EdgeInsets.only(right: index == 2 ? 0 : 10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
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
              ),
            ),
          ],
        ),
      ),

      // PRODUCTS
      Padding(
        padding: EdgeInsets.only(top: 8.0),
        child: ExpansionTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'PRODUCTS',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: titleFontSize,
                ),
              ),
              SizedBox(height: 4),
              Divider(
                thickness: 1.5,
                height: 0,
                color: Colors.grey,
              ),
            ],
          ),
          children: [
            Padding(
              padding: EdgeInsets.only(left: screenWidth * 0.03, bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Civilian',
                    style: TextStyle(
                      fontSize: screenWidth * 0.045,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'The Airbus product line started with the A300 in 1972, the world\'s first twin-aisle, twin-engined aircraft. '
                        'A shorter, re-winged, re-engined variant of the A300 is...',
                    style: TextStyle(
                      fontSize: bodyFontSize,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Military',
                    style: TextStyle(
                      fontSize: screenWidth * 0.045,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'In the late 1990s, Airbus became increasingly interested in developing and selling to the military aviation market. '
                        'It embarked on two main fields of development: aerial...',
                    style: TextStyle(
                      fontSize: bodyFontSize,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    ];
  }

  Widget customField({
    required String label,
    required String text,
    double? width,
    double? fontSize,
  }) {
    return SizedBox(
      width: width ?? MediaQuery.of(context).size.width / 2.4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: Colors.grey, fontSize: fontSize != null ? fontSize - 2 : 14)),
          SizedBox(height: 5),
          Text(text, style: TextStyle(color: Colors.black, fontSize: fontSize ?? 16)),
          Divider(
            height: 10,
            color: Colors.grey,
            thickness: 1,
          ),
        ],
      ),
    );
  }
}
