import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../Constants/ApiClass/FirebaseAnalytics/analytics_service.dart';
import '../../../Constants/ApiClass/FirebaseAnalytics/event_names.dart';
import '../../../Constants/ConstantStrings.dart';
import '../../../CustomFiles/CustomAppBar.dart';
import '../../../bloc/Profile/ManageAccount/manageAcc_cubit.dart';
import '../../../bloc/Profile/ManageAccount/manageAcc_state.dart';

class CreditsTokenUsageScreen extends StatefulWidget {
  const CreditsTokenUsageScreen({super.key});

  @override
  State<CreditsTokenUsageScreen> createState() => _CreditsTokenUsageState();
}

class _CreditsTokenUsageState extends State<CreditsTokenUsageScreen> {
  late final WebViewController controller;

  String urlForWebView = "";

  double tokenUsagePercentage = 0.0;
  double creditUsagePercentage = 0.0;

  @override
  void initState() {
    super.initState();
    AnalyticsService.instance.logVisibleScreen(
      FirebaseEvents.creditTokenScreen,
    );

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ManageaccCubit()..fetchUserDetails(context),
      child: BlocConsumer<ManageaccCubit, ManageAccState>(
        listener: (context, state) {
          if (!state.isLoading) {
            tokenUsagePercentage = state.tokenUsagePercentage ?? 0.0;
            creditUsagePercentage = state.creditUsagePercentage ?? 0.0;
            final url =
                "https://avionica.csdevhub.com/user-service/user/usage-meter"
                "?credit_usage=$creditUsagePercentage&token_usage=$tokenUsagePercentage";
            controller.loadRequest(Uri.parse(url));
          }
        },
        builder: (context, state) {
          if (state.isLoading) {
            return const Scaffold(
              backgroundColor: Colors.white,
              body: Center(child: CircularProgressIndicator()),
            );
          }

          return Scaffold(
            appBar: CustomAppBar(
              title: ConstantStrings.creditTokenTitle,
              isForComparison: true,
              centerTitle: false,
              leftButton: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: WebViewWidget(controller: controller),
          );
        },
      ),
    );
  }
}
