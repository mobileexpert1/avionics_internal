import 'package:avionics_internal/CustomFiles/CustomAppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../Constants/AppColors.dart';
import '../../../../Constants/ConstantStrings.dart';
import '../../../../Helpers/Custom_widget.dart';
import '../../../../bloc/home/manufacturer/manufacturer_cubit.dart';
import '../../../../bloc/home/manufacturer/manufacturer_state.dart';

class AirCraftDetailScreen extends StatefulWidget {
  const AirCraftDetailScreen({super.key});

  @override
  State<AirCraftDetailScreen> createState() => _AirCraftDetailScreenState();
}

class _AirCraftDetailScreenState extends State<AirCraftDetailScreen> {
  bool showIdentification = true;
  bool showPowerSection = true;
  bool showDimensionSection = true;

  bool showWeightsSection = true;
  bool showPerformanceSection = true;
  bool showOperationalSection = true;
  bool showLandingSection = true;
  bool showCertificationSection = true;

  List<String> coverImages = ["", "", "", ""];
  List<String> galleryImages = ["", "", "", ""];

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return BlocBuilder<ManufacturerCubit, ManufacturerState>(
      builder: (context, state) {
        return Scaffold(
          appBar: CustomAppBar(
            title: 'A-320-200',
            centerTitle: false,
            leftButton: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTopHeadingDetails(screenHeight),

                    //------------------------------------------------------------------------------------------------------------------------
                    _buildExpandableSection(
                      title: "IDENTIFICATION & CLASSIFICATION",
                      isExpanded: showIdentification,
                      onToggle: () => setState(
                        () => showIdentification = !showIdentification,
                      ),
                      content: _buildTechnicalData(),
                    ),

                    _buildExpandableSection(
                      title: "POWERPLANT & PROPULSION",
                      isExpanded: showPowerSection,
                      onToggle: () =>
                          setState(() => showPowerSection = !showPowerSection),
                      content: _buildPowerPlantData(),
                    ),

                    _buildExpandableSection(
                      title: "DIMENSIONS",
                      isExpanded: showDimensionSection,
                      onToggle: () => setState(
                        () => showDimensionSection = !showDimensionSection,
                      ),
                      content: _buildDimenionsData(),
                    ),

                    _buildExpandableSection(
                      title: "WEIGHTS",
                      isExpanded: showWeightsSection,
                      onToggle: () => setState(
                        () => showWeightsSection = !showWeightsSection,
                      ),
                      content: _buildWeightsData(),
                    ),

                    _buildExpandableSection(
                      title: "PERFORMANCE (ORDERED BY FLIGHT SEQUENCE)",
                      isExpanded: showPerformanceSection,
                      onToggle: () => setState(
                        () => showPerformanceSection = !showPerformanceSection,
                      ),
                      content: _builPerfomanceOrderedBYsData(),
                    ),

                    _buildExpandableSection(
                      title: "OPERATIONAL LIMITATIONS",
                      isExpanded: showOperationalSection,
                      onToggle: () => setState(
                        () => showOperationalSection = !showOperationalSection,
                      ),
                      content: _builOperationLimitationsData(),
                    ),

                    _buildExpandableSection(
                      title: "LANDING GEAR",
                      isExpanded: showLandingSection,
                      onToggle: () => setState(
                        () => showLandingSection = !showLandingSection,
                      ),
                      content: _builLandingGearData(),
                    ),

                    _buildExpandableSection(
                      title: "CERTIFICATION & ENVIRONMENTAL",
                      isExpanded: showCertificationSection,
                      onToggle: () => setState(
                        () => showCertificationSection =
                            !showCertificationSection,
                      ),
                      content: _builCertificationData(),
                    ),

                    //------------------------------------------------------------------------------------------------------------------------
                    // _buildImageGalleryScroller(galleryImages),
                    SizedBox(height: 50),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildImageCoverScroller(
    double screenHeight,
    List<String> coverImages,
  ) {
    return SizedBox(
      height: screenHeight * 0.18,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: coverImages.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return ClipRRect(
            child: Image.network(
              coverImages[index],
              width: MediaQuery.of(context).size.width,
              height: screenHeight * 0.18,
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }

  Widget _buildExpandableSection({
    required String title,
    required bool isExpanded,
    required VoidCallback onToggle,
    required Widget content,
  }) {
    return Column(
      children: [
        _buildSectionHeader(
          title: title,
          isExpanded: isExpanded,
          onTap: onToggle,
        ),
        isExpanded
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: content,
              )
            : const SizedBox.shrink(),
        const Divider(
          height: 0,
          color: AppColors.sepratorColourAppBar,
          thickness: 3,
        ),
      ],
    );
  }

  Widget _buildTopHeadingDetails(screenHeight) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Container(
        width: double.infinity,
        color: Colors.grey.shade100,
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ), // Internal padding
        child: Column(
          children: [
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: customField(
                    label: 'ICAO type /APC',
                    text: "L2J/C",
                    isDarkDivider: true,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: customField(
                    label: 'Manufacturer',
                    text: "Airbus",
                    isDarkDivider: true,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: customField(
                    label: 'WTC',
                    text: "M",
                    isDarkDivider: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            _buildImageCoverScroller(screenHeight, coverImages),
            const SizedBox(height: 15),
            Text(
              "The Airbus A320 family are short to medium range narrow body low-wing monoplanes with two"
              " underwing mounted engines, conventional empennage, single vertical stabilizer and rudder. "
              "The name/ICAO Code A320 only refers to the original mid-sized aircraft, "
              "but it is often informally used to indicate any of the A320 family: A318, A319, A320 and A321.",
            ),
          ],
        ),
      ),
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
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: GestureDetector(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      title.toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12, 
                        color: Color(0xFF3F3D56)
                      ),
                    ),
                  ),

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

  Widget _buildFieldRows(List<List<String>> fields) {
    return Column(
      children: List.generate((fields.length / 2).ceil(), (i) {
        final first = fields[i * 2];
        final second = i * 2 + 1 < fields.length ? fields[i * 2 + 1] : null;

        return Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: Row(
            children: [
              Expanded(
                child: customField(label: first[0], text: first[1]),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: second != null
                    ? customField(label: second[0], text: second[1])
                    : const SizedBox(),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildImageGalleryScroller(List<String>? galleryImages) {
    if (galleryImages == null || galleryImages.isEmpty) return const SizedBox();
    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: Colors.grey.shade200, // Background color of the list
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: galleryImages.length,
        itemBuilder: (context, index) => Container(
          margin: EdgeInsets.only(
            right: index == galleryImages.length - 1 ? 0 : 10,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: Image.network(
              galleryImages[index],
              width: 300,
              height: 120,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 300,
                height: 120,
                color: Colors.grey.shade300,
                alignment: Alignment.center,
                child: const Icon(Icons.broken_image, color: Colors.grey),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTechnicalData() {
    return _buildFieldRows([
      ['ICAO Type Code', 'A320'],
      ['Aircraft Manufacturer', 'Airbus'],
      ['Aircraft Model (Full name)', 'Airbus A320'],
      ['Aircraft Role', 'Regional Jet'],
      ['Aircraft Type', 'Airplane'],
      ['Wake Turbulence Category', 'Medium'],
      ['Civilian / Military / Dual Use', 'Civilian'],
      ['Country of Origin', 'France'],
      ['Date of Maiden Flight', 'February 22, 1987'],
      ['Year of Introduction', '1988'],
      ['Production Status', 'In service'],
      ['Avionics System Name', 'Honeywell'],
      ['Number of Crew', '2'],
      ['Number of Passengers', '140–240'],
    ]);
  }

  Widget _buildPowerPlantData() {
    return _buildFieldRows([
      ['Number of Engines', '2'],
      ['Engine Manufacturer & Model', 'A320ceo'],
      ['Engine Type', 'Turbofan'],
      ['Engine Thrust (per engine)', 'CFM56-5B'],
      ['Physical Engine Code', 'CFM56-5B4/P'],
      ['APU Type', 'Honeywell 131-9A'],
      ['Fuel Type', 'Jet A'],
      ['Fuel Additives', 'None required'],
      ['Fuel Capacity', 'A320ceo: ~24,000 liters'],
      ['Fuel Consumption', '2,500–2,700 kg/hr'],
    ]);
  }

  Widget _buildDimenionsData() {
    return _buildFieldRows([
      ['Wingspan/Rotor', '35.80 m'],
      ['Length', '37.57 m'],
      ['Height', '11.76 m'],
      ['Wing Area', '122.6 m²'],
      ['Cabin Width', '3.70 m'],
      ['Door Height', '1.20–1.50 m'],
      ['Wingtip Configuration', 'Wingtip Fences'],
      ['Fuel Additives', 'None required'],
      ['Fuel Capacity', 'A320ceo: ~24,000 liters'],
    ]);
  }

  Widget _buildWeightsData() {
    return _buildFieldRows([
      ['Operating Empty Weight', '~42,600 kg'],
      ['Maximum Zero Fuel Weight', '~61,000 kg'],
      ['Maximum Takeoff Weight', '~78,000 kg'],
      ['Max Payload', '~19,000 kg'],
      ['Maximum Landing Weight', '~66,000 kg'],
      ['Baggage Volume', '~37.4 m³'],
    ]);
  }

  Widget _builPerfomanceOrderedBYsData() {
    return _buildFieldRows([
      ['Takeoff Speed', '~140–155 knots'],
      ['Takeoff Distance', '~2,090 m'],
      ['Initial Rate of Climb', '~2,000–3,000 fpm'],
      ['Average Rate of Climb', '~1,500–2,500 fpm'],
      ['Maximum Rate of Climb', 'Up to ~3,500 fpm'],
      ['Service Ceiling', '39,000 ft (FL390)'],
      ['Max Certified Altitude', '39,000 ft (FL390)'],
      ['Cruise Speed', 'Mach 0.78'],
      ['Maximum Speed', 'Mach 0.82'],
      ['Range (NM / km)', '~3,300 NM (6,112 km)'],
      ['Ferry Range (if applicable)', '~3,750 NM'],
      ['Initial Rate of Descent', '~1,500–2,000 fpm'],
      ['Average Rate of Descent', '~1,500 fpm'],
      ['Minimum Clean Speed', '~210 knots'],
      ['Minimum Clean Speed', '~210 knots'],
      ['Approach Speed (Vapp', '~130–140 knots'],
      ['Approach Category', 'CAT C'],
      ['Landing Speed (Vref)', '~125–135 knots'],
      ['Landing Distance', '~1,500 m'],
      ['Runway Length Required', '~2,000 m'],
      ['Stall Speed', '~173 knots'],
    ]);
  }

  Widget _builOperationLimitationsData() {
    return _buildFieldRows([
      ['Runway Slope Limit (%)', '±2%'],
      ['Maximum Crosswind (Normal Law)', '38 knots'],
      ['Maximum Crosswind (Degraded Law)', '33 knots'],
      ['Maximum Tailwind (General)', '15 knots'],
      ['Tailwind Limit (Flaps ≤10°)', 'Not applicable'],
      ['Field Elevation Limit', '8,000 ft'],
      ['Tailwind Limit (Flaps ≤10°)', 'Not applicable'],
      ['Field Elevation Limit', '8,000 ft'],
      ['Maximum Runway Altitude', '9,200 ft'],
      ['Category for Autoland', 'CAT I'],
    ]);
  }

  Widget _builLandingGearData() {
    return _buildFieldRows([
      ['Landing Gear Configuration', 'Tricycle'],
      ['Number of Wheels', '6 total'],
      ['Tyre Size', '46×16.0 R20'],
      ['Tyre Pressure', '~200 psi (13.8 bar)'],
    ]);
  }

  Widget _builCertificationData() {
    return _buildFieldRows([
      ['Certification Basis', 'EASA CS-25'],
      ['EASA TCDS Number', 'EASA.A.064'],
      ['FAA TCDS Number', 'A28NM'],
      ['Special Conditions', 'ETOPS 180 certified'],
      ['Noise Compliance', 'ICAO Annex 16'],
      ['Emissions Category', 'ICAO CAEP/6'],
    ]);
  }
}
