import 'package:avionics_internal/Constants/constantImages.dart';
import 'package:avionics_internal/CustomFiles/CustomBottomButton.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../Constants/ApiClass/FirebaseAnalytics/analytics_service.dart';
import '../../../../Constants/ApiClass/FirebaseAnalytics/event_names.dart';
import '../../../../Constants/AppColors.dart';
import '../../../../Constants/ConstantStrings.dart';
import '../../../../Helpers/AppNavigator.dart';
import '../../../../Helpers/AppTextStyles/AppTextStyles.dart';
import '../../../../bloc/Home/AircraftComparison/AircraftComparisonCubit.dart';
import '../../../../bloc/Home/AircraftComparison/AircraftComparisonModel.dart';
import '../../../../bloc/home/AircraftComparison/Comparison/Filter/ComparisonFilterCubit.dart';
import '../AirCraftModelComparison/SeeComparison/ComparisonScreen.dart';
import 'AircraftComparisonScreen.dart';

class SelectModelCompareScreen extends StatefulWidget {
  final String? model1;
  final String? model2;

  const SelectModelCompareScreen({super.key, this.model1, this.model2});

  @override
  State<SelectModelCompareScreen> createState() =>
      _SelectModelCompareScreenState();
}

class _SelectModelCompareScreenState extends State<SelectModelCompareScreen> {
  AircraftModel? model1;
  AircraftModel? model2;

  bool get isButtonEnabled => model1 != null && model2 != null;

  @override
  void initState() {
    super.initState();
    AnalyticsService.instance.logVisibleScreen(
      FirebaseEvents.modelCompareScreen,
    );
  }

  void _navigateAndSelectModel(int modelNumber) async {
    AnalyticsService.instance.buttonPressed(
      FirebaseEvents.aircraftComparisonScreen,
      FirebaseEvents.comparisonScreen,
    );

    final result = await AppNavigator.push<AircraftModel>(
      context,
      AircraftComparisonScreen(
        selectedModel1: modelNumber == 1 ? model2?.id : model1?.id,
        selectedModel2: modelNumber == 1 ? null : model1?.id,
      ),
      multiBlocProviders: [
        BlocProvider(create: (_) => AircraftComparisonCubit()),
      ],
      disableSwipeBack: true,
    );

    if (result != null) {
      setState(() {
        if (modelNumber == 1) {
          model1 = result;
        } else {
          model2 = result;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primaryValueColour,
        elevation: 0,
        leading: IconButton(
          icon: SvgPicture.asset(
            CommonUi.setSvgImage(AssetsPath.backArrowButton),
            fit: BoxFit.cover,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: screenHeight * 0.5,
            child: Container(color: AppColors.primaryValueColour),
          ),
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: kIsWeb ? 850 : double.infinity,
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      Transform.translate(
                        offset: Offset(0, kIsWeb ? 0 : -30),
                        child: SvgPicture.asset(
                          CommonUi.setSvgImage(AssetsPath.compareLogo),
                          width: kIsWeb ? 120 : 90,
                        ),
                      ),
                      const SizedBox(height: kIsWeb ? 20 : 4),

                      Text(
                        "Compare every detail\nfrom engines to dimensions",
                        textAlign: TextAlign.center,
                        style: AppTextStyles.semiBold(kIsWeb ? 24 : 19.37)
                            .copyWith(
                              height: 1.0,
                              color: AppColors.white,
                              letterSpacing: 0.02 * 19,
                            ),
                      ),

                      SizedBox(height: kIsWeb ? 60 : 50),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 24,
                        ),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Compare Aircraft Specifications",
                              style: AppTextStyles.bold(
                                kIsWeb ? 22 : 18,
                              ).copyWith(height: 1.0, color: AppColors.black),
                            ),

                            const SizedBox(height: 20),

                            _buildCardOption(
                              title: "Primary Model",
                              hint: "Select first model",
                              value: model1,
                              onTap: () => _navigateAndSelectModel(1),
                              onClear: () {
                                setState(() => model1 = null);
                              },
                            ),

                            const SizedBox(height: 12),

                            Row(
                              children: [
                                const Expanded(child: Divider(thickness: 0.5)),
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.swap_horiz_outlined,
                                    size: 16,
                                  ),
                                ),
                                const Expanded(child: Divider(thickness: 0.5)),
                              ],
                            ),

                            const SizedBox(height: 12),

                            _buildCardOption(
                              title: "Comparison Model",
                              hint: "Select second model",
                              value: model2,
                              onTap: () => _navigateAndSelectModel(2),
                              onClear: () {
                                setState(() => model2 = null);
                              },
                            ),

                            const SizedBox(height: 15),
                          ],
                        ),
                      ),

                      CustomBottomButton(
                        fontStyle: AppTextStyles.regular(kIsWeb ? 18 : 16)
                            .copyWith(
                              height: 1.0,
                              color: isButtonEnabled
                                  ? Colors.white
                                  : Colors.grey.shade600,
                            ),
                        isComeFromCompare: true,
                        title: ConstantStrings.compare,
                        backgroundColor: isButtonEnabled
                            ? AppColors.primaryValueColour
                            : AppColors.darkSeparatorColourAppBar,
                        textColor: Colors.white,
                        icon: const SizedBox(),
                        isEnabled: isButtonEnabled,
                        onPressed: () {
                          if (!isButtonEnabled) return;

                          AnalyticsService.instance.buttonPressed(
                            FirebaseEvents.comparedbuttons,
                            FirebaseEvents.modelCompareScreen,
                          );

                          AppNavigator.push(
                            context,
                            ComparisonScreen(
                              model1: model1!.id,
                              model2: model2!.id,
                              model1Name: model1!.aircraftModel,
                              model2Name: model2!.aircraftModel,
                            ),
                            multiBlocProviders: [
                              BlocProvider(
                                create: (_) => ComparisonFilterCubit1(),
                              ),
                            ],
                            disableSwipeBack: true,
                          );
                        },
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardOption({
    required String title,
    required String hint,
    required AircraftModel? value,
    required VoidCallback onTap,
    required VoidCallback onClear,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(7),
                child: SvgPicture.asset(
                  CommonUi.setSvgImage(AssetsPath.compareAeroPlaneIcon),
                ),
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.medium(
                      14,
                    ).copyWith(height: 1.0, color: AppColors.grayMedium),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    value?.aircraftModel ?? hint,
                    style: AppTextStyles.bold(14).copyWith(
                      height: 1.0,
                      color: AppColors.primaryValueColour,
                    ),
                  ),
                ],
              ),
            ),

            if (value != null)
              GestureDetector(
                onTap: onClear,
                child: const Icon(Icons.close, color: Colors.grey),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRadioOption(
    String text,
    AircraftModel? value,
    VoidCallback onTap,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.radio_button_unchecked, color: Colors.blue),
      title: Text(
        value?.aircraftModel ?? text,
        style: const TextStyle(fontSize: 14),
      ),
      onTap: onTap,
      trailing: value != null
          ? IconButton(
              icon: const Icon(Icons.close_rounded, color: Colors.grey),
              onPressed: () {
                setState(() {
                  if (text.contains("1")) {
                    model1 = null;
                  } else if (text.contains("2")) {
                    model2 = null;
                  }
                });
              },
            )
          : null,
    );
  }
}
