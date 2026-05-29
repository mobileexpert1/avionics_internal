import 'package:flutter/material.dart';

class MapToggleButtons extends StatelessWidget {
  final bool isMapViewSelected;

  final void Function(bool) onToggle;

  const MapToggleButtons({
    Key? key,
    required this.isMapViewSelected,
    required this.onToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // Map View Button
          GestureDetector(
            onTap: () => onToggle(true),
            child: Container(
              width: 85,
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              decoration: BoxDecoration(
                color: isMapViewSelected
                    ? const Color(0xFF2E334D)
                    : Colors.white,
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Map view',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: isMapViewSelected ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // List View Button
          GestureDetector(
            onTap: () => onToggle(false),
            child: Container(
              width: 85,
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              decoration: BoxDecoration(
                color: isMapViewSelected
                    ? Colors.white
                    : const Color(0xFF2E334D),
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Center(
                child: Text(
                  'List view',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: isMapViewSelected ? Colors.black : Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
