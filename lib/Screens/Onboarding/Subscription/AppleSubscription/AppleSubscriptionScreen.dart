import 'package:avionics_internal/bloc/Subscription/iosFolder/AppleSubscriptionCubit.dart';
import 'package:avionics_internal/bloc/Subscription/iosFolder/AppleSubscriptionState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class AppleSubscriptionScreen extends StatelessWidget {
  const AppleSubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AppleSubscriptionCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Start Subscription'),
          centerTitle: true,
        ),
        body: BlocBuilder<AppleSubscriptionCubit, AppleSubscriptionState>(
          builder: (context, state) {
            if (state.error != null) {
              return Center(child: Text(state.error!));
            }

            final products = state.products;

            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  const Icon(Icons.airplanemode_active, size: 48),
                  const Text(
                    "avioflAI",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  const _FeatureRow(
                    icon: Icons.star,
                    text: "Save your Favorites Aircrafts",
                  ),
                  const _FeatureRow(
                    icon: Icons.compare,
                    text: "Compare planes",
                  ),
                  const _FeatureRow(
                    icon: Icons.track_changes,
                    text: "Track the aircrafts",
                  ),
                  const SizedBox(height: 24),
                  ...products.map(
                    (product) => _SubscriptionCard(
                      product: product,
                      selected: product == state.selectedProduct,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: state.selectedProduct != null
                        ? () => context.read<AppleSubscriptionCubit>().buySelected()
                        : null,
                    child: const Text("Go Premium"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3F3D51),
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(48),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Free for 7 days then 80 EURO per year.\nCancel anytime.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _FeatureRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [Icon(icon, size: 20), const SizedBox(width: 8), Text(text)],
      ),
    );
  }
}

class _SubscriptionCard extends StatelessWidget {
  final ProductDetails product;
  final bool selected;

  const _SubscriptionCard({required this.product, required this.selected});

  String getTrialInfo(String description) {
    if (description.toLowerCase().contains('7 days'))
      return "+ 7 days free trial";
    return "";
  }

  @override
  Widget build(BuildContext context) {
    final trial = getTrialInfo(product.description);
    return GestureDetector(
      onTap: () => context.read<AppleSubscriptionCubit>().selectPlan(product),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          border: Border.all(
            color: selected ? Colors.deepPurple : Colors.grey.shade300,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  if (trial.isNotEmpty)
                    Text(trial, style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            Text(product.price, style: const TextStyle(fontSize: 16)),
            if (selected)
              const Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Icon(Icons.check_circle, color: Colors.deepPurple),
              ),
          ],
        ),
      ),
    );
  }
}
