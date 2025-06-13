import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:avionics_internal/CustomFiles/CustomAppBar.dart';
import 'package:avionics_internal/Constants/ConstantStrings.dart';
import '../../../bloc/Profile/UnitSelection/unit_selection_cubit.dart';
import '../../../bloc/Profile/UnitSelection/unit_selection_state.dart';

class UnitSelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: ConstantStrings.unitsMeasurmentsTitle,
        leftButton: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: BlocBuilder<UnitSelectionCubit, UnitSelectionState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildSegmentedControl(
                    title: 'Speed',
                    options: ['Kts', 'MPH', 'Km/h'],
                    selectedValue: state.speed,
                    onChanged: (val) =>
                        context.read<UnitSelectionCubit>().selectSpeed(val),
                  ),
                  buildSegmentedControl(
                    title: 'Altitude',
                    options: ['Feet', 'Meters'],
                    selectedValue: state.altitude,
                    onChanged: (val) =>
                        context.read<UnitSelectionCubit>().selectAltitude(val),
                  ),
                  buildSegmentedControl(
                    title: 'Distances',
                    options: ['Miles', 'Kilometers'],
                    selectedValue: state.distance,
                    onChanged: (val) =>
                        context.read<UnitSelectionCubit>().selectDistance(val),
                  ),
                  buildSegmentedControl(
                    title: 'Temperatures',
                    options: ['Celsius', 'Fahrenheit'],
                    selectedValue: state.temperature,
                    onChanged: (val) => context
                        .read<UnitSelectionCubit>()
                        .selectTemperature(val),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildSegmentedControl({
    required String title,
    required List<String> options,
    required String selectedValue,
    required Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade200,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
            color: Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(10),
          ),
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
                    child: Text(
                      option,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                      ),
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
}
