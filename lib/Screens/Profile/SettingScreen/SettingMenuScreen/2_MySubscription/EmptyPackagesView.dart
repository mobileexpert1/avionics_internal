import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../Helpers/AppTextStyles/AppTextStyles.dart';

class EmptyPackagesView extends StatelessWidget {
  final bool isLoading;

  const EmptyPackagesView({super.key, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const SizedBox.shrink();

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No packs available',
              style: AppTextStyles.semiBold(18).copyWith(color: Colors.black87),
            ),
            const SizedBox(height: 8),
            Text(
              'Please check back later or contact support.',
              textAlign: TextAlign.center,
              style: AppTextStyles.regular(14).copyWith(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
