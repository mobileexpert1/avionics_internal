import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../Constants/constantImages.dart';
import '../../../bloc/Subscription/subscription_cubit.dart';
import '../../../bloc/Subscription/subscription_state.dart';


class SubscriptionOptionCard extends StatelessWidget {
  final SubscriptionOption option;
  final String title;
  final String subtitle;
  final String price;
  final bool isSelected;

  const SubscriptionOptionCard({
    Key? key,
    required this.option,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.isSelected,
    required BuildContext context,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.read<SubscriptionCubit>().selectOption(option),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: isSelected ? Colors.black : Colors.grey,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.black87, fontSize: 14),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  price,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const SizedBox(width: 10),
                if (isSelected) // No need for '== true'
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
