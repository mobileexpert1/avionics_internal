import 'package:avionics_internal/Constants/constantImages.dart';
import 'package:avionics_internal/Helpers/CustomDivider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Helpers/Custom_widget.dart';
import '../Helpers/FactList.dart';
import '../bloc/AirCraftDetail/airCraftDetail_cubit.dart';

class PlanDetailScreen extends StatefulWidget {
  const PlanDetailScreen({super.key});

  @override
  State<PlanDetailScreen> createState() => _PlanDetailScreenState();
}

class _PlanDetailScreenState extends State<PlanDetailScreen> {
  bool showTechData = false;
  bool showOpData = false;
  bool showInData = false;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final horizontalPadding = size.width * 0.04; // 4% padding

    return BlocProvider(
      create: (_) => AirCraftDetailCubit(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text("A-320-200", style: TextStyle(color: Colors.black)),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 16),
          child: ListView(
            children: [
              // Top Info Row - use Flexible + Expanded to avoid overflow
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 1,
                    child: customField(
                      label: 'ICAO type /APC',
                      text: 'Manufacturer',
                      width: double.infinity,
                    ),
                  ),
                  SizedBox(width: size.width * 0.02),
                  Flexible(
                    flex: 1,
                    child: customField(
                      label: 'Manufacturer',
                      text: 'Airbus',
                      width: double.infinity,
                    ),
                  ),
                  SizedBox(width: size.width * 0.02),
                  Flexible(
                    flex: 1,
                    child: customField(
                      label: 'WTC',
                      text: 'M',
                      width: double.infinity,
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.025),

              // Plane Image
              ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: Image.asset(
                  CommonUi.setPngImage(AssetsPath.AirbusPageImage),
                  height: size.height * 0.18,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: size.height * 0.025),

              // Description Placeholder - allow wrapping
              const Text(
                "detail.description",
                style: TextStyle(fontSize: 16, color: Colors.black87),
                textAlign: TextAlign.left,
              ),
              SizedBox(height: size.height * 0.04),

              /// TECHNICAL DATA Section
              _buildSectionHeader(
                title: "TECHNICAL DATA",
                isExpanded: showTechData,
                onTap: () => setState(() => showTechData = !showTechData),
              ),
              const CustomDivider(),
              if (showTechData) _buildTechnicalData(size),
              SizedBox(height: size.height * 0.025),

              /// OPERATIONAL DATA Section
              _buildSectionHeader(
                title: "OPERATIONAL DATA",
                isExpanded: showOpData,
                onTap: () => setState(() => showOpData = !showOpData),
              ),
              const CustomDivider(),
              if (showOpData) _buildOperationalData(size),
              SizedBox(height: size.height * 0.025),

              /// INTERESTING FACTS Section
              _buildSectionHeader(
                title: "INTERESTING FACTS",
                isExpanded: showInData,
                onTap: () => setState(() => showInData = !showInData),
              ),
              const CustomDivider(),
              if (showInData) ...[
                SizedBox(height: size.height * 0.02),
                InterestingFacts(size),
              ],
            ],
          ),
        ),
      ),
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

  Widget _buildTechnicalData(Size size) {
    // use Flexible for customField and avoid fixed widths
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: size.height * 0.02),
        Wrap(
          spacing: size.width * 0.03,
          runSpacing: size.height * 0.015,
          children: [
            SizedBox(
                width: size.width / 2.3,
                child: customField(label: 'Wingspan', text: '34.10 m')),
            SizedBox(
                width: size.width / 2.3,
                child: customField(label: 'Length', text: '37.57 m')),
            SizedBox(
                width: size.width / 2.3,
                child: customField(label: 'Height', text: '12.08 m')),
            SizedBox(
                width: size.width / 2.3,
                child: customField(label: 'Power Plant', text: '2 Jet (J) engines')),
            SizedBox(
                width: size.width / 2.3,
                child: customField(label: 'Landing Gear', text: 'Tricycle retractable')),
            SizedBox(
              width: size.width,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
                child: Image.asset(
                  CommonUi.setPngImage(AssetsPath.airCraftDetailImage),
                  width: size.width * 0.8,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(
                width: size.width / 2.3,
                child: customField(
                    label: 'MTOW', text: '73.5 t', showInfoIcon: true)),
            SizedBox(
                width: size.width / 2.3,
                child: customField(
                    label: 'MLW', text: '64.5 t', showInfoIcon: true)),
            SizedBox(
                width: size.width / 2.3,
                child: customField(
                    label: 'Max Range', text: '3000 NM', showInfoIcon: true)),
            SizedBox(
                width: size.width / 2.3,
                child: customField(
                    label: 'Fuel Capacity', text: '23859 l', showInfoIcon: true)),
            SizedBox(
                width: size.width / 2.3,
                child: customField(label: 'PDB', text: '150–179')),
            SizedBox(
                width: size.width / 2.3,
                child: customField(label: 'Crew', text: '2')),
          ],
        ),
      ],
    );
  }

  Widget _buildOperationalData(Size size) {
    // Replace this with actual operational data for better UX
    return _buildTechnicalData(size);
  }
}
