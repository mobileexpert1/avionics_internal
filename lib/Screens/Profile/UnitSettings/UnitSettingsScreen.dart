import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:avionics_internal/CustomFiles/CustomAppBar.dart';
import 'package:avionics_internal/Constants/ConstantStrings.dart';
import '../../../bloc/Profile/UnitSelection/unit_selection_cubit.dart';
import '../../../bloc/Profile/UnitSelection/unit_selection_state.dart';

class UnitSelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double maxWidth = MediaQuery.of(context).size.width > 1500
        ? 1500
        : MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: CustomAppBar(
        title: ConstantStrings.unitsMeasurmentsTitle,
        leftButton: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white,size: 30),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: BlocBuilder<UnitSelectionCubit, UnitSelectionState>(
                builder: (context, state) {
                  if (state is UnitSelectionInitial) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        buildSegmentedControl(
                          context: context,
                          title: 'Speed',
                          options: ['Kts', 'MPH', 'Km/h'],
                          selectedValue: state.speed,
                          onChanged: (val) =>
                              context.read<UnitSelectionCubit>().selectSpeed(val),
                        ),
                        buildSegmentedControl(
                          context: context,
                          title: 'Altitude',
                          options: ['Feet', 'Meters'],
                          selectedValue: state.altitude,
                          onChanged: (val) =>
                              context.read<UnitSelectionCubit>().selectAltitude(val),
                        ),
                        buildSegmentedControl(
                          context: context,
                          title: 'Distances',
                          options: ['Miles', 'Kilometers'],
                          selectedValue: state.distance,
                          onChanged: (val) =>
                              context.read<UnitSelectionCubit>().selectDistance(val),
                        ),
                        buildSegmentedControl(
                          context: context,
                          title: 'Temperatures',
                          options: ['Celsius', 'Fahrenheit'],
                          selectedValue: state.temperature,
                          onChanged: (val) =>
                              context.read<UnitSelectionCubit>().selectTemperature(val),
                        ),
                      ],
                    );
                  } else if (state.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return const Center(child: Text("Unable to load unit preferences."));
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSegmentedControl({
    required BuildContext context,
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
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade200,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: options.map((option) {
              final isSelected = option == selectedValue;
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (!isSelected) {
                      onChanged(option);
                      context.read<UnitSelectionCubit>().submitPreferences(context);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 7),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white : const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      option,
                      style: const TextStyle(
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
        const SizedBox(height: 24),
      ],
    );
  }
}
