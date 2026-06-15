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

class AboutTermsPrivacyScreen extends StatefulWidget {
  final int urlForRequest;

  const AboutTermsPrivacyScreen({super.key, required this.urlForRequest});

  @override
  State<AboutTermsPrivacyScreen> createState() => _AboutTermsPrivacyState();
}

class _AboutTermsPrivacyState extends State<AboutTermsPrivacyScreen> {
  WebViewController? controller;
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

  String get _appBarTitle {
    switch (widget.urlForRequest) {
      case 0:
        return "Privacy Policy";
      case 1:
        return "Terms & Conditions";
      case 2:
        return "About Us";
      default:
        return "FAQ";
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ManageaccCubit()..fetchUserDetails(context),
      child: BlocConsumer<ManageaccCubit, ManageAccState>(
        listener: (context, state) {
          if (!state.isLoading) {
            final url = getUrlAccordingToRequest(widget.urlForRequest);

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
              title: _appBarTitle,
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