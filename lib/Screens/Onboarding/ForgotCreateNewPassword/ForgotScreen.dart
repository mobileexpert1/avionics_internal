import 'package:avionics_internal/Constants/AppColors.dart';
import 'package:avionics_internal/Constants/ConstantStrings.dart';
import 'package:avionics_internal/CustomFiles/CustomAppBar.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Constants/ApiClass/ApiErrorModel.dart';
import '../../../Constants/ApiClass/FirebaseAnalytics/analytics_service.dart';
import '../../../Constants/ApiClass/FirebaseAnalytics/event_names.dart';
import '../../../Constants/constantImages.dart';
import '../../../CustomFiles/CustomBottomButton.dart';
import '../../../CustomFiles/CustomTextField.dart';
import '../../../bloc/Onboarding/forgotPassword/forgot_cubit.dart';
import '../../../bloc/Onboarding/forgotPassword/forgot_state.dart';

class ForgotScreen extends StatefulWidget {
  const ForgotScreen({super.key});

  @override
  State<ForgotScreen> createState() => _ForgotScreenState();
}

class _ForgotScreenState extends State<ForgotScreen> {
  final TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    AnalyticsService.instance.logVisibleScreen(FirebaseEvents.forgotScreen);
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWeb = kIsWeb;

    // --- Responsive sizes ---
    final logoWidth = isWeb ? 120.0 : screenWidth * 0.4;
    final topPadding = isWeb ? 20.0 : 40.0;
    final spacingAfterLogo = isWeb ? 20.0 : 40.0;
    final contentMaxWidth = isWeb ? 420.0 : double.infinity;
    final buttonWidth = isWeb ? 280.0 : double.infinity;

    return BlocProvider(
      create: (_) => ForgotCubit(),
      child: BlocConsumer<ForgotCubit, ForgotState>(
        listenWhen: (prev, curr) => prev.status != curr.status,
        listener: (context, state) {
          if (!mounted) return;


          if (state.status == CommonApiStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Forgot email failed'),
              ),
            );
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              Scaffold(
                backgroundColor: Colors.white,
                appBar: CustomAppBar(
                  isClearBackgroundColour: true,
                  title: ConstantStrings.appBarTitleForgotPwd,
                  leftButton: IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
                    onPressed: () {
                      if (!mounted) return;
                      Navigator.pop(context);
                    },
                  ),
                ),
                body: Align(
                  alignment: Alignment.topCenter,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: contentMaxWidth),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: topPadding,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              CommonUi.setSvgImage(AssetsPath.mainLogo),
                              width: logoWidth,
                              fit: BoxFit.contain,
                            ),

                            SizedBox(height: spacingAfterLogo),

                            // -------- Email --------
                            BlocSelector<ForgotCubit, ForgotState, String?>(
                              selector: (state) => state.emailError,
                              builder: (context, emailError) {
                                return CustomTextField(
                                  label: ConstantStrings.emailLabel,
                                  controller: emailController,
                                  errorText: emailError,
                                  onChanged: (val) => context
                                      .read<ForgotCubit>()
                                      .emailChanged(val),
                                );
                              },
                            ),

                            const SizedBox(height: 30),

                            // -------- Submit Button --------
                            BlocSelector<ForgotCubit, ForgotState, bool>(
                              selector: (state) => state.isButtonEnabled,
                              builder: (context, isButtonEnabled) {
                                return SizedBox(
                                  width: buttonWidth,
                                  child: CustomBottomButton(
                                    title: ConstantStrings.sendEmailButton,
                                    backgroundColor: isButtonEnabled
                                        ? AppColors.primaryValueColour
                                        : AppColors.darkSeparatorColourAppBar,
                                    textColor: Colors.white,
                                    icon: const SizedBox.shrink(),
                                    isEnabled: isButtonEnabled,
                                    onPressed: () {
                                      if (!mounted) return;
                                      context
                                          .read<ForgotCubit>()
                                          .validateAndSubmit(context);
                                    },
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // -------- Loader --------
              if (state.status == CommonApiStatus.submitting)
                Container(
                  color: Colors.black.withOpacity(0.3),
                  child: const Center(child: CircularProgressIndicator()),
                ),
            ],
          );
        },
      ),
    );
  }
}
