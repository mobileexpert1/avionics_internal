// import 'dart:ui_web' as ui;
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:universal_html/html.dart' as html;
//
// import '../../../../Constants/ConstantStrings.dart';
// import '../../../../CustomFiles/CustomAppBar.dart';
//
// class WebSubscriptionScreen extends StatefulWidget {
//   final bool? isComeFromSignup;
//   final bool? isComeFromSocialLogin;
//
//   const WebSubscriptionScreen(
//     this.isComeFromSignup,
//     this.isComeFromSocialLogin, {
//     super.key,
//   });
//
//   @override
//   State<WebSubscriptionScreen> createState() => _WebSubscriptionScreenState();
// }
//
// class _WebSubscriptionScreenState extends State<WebSubscriptionScreen> {
//   final String viewType = 'web-subscription-iframe';
//   bool _isRegistered = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _initIframe(); // <-- call async method here, WITHOUT await
//   }
//
//   // Get bearer token from SharedPreferences
//   static Future<String?> _getBearerToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString('UserAccessTokenKey');
//   }
//
//   // Async method to get token and register iframe
//   Future<void> _initIframe() async {
//     final token = await _getBearerToken();
//     if (token != null) {
//       _registerIframe(
//         "https://avionica.csdevhub.com/user-service/subscription/choose/$token",
//       );
//       print(
//         "https://avionica.csdevhub.com/user-service/subscription/choose/$token",
//       );
//       setState(() {}); // rebuild to display iframe
//     }
//   }
//
//   void _registerIframe(String subsUrl) {
//     if (!_isRegistered) {
//       // Register the iframe view
//       ui.platformViewRegistry.registerViewFactory(viewType, (int viewId) {
//         final iframe = html.IFrameElement()
//           ..src = subsUrl
//           ..style.border = 'none'
//           ..style.width = '100%'
//           ..style.height = '100%'
//           ..allow = 'payment *';
//         iframe.onLoad.listen((event) {
//           print("Iframe has finished loading!");
//           // You can call any Flutter callback here
//         });
//         return iframe;
//       });
//       _isRegistered = true;
//     }
//     html.window.onMessage.listen((event) {
//       print("Message from iframe: ${event.data}");
//       // handle event.data
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: CustomAppBar(
//         title:
//             (widget.isComeFromSignup == false ||
//                 widget.isComeFromSignup == null)
//             ? SubscriptionTexts.currentSubTitle
//             : ConstantStrings.startSubscription,
//         leftButton:
//             (widget.isComeFromSignup == false ||
//                 widget.isComeFromSignup == null)
//             ? IconButton(
//                 icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//               )
//             : Wrap(),
//       ),
//       body: _isRegistered
//           ? const HtmlElementView(viewType: 'web-subscription-iframe')
//           : const Center(child: CupertinoActivityIndicator(radius: 15)),
//     );
//   }
// }
