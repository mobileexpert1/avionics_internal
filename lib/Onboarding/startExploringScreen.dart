import 'package:avionics_internal/Constants/OnboardingTexts.dart';
import 'package:flutter/material.dart';
import '../Constants/AppColors.dart';
import '../Constants/constantImages.dart';
import '../CustomFiles/CustomBottomButton.dart';
import 'LoginScreen.dart';
import 'SignupScreen.dart';

void main() {
  runApp(StartExploringApp());
}

class StartExploringApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: OnboardingTexts.exploring,
      home: StartExploringScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class StartExploringScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
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
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
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
                      const Text(
                       OnboardingTexts.exploring,
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1C1733),
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: CustomBottomButton(
                          title: OnboardingTexts.CreateAccount,
                          backgroundColor: const Color(0xFF1C1733),
                          textColor: Colors.white,
                          icon: const SizedBox(width: 0), // No icon shown
                          isEnabled: true,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignupScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: const BorderSide(color: Color(0xFF1C1733)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => LoginScreen()),
                            );
                          },
                          child: const Text(
                            OnboardingTexts.loginButton,
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.LoginTxt,
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
    );
  }
}
