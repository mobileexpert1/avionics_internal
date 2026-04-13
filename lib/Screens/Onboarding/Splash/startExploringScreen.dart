import 'package:avionics_internal/Constants/ConstantStrings.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import '../../../Constants/ApiClass/FirebaseAnalytics/analytics_service.dart';
import '../../../Constants/ApiClass/FirebaseAnalytics/event_names.dart';
import '../../../Constants/AppColors.dart';
import '../../../Constants/constantImages.dart';
import '../Login/LoginScreen.dart';
import '../Signup/SignupScreen.dart';

void main() {
  runApp(const StartExploringApp());
}

class StartExploringApp extends StatelessWidget {
  const StartExploringApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: ConstantStrings.exploring,
      debugShowCheckedModeBanner: false,
      home: const StartExploringScreen(),
    );
  }
}

class StartExploringScreen extends StatefulWidget {
  const StartExploringScreen({super.key});

  @override
  State<StartExploringScreen> createState() => _StartExploringScreenState();
}

class _StartExploringScreenState extends State<StartExploringScreen> {
  @override
  void initState() {
    super.initState();
    AnalyticsService.instance.logVisibleScreen(
      FirebaseEvents.startExploringScreen,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    double logoWidth = screenWidth * 0.4;
    double textFontSize = screenWidth < 360
        ? 24
        : screenWidth < 600
        ? 28
        : 35;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ConstrainedBox(
          constraints: kIsWeb
              ? const BoxConstraints(maxWidth: 1500)
              : const BoxConstraints(),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final double buttonWidth = kIsWeb
                  ? constraints.maxWidth * 0.5
                  : double.infinity;

              return Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: constraints.maxHeight * 0.6,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                      child: Image.asset(
                        CommonUi.setjpgImage(AssetsPath.explore),
                        width: logoWidth,
                        fit: kIsWeb ? BoxFit.fitWidth : BoxFit.cover,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 32,
                      ),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(32),
                          topRight: Radius.circular(32),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            ConstantStrings.exploring,
                            style: TextStyle(
                              fontSize: textFontSize,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF1C1733),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // --- Create Account Button ---
                          SizedBox(
                            width: buttonWidth,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                backgroundColor: AppColors.primaryDark,
                                side: const BorderSide(
                                  color: Color(0xFF1C1733),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () {
                                if (!mounted) return;
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => SignupScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                ConstantStrings.CreateAccount,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 12),

                          // --- Login Button ---
                          SizedBox(
                            width: buttonWidth,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 15,
                                ),
                                side: const BorderSide(
                                  color: Color(0xFF1C1733),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () {
                                if (!mounted) return;
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const LoginScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                ConstantStrings.loginButton,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.loginTxt,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
