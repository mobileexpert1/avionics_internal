import 'package:avionics_internal/Constants/AppColors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../../Constants/ConstantStrings.dart';
import '../../../../Constants/constantImages.dart';
import '../../../../CustomFiles/CustomAppBar.dart';
import '../providers/calculations.dart';
import '../providers/history.dart';
import '../core/index.dart';

import '../widgets/answer_text.dart';
import '../widgets/buttons_grid.dart';
import '../widgets/custom_animated_switcher.dart';
import '../widgets/custom_icon.dart';
import '../widgets/input_feild.dart';
import '../widgets/last_answer.dart';
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
    final history = Provider.of<History>(context);

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
          leftButton: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),

          rightButton: IconButton(
            icon: CustomIcon(
              AssetsPath.historyForCal,
              onPressed: history.toggleShowHistory,
              isSelected: history.isShowHistory,
            ),
            onPressed: () {},
          ),
          centerTitle: true,
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
            //const GradientDivider(),
            Expanded(
              flex: kIsWeb ? (isLandscape ? 14 : 11) : 14,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.customBottomEnabledColour,
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
                              AssetsPath.expandForCal,
                              onPressed: onExpand,
                              isSelected: isLandscape,
                            ),
                          ],
                          const Spacer(),
                          CustomIcon(
                            AssetsPath.deleteForCal,
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
}
