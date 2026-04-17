import 'package:flutter/material.dart';
import '../../../Constants/AppColors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Constants/constantImages.dart';
import '../../../Helpers/AppTextStyles/AppTextStyles.dart';
import '../../Onboarding/Login/LoginScreen.dart';
import '../../../CustomFiles/CustomBottomButton.dart';
import '../../../bloc/Profile/Avtar/avtar_cubit.dart';
import '../../../bloc/Profile/Avtar/avtar_state.dart';
import 'package:avionics_internal/CustomFiles/CustomAppBar.dart';
import 'package:avionics_internal/Constants/ConstantStrings.dart';
import '../../../Constants/ApiClass/FirebaseAnalytics/event_names.dart';
import 'package:avionics_internal/Constants/ApiClass/ApiErrorModel.dart';
import '../../../Constants/ApiClass/FirebaseAnalytics/analytics_service.dart';

class AvtarScreen extends StatefulWidget {
  final bool isComeFromSignupScreen;
  final Map<String, String> signupData;
  final bool isComeFromSocialLogin;

  const AvtarScreen({
    Key? key,
    required this.isComeFromSignupScreen,
    required this.signupData,
    this.isComeFromSocialLogin = false,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AvtarScreenState();
}

class _AvtarScreenState extends State<AvtarScreen> {

  @override
  void initState() {
    super.initState();
    context.read<AvtarCubit>().loadAvatars(
      widget.isComeFromSignupScreen,
      widget.isComeFromSocialLogin,
    );
    AnalyticsService.instance.logVisibleScreen(FirebaseEvents.avtarScreen);
  }

  @override
  Widget build(BuildContext context) {
    double maxWidth = MediaQuery.of(context).size.width > 1500
        ? 1500
        : MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: ConstantStrings.avtarTitle,
        leftButton: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => (widget.isComeFromSocialLogin == true
              ? Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => LoginScreen()),
                  (route) => false,
                )
              : Navigator.pop(context)),
        ),
      ),
      body: BlocConsumer<AvtarCubit, AvtarState>(
        listener: (context, state) {
          if (state.status == CommonApiStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Failed to select avatar'),
              ),
            );
            context.read<AvtarCubit>().resetStatus();
          } else if (state.status == CommonApiStatus.initial) {
            Scaffold(
              backgroundColor: Colors.white,
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (state.avatars.isEmpty) {
            Center(child: Text('No avatars found'));
          }
        },
        builder: (context, state) {
          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 20,
                ),
                itemCount: state.avatars.length,
                separatorBuilder: (context, index) => const Divider(
                  height: 0.1,
                  color: Colors.grey,
                  thickness: 0.1,
                ),
                itemBuilder: (context, index) {
                  final userType = state.avatars[index];
                  final isSelected = state.selectedUserType == userType.key;

                  return GestureDetector(
                    onTap: () {
                      final cubit = context.read<AvtarCubit>();
                      if (widget.isComeFromSignupScreen ||
                          widget.isComeFromSocialLogin) {
                        cubit.selectAvatarTypeOnly(userType.key);
                      } else {
                        cubit.selectAvatar(
                          userType.key,
                          widget.isComeFromSignupScreen,
                          widget.isComeFromSocialLogin,
                          context,
                          {},
                        );
                      }
                      AnalyticsService.instance.buttonPressed(
                        FirebaseEvents.avtarScreen,
                        FirebaseEvents.updatedAvtarButtonTap,
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 20,
                      ),
                      child: Card(
                        color: Colors.white,
                        elevation: 0,
                        margin: EdgeInsets.zero,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 10,
                          ),
                          child: Row(
                            children: [
                              (userType.logo.isNotEmpty)
                                  ? SvgPicture.network(
                                      userType.logo,
                                      width: 44,
                                      height: 44,
                                      fit: BoxFit.contain,
                                      placeholderBuilder: (context) =>
                                          const SizedBox(
                                            width: 24,
                                            height: 24,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                            ),
                                          ),
                                    )
                                  : SvgPicture.asset(
                                      CommonUi.setSvgImage(
                                        AssetsPath.avtarSecond,
                                      ),
                                      width: 44,
                                      height: 44,
                                      fit: BoxFit.contain,
                                    ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  userType.name,
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              if (isSelected)
                                const Icon(
                                  Icons.check,
                                  size: 25,
                                  color: Colors.blue,
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
      bottomNavigationBar:
          (widget.isComeFromSignupScreen || widget.isComeFromSocialLogin)
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 20,
                ),
                child: BlocSelector<AvtarCubit, AvtarState, bool>(
                  selector: (state) =>
                      state.selectedUserType != null &&
                      state.selectedUserType!.isNotEmpty,
                  builder: (context, isButtonEnabled) {
                    return CustomBottomButton(
                      fontStyle: AppTextStyles.regular(21.46).copyWith(
                        height: 1.0,
                        color: isButtonEnabled
                            ? Colors.white
                            : Colors.grey.shade600,
                      ),
                      title: ConstantStrings.submitTitle,
                      backgroundColor: AppColors.customBottomEnabledColour,
                      textColor: Colors.white,
                      icon: const SizedBox(width: 0),
                      isEnabled: isButtonEnabled,
                      onPressed: () {
                        final selectedUserType =
                            context.read<AvtarCubit>().state.selectedUserType ??
                            '';
                        context.read<AvtarCubit>().selectAvatar(
                          selectedUserType,
                          widget.isComeFromSignupScreen,
                          widget.isComeFromSocialLogin,
                          context,
                          widget.signupData,
                        );
                      },
                    );
                  },
                ),
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
