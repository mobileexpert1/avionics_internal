import 'package:avionics_internal/Constants/constantImages.dart';
import 'package:avionics_internal/CustomFiles/CustomBottomButton.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../Constants/AppColors.dart';
import '../../../../Constants/ConstantStrings.dart';
import '../../../../CustomFiles/CustomAppBar.dart';
import '../../../../bloc/Home/AircraftComparison/AircraftComparisonCubit.dart';
import '../../../../bloc/Home/AircraftComparison/AircraftComparisonModel.dart';
import '../../../../bloc/Home/AircraftComparison/Comparison/Filtter/filtter_cubit.dart';
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
  }

  void _navigateAndSelectModel(int modelNumber) async {
    final result = await Navigator.push<AircraftModel>(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => AircraftComparisonCubit(),
          child: AircraftComparisonScreen(
            selectedModel1: modelNumber == 1 ? model2?.id : model1?.id,
            selectedModel2: modelNumber == 1 ? null : model1?.id,
          ),
        ),
      ),
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

      body: Stack(
        children: [
          // Background image on top half
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: screenHeight * 0.6,
            child: SvgPicture.asset(
              CommonUi.setSvgImage(AssetsPath.backgroundImageComapre),
              fit: BoxFit.cover,
            ),
          ),

          kIsWeb
              ? Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink(),

          // Foreground UI
          SafeArea(
            child: kIsWeb
                ? Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1200),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            Column(
                              children: [
                                const SizedBox(height: 15),
                                SvgPicture.asset(
                                  CommonUi.setSvgImage(AssetsPath.compare1),
                                  width: 130,
                                ),
                                const SizedBox(height: 25),
                                const Text(
                                  "Compare every detail\nfrom engines to dimensions",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    height: 1.5,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 42),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 24,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 10,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    "Compare Aircraft Specifications",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  _buildRadioOption(
                                    "Select Model 1",
                                    model1,
                                    () => _navigateAndSelectModel(1),
                                  ),
                                  const Divider(height: 1),
                                  _buildRadioOption(
                                    "Select Model 2",
                                    model2,
                                    () => _navigateAndSelectModel(2),
                                  ),
                                  const SizedBox(height: 24),
                                  CustomBottomButton(
                                    title: ConstantStrings.compare,
                                    backgroundColor: isButtonEnabled
                                        ? AppColors.customBottomEnabledColour
                                        : AppColors.customBottomDisableColour,
                                    textColor: Colors.white,
                                    icon: const SizedBox(width: 0),
                                    isEnabled: isButtonEnabled,
                                    onPressed: () {
                                      if (!isButtonEnabled) return;
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => BlocProvider(
                                            create: (_) =>
                                                ComparisonFilterCubit1(),
                                            child: ComparisonScreen(
                                              model1: model1!.id,
                                              model2: model2!.id,
                                              model1Name: model1!.aircraftModel,
                                              model2Name: model2!.aircraftModel,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                    ),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        SvgPicture.asset(
                          CommonUi.setSvgImage(AssetsPath.compare1),
                          width: 130,
                        ),
                        const SizedBox(height: 25),
                        const Text(
                          "Compare every detail\nfrom engines to dimensions",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            height: 1.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 42),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 24,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                "Compare Aircraft Specifications",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 20),
                              _buildRadioOption(
                                "Select Model 1",
                                model1,
                                () => _navigateAndSelectModel(1),
                              ),
                              const Divider(height: 1),
                              _buildRadioOption(
                                "Select Model 2",
                                model2,
                                () => _navigateAndSelectModel(2),
                              ),
                              const SizedBox(height: 24),
                              CustomBottomButton(
                                title: ConstantStrings.compare,
                                backgroundColor: isButtonEnabled
                                    ? AppColors.customBottomEnabledColour
                                    : AppColors.customBottomDisableColour,
                                textColor: Colors.white,
                                icon: const SizedBox(width: 0),
                                isEnabled: isButtonEnabled,
                                onPressed: () {
                                  if (!isButtonEnabled) return;
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => BlocProvider(
                                        create: (_) => ComparisonFilterCubit1(),
                                        child: ComparisonScreen(
                                          model1: model1!.id,
                                          model2: model2!.id,
                                          model1Name: model1!.aircraftModel,
                                          model2Name: model2!.aircraftModel,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
          ),
        ],
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
