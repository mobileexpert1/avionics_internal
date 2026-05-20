import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../Constants/ApiClass/FirebaseAnalytics/analytics_service.dart';
import '../../../Constants/ApiClass/FirebaseAnalytics/event_names.dart';
import '../../../Constants/ConstantStrings.dart';
import '../../../Constants/constantImages.dart';
import '../../../CustomFiles/CustomAppBar.dart';
import '../../../bloc/Profile/ManageAccount/manageAcc_cubit.dart';
import '../../../bloc/Profile/ManageAccount/manageAcc_state.dart';

class AboutTermsPrivacyScreen extends StatefulWidget {
  final int urlForRequest;

  const AboutTermsPrivacyScreen({super.key, required this.urlForRequest});

  @override
  State<AboutTermsPrivacyScreen> createState() => _AboutTermsPrivacyState();
}

class _AboutTermsPrivacyState extends State<AboutTermsPrivacyScreen> {
  late final WebViewController controller;

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

  static String getUrlAccordingToRequest(int forUrlRequest) {
    switch (forUrlRequest) {
      case 0:
        return UrlConstantForPrivacyTermsAbout.privacyUrl;
      case 1:
        return UrlConstantForPrivacyTermsAbout.termsUrl;
      case 2:
        return UrlConstantForPrivacyTermsAbout.aboutUrl;
      default:
        return UrlConstantForPrivacyTermsAbout.faqUrl;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ManageaccCubit()..fetchUserDetails(context),
      child: BlocConsumer<ManageaccCubit, ManageAccState>(
        listener: (context, state) {
          if (!state.isLoading) {
            controller.loadRequest(
              Uri.parse(getUrlAccordingToRequest(widget.urlForRequest)),
            );
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
              title: (widget.urlForRequest == 0
                  ? "Privacy Policy"
                  : (widget.urlForRequest == 1
                        ? "Terms & Conditions"
                        : (widget.urlForRequest == 2 ? "About Us" : "FAQ"))),
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
            body: WebViewWidget(controller: controller),
          );
        },
      ),
    );
  }
}
