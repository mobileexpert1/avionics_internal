import 'package:flutter/material.dart';

import 'Helpers/CustomHeaderViewExpandable.dart';

class DemoScreen extends StatefulWidget {
  const DemoScreen({super.key});

  @override
  State<DemoScreen> createState() => _DemoScreenState();
}

class _DemoScreenState extends State<DemoScreen> {
  String? selectedLetter;

  bool isLibraryExpanded = false;
  bool isManufacturerExpanded = false;
  bool isSelectedExpanded = false;

  List<String> get alphabets =>
      List.generate(26, (index) => String.fromCharCode(65 + index));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Expandable UI"),
        backgroundColor: Colors.black,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          CustomHeaderViewExpandable(
            isNeedToShowLeftRightBottomBorder:false,
            isNeedToShowLeftImage:true,
            title: "Library",
            headerColor: const Color(0xFF201E48),
            arrowBackgroundColor: const Color(0xFFF9E84B),
            isExpandedViewAvailable: true,
            arrowFrontColor: Colors.black,
            isExpanded: isLibraryExpanded,
            onHeaderTap: () {
              setState(() {
                isLibraryExpanded = !isLibraryExpanded;
              });
            },
          ),

          const SizedBox(height: 50),

          CustomHeaderViewExpandable(
            isNeedToShowLeftRightBottomBorder:false,
            isNeedToShowLeftImage:true,
            title: "Manufacturer",
            headerColor: const Color(0x4F99D8FF),
            arrowBackgroundColor: const Color(0xFFF9E84B),
            isExpandedViewAvailable: true,
            arrowFrontColor: Colors.black,
            isExpanded: isManufacturerExpanded,
            onHeaderTap: () {
              setState(() {
                isManufacturerExpanded = !isManufacturerExpanded;
              });
            },
          ),

          const SizedBox(height: 50),



          CustomHeaderViewExpandable(
            isNeedToShowLeftRightBottomBorder:false,
            isNeedToShowLeftImage:true,
            title: "Selected: ${selectedLetter ?? ''}",
            headerColor: const Color(0x4F99D8FF),
            arrowBackgroundColor: const Color(0xFFF9E84B),
            isExpandedViewAvailable: true,
            arrowFrontColor: Colors.black,
            isExpanded: isSelectedExpanded,
            onHeaderTap: () {
              setState(() {
                selectedLetter = null;
                isSelectedExpanded = !isSelectedExpanded;
              });
            },
          ),
        ],
      ),
    );
  }
}
