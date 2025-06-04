import 'package:flutter/material.dart';

class SelectableAircraftCard extends StatelessWidget {
  final String imagePath;
  final String model;
  final String badge;
  final String manufacturer;
  final String? airline;
  final bool isSelected;
  final VoidCallback? onTap;

  const SelectableAircraftCard({
    Key? key,
    required this.imagePath,
    required this.model,
    required this.badge,
    required this.manufacturer,
    this.airline,
    this.isSelected = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(12),
      color: Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected ? Colors.blue : Colors.grey.shade300,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(12),
          child: Stack(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(imagePath, height: 50),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          model,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          badge,
                          style: const TextStyle(color: Colors.grey),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          manufacturer,
                          style: const TextStyle(color: Colors.grey),
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (airline != null)
                          Text(
                            airline!,
                            style: const TextStyle(color: Colors.grey),
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              if (isSelected)
                const Positioned(
                  right: 12,
                  top: 12,
                  child: Icon(Icons.check_circle, color: Colors.blue, size: 24),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
