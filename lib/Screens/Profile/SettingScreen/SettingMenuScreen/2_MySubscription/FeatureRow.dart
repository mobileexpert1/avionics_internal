import 'package:flutter/material.dart';
import '../../../../../Constants/AppColors.dart';
import '../../../../../Helpers/AppTextStyles/AppTextStyles.dart';

class FeatureRow extends StatelessWidget {
  final String text;
  final bool isPremium;

  const FeatureRow({super.key, required this.text, this.isPremium = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          CircleAvatar(
            radius: 10,
            backgroundColor: AppColors.greenColourForPlan,
            child: const Icon(Icons.check, size: 15, color: Colors.white),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.medium(14).copyWith(
                height: 1.0,
                color: isPremium ? Colors.black : Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
