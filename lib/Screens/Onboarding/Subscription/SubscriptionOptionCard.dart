import 'package:avionics_internal/Constants/AppColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../Constants/constantImages.dart';
import '../../../bloc/Onboarding/Subscription/subscription_cubit.dart';
import '../../../bloc/Onboarding/Subscription/subscription_list_model.dart';

class SubscriptionOptionCard extends StatelessWidget {
  final SubscriptionItemModel item;
  final bool isSelected;

  const SubscriptionOptionCard({
    Key? key,
    required this.item,
    required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.read<SubscriptionCubit>().selectOption(item),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: isSelected ? Colors.black : AppColors.sepratorColourAppBar,
            width: 1.2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${item.duration} ${item.isYearly ? 'Year' : 'Month'}",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  " + ${item.trial} day free trial",
                  style: const TextStyle(color: Colors.black87, fontSize: 14),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  "${item.price.toStringAsFixed(2)} EURO",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
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
