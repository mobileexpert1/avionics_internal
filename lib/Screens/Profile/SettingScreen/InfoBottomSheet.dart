import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class InfoBottomSheet extends StatelessWidget {
  final VoidCallback onYes;
  final VoidCallback onNo;
  final bool isComeFromLogout;

  const InfoBottomSheet({
    super.key,
    required this.onYes,
    required this.onNo,
    required this.isComeFromLogout,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double maxWidth = constraints.maxWidth > 500
            ? 500
            : constraints.maxWidth;

        Widget content = Container(
          width: maxWidth,
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(16),
              bottom: Radius.circular(16),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isComeFromLogout
                    ? "Are you sure you want to logout?"
                    : "Do you want to delete your account?",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: onYes,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3F3D51),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: const Text(
                          "Yes",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: OutlinedButton(
                        onPressed: onNo,
                        style: OutlinedButton.styleFrom(
                          backgroundColor: const Color(0xFFEAEAEA),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: const Text(
                          "No",
                          style: TextStyle(
                            color: Color(0xFF3F3D51),
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );

        // Web -> Center, Mobile -> Bottom
        return kIsWeb
            ? Center(child: content)
            : Align(alignment: Alignment.bottomCenter, child: content);
      },
    );
  }
}
