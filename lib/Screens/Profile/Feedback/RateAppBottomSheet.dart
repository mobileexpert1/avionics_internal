import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../Constants/AppColors.dart';
import '../../../Helpers/AppTextStyles/AppTextStyles.dart';

class RateAppBottomSheet extends StatelessWidget {
  final VoidCallback onRate;
  final VoidCallback onMaybeLater;

  const RateAppBottomSheet({
    super.key,
    required this.onRate,
    required this.onMaybeLater,
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
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 15),

              Text(
                "Enjoying the Experience ?",
                textAlign: TextAlign.center,
                style: AppTextStyles.bold(
                  26,
                ).copyWith(color: AppColors.primaryValueColour),
              ),

              const SizedBox(height: 15),

              /// Subtitle
              Text(
                "We’re thrilled to have you! Would\n you mind sharing your love on\n the store?",
                textAlign: TextAlign.center,
                style: AppTextStyles.regular(20).copyWith(
                  color: AppColors.grayMedium,
                  height: 1.3,
                  letterSpacing: 1,
                ),
              ),

              const SizedBox(height: 50),

              /// Rate Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: onRate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryValueColour,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Rate on Store",
                    style: AppTextStyles.semiBold(16).copyWith(
                      color: Colors.white,
                      height: 1.4,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              /// Maybe Later
              GestureDetector(
                onTap: onMaybeLater,
                child: Text(
                  "Maybe later",
                  style: AppTextStyles.semiBold(16).copyWith(
                    color: AppColors.grayMedium,
                    height: 1.4,
                    letterSpacing: 2,
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        );

        return kIsWeb
            ? Center(child: content)
            : Align(alignment: Alignment.bottomCenter, child: content);
      },
    );
  }
}
