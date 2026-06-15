import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../../Constants/ApiClass/FirebaseAnalytics/analytics_service.dart';
import '../../../../../Constants/ApiClass/FirebaseAnalytics/event_names.dart';
import '../../../../../Constants/ConstantStrings.dart';
import '../../../../../Constants/constantImages.dart';
import '../../../../../CustomFiles/CustomAppBar.dart';
import '../../../../../Helpers/WebIframeWidget.dart';
import '../../../../../bloc/Profile/ManageAccount/manageAcc_cubit.dart';
import '../../../../../bloc/Profile/ManageAccount/manageAcc_state.dart';

class CreditsTokenUsageScreen extends StatefulWidget {
  const CreditsTokenUsageScreen({super.key});

  @override
  State<CreditsTokenUsageScreen> createState() => _CreditsTokenUsageState();
}

class _CreditsTokenUsageState extends State<CreditsTokenUsageScreen> {
  WebViewController? controller;

  double tokenUsagePercentage = 0.0;
  double creditUsagePercentage = 0.0;
  String _webUrl = "";

  @override
  void initState() {
    super.initState();
    AnalyticsService.instance.logVisibleScreen(
      FirebaseEvents.creditTokenScreen,
    );

    if (!kIsWeb) {
      controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted);
    }
  }

  String _buildUrl() {
    return "${ApiBaseUrlConstant.baseUrl}${ApiFunctionUrlConstant.userService}user/usage-meter"
        "?credit_usage=$creditUsagePercentage&token_usage=$tokenUsagePercentage";
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ManageaccCubit()..fetchUserDetails(context),
      child: BlocConsumer<ManageaccCubit, ManageAccState>(
        listener: (context, state) async {
          if (!state.isLoading) {
            tokenUsagePercentage = state.tokenUsagePercentage ?? 0.0;
            creditUsagePercentage = state.creditUsagePercentage ?? 0.0;
            final url = _buildUrl();

            if (kIsWeb) {
              setState(() => _webUrl = url);
            } else {
              controller!.loadRequest(Uri.parse(url));
            }
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
            backgroundColor: Colors.white,
            appBar: CustomAppBar(
              title: ConstantStrings.creditTokenTitle,
              isForComparison: true,
              centerTitle: false,
              leftButton: IconButton(
                icon: SvgPicture.asset(
                  CommonUi.setSvgImage(AssetsPath.backArrowButton),
                  fit: BoxFit.cover,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: kIsWeb
                ? _webUrl.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : WebIframeWidget(url: _webUrl)
                : WebViewWidget(controller: controller!),
          );
        },
      ),
    );
  }
}
