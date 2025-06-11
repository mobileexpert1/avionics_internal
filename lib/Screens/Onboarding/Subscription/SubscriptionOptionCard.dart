import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../Constants/constantImages.dart';
import '../../../bloc/Subscription/subscription_cubit.dart';
import '../../../bloc/Subscription/subscription_model.dart';

class SubscriptionOptionCard extends StatelessWidget {
  final SubscriptionPlanModel plan;
  final bool isSelected;

  const SubscriptionOptionCard({
    Key? key,
    required this.plan,
    required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.read<SubscriptionCubit>().selectOption(plan),
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.black : Colors.grey,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            /// Title and Subtitle
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  plan.isYearly ? "1 Year Plan" : "1 Month Plan",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "${plan.trial}-Day Free Trial",
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
                  ),
                ),
              ],
            ),

            /// Price and Tick Icon
            Row(
              children: [
                Text(
                  "\$${plan.price}",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(width: 10),
                if (isSelected)
                  SvgPicture.asset(
                    CommonUi.setSvgImage(AssetsPath.tickIcon),
                    fit: BoxFit.fill,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
