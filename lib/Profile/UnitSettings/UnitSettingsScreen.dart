import 'package:avionics_internal/Constants/OnboardingTexts.dart';
import 'package:avionics_internal/CustomFiles/CustomAppBar.dart';
import 'package:flutter/material.dart';

class UnitSelectionScreen extends StatefulWidget {
  @override
  _UnitSelectionScreenState createState() => _UnitSelectionScreenState();
}

class _UnitSelectionScreenState extends State<UnitSelectionScreen> {
  String selectedSpeed = 'Kts';
  String selectedAltitude = 'Feet';
  String selectedDistance = 'Miles';
  String selectedTemperature = 'Celsius';

  Widget buildSegmentedControl(
    String title,
    List<String> options,
    String selectedValue,
    Function(String) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade200,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
            color: Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: options.map((option) {
              final isSelected = option == selectedValue;
              return Expanded(
                child: GestureDetector(
                  onTap: () => onChanged(option),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 7),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white : Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          option,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        SizedBox(height: 24),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: OnboardingTexts.unitsMeasurmentsTitle,
        leftButton: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildSegmentedControl(
                'Speed',
                ['Kts', 'MPH', 'Km/h'],
                selectedSpeed,
                (val) {
                  setState(() => selectedSpeed = val);
                },
              ),
              buildSegmentedControl(
                'Altitude',
                ['Feet', 'Meters'],
                selectedAltitude,
                (val) {
                  setState(() => selectedAltitude = val);
                },
              ),
              buildSegmentedControl(
                'Distances',
                ['Miles', 'Kilometers'],
                selectedDistance,
                (val) {
                  setState(() => selectedDistance = val);
                },
              ),
              buildSegmentedControl(
                'Temperatures',
                ['Celsius', 'Fahrenheit'],
                selectedTemperature,
                (val) {
                  setState(() => selectedTemperature = val);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
