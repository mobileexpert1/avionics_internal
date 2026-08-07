import 'package:avionics_internal/Screens/Profile/SettingScreen/SettingMenuScreen/3_AddOnPacks/AddOnPacksScreen.dart';
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
import '../../../../../Helpers/WebAndMobileBrowser/web_iframe_widget.dart';
import '../../../../../bloc/Profile/ManageAccount/manageAcc_cubit.dart';
import '../../../../../bloc/Profile/ManageAccount/manageAcc_state.dart';

class JettingAroundTheBoardingPass extends StatefulWidget {
  const JettingAroundTheBoardingPass({super.key});

  @override
  State<JettingAroundTheBoardingPass> createState() =>
      _JettingAroundTheBoardingState();
}

class _JettingAroundTheBoardingState
    extends State<JettingAroundTheBoardingPass> {
  WebViewController? controller;

  String currentUserId = "";
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
        ..enableZoom(false)
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..addJavaScriptChannel(
          'Flutter',
          onMessageReceived: (JavaScriptMessage message) async {},
        );
    }
  }

  Future<void> openAddOnPacksBottomSheet() async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return FractionallySizedBox(
          heightFactor: 0.70,
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: const AddOnPacksScreen(packType: AddOnPackType.both),
          ),
        );
      },
    );

    if (result == true && mounted) {
      setState(() {
        final url = _buildUrl();

        if (kIsWeb) {
          setState(() => _webUrl = url);
        } else {
          controller!.loadRequest(Uri.parse(url));
        }
      });
    }
  }

  String _buildUrl() {
    return "https://avionica.csdevhub.com/user-service/ticket?username=$currentUserId";
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ManageaccCubit()..fetchUserDetails(context),
      child: BlocConsumer<ManageaccCubit, ManageAccState>(
        listener: (context, state) async {
          if (!state.isLoading) {
            currentUserId = state.userId ?? "";
            tokenUsagePercentage = state.tokenUsagePercentage ?? 0.0;
            creditUsagePercentage = state.creditUsagePercentage ?? 0.0;
            if (currentUserId != "") {
              final url = _buildUrl();
              print(url);
              if (kIsWeb) {
                setState(() => _webUrl = url);
              } else {
                controller!.loadRequest(Uri.parse(url));
              }
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
              title: ConstantStrings.airlineTicketTitle,
              isForComparison: true,
              centerTitle: false,
              leftButton: IconButton(
                icon: SvgPicture.asset(
                  CommonUi.setSvgImage(AssetsPath.backArrowButton),
                  fit: BoxFit.cover,
                ),
                onPressed: () => Navigator.pop(context, true),
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
