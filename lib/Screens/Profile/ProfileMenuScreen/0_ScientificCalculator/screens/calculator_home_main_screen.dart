import 'package:avionics_internal/Constants/AppColors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../../../Constants/ConstantStrings.dart';
import '../../../../../Constants/constantImages.dart';
import '../../../../../CustomFiles/CustomAppBar.dart';
import '../../../../../Helpers/AppTextStyles/AppTextStyles.dart';
import '../core/index.dart';
import '../providers/calculations.dart';
import '../widgets/answer_text.dart';
import '../widgets/buttons_grid.dart';
import '../widgets/custom_animated_switcher.dart';
import '../widgets/custom_icon.dart';
import '../widgets/history_list.dart';
import '../widgets/input_feild.dart';
import '../widgets/responsive.dart';

class CalculatorHomeMainScreen extends StatefulWidget {
  const CalculatorHomeMainScreen({Key? key}) : super(key: key);

  @override
  State<CalculatorHomeMainScreen> createState() =>
      _CalculatorHomeMainScreenState();
}

class _CalculatorHomeMainScreenState extends State<CalculatorHomeMainScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  void onExpand() {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    if (isLandscape) {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final calc = Provider.of<Calculations>(context, listen: false);
    final lGrid = Provider.of<Calculations>(context).lGrid;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return SafeArea(
      bottom: false,
      top: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          title: ConstantStrings.scientificCalculator,
          centerTitle: false,
          leftButton: IconButton(
            icon: SvgPicture.asset(
              CommonUi.setSvgImage(AssetsPath.backArrowButton),
              fit: BoxFit.cover,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          rightButton: IconButton(
            icon: SvgPicture.asset(
              CommonUi.setSvgImage(AssetsPath.historyForCalculation),
            ),

            onPressed: () {
              openHistory(context);
            },
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (isLandscape)
              Expanded(
                flex: 7,
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          const Expanded(flex: 5, child: InputFeild()),
                          Expanded(
                            flex: isLandscape ? 4 : 2,
                            child: const AnswerText(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            else ...[
              const Expanded(flex: 4, child: InputFeild()),
              const Expanded(flex: 2, child: AnswerText()),
            ],
            if (!isLandscape) const SizedBox(height: 5),
            Expanded(
              flex: kIsWeb ? (isLandscape ? 14 : 11) : 14,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.primaryDark,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 5,
                ),
                child: Column(
                  children: [
                    Container(
                      height: 33,
                      margin: EdgeInsets.symmetric(
                        horizontal: 3,
                        vertical: isLandscape ? 0 : 5,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (!kIsWeb) ...[
                            CustomIcon(
                              CommonUi.setSvgImage(
                                AssetsPath.expandForCalculation,
                              ),
                              onPressed: onExpand,
                              isSelected: isLandscape,
                            ),
                          ],
                          const Spacer(),
                          CustomIcon(
                            CommonUi.setSvgImage(
                              AssetsPath.deleteForCalculation,
                            ),
                            onPressed: calc.delete,
                          ),
                        ],
                      ),
                    ),
                    if (!isLandscape) const SizedBox(height: 5),
                    Expanded(
                      child: Responsive(
                        portrait: const Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: CustomAnimatedSwitcher(
                                grid: ButtonsGrid(grid: AppConstant.grid),
                              ),
                            ),
                            Expanded(
                              child: ButtonsGrid(grid: AppConstant.opGrid),
                            ),
                          ],
                        ),
                        landscape: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: CustomAnimatedSwitcher(
                                grid: ButtonsGrid(grid: lGrid),
                              ),
                            ),
                            const Expanded(
                              flex: 3,
                              child: ButtonsGrid(grid: AppConstant.grid),
                            ),
                            const Expanded(
                              child: ButtonsGrid(grid: AppConstant.opGrid),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: isLandscape ? 2 : 5),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void openHistory(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.primaryDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.7,
          minChildSize: 0.7,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "History",
                        style: AppTextStyles.bold(
                          18,
                        ).copyWith(height: 1.0, color: AppColors.white),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.close, color: Colors.white),
                      ),
                    ],
                  ),
                ),

                const Divider(color: Colors.white24, height: 1),
                Expanded(child: HistoryList()),
              ],
            );
          },
        );
      },
    );
  }
}
