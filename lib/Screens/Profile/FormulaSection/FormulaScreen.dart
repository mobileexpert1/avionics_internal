import 'package:flutter/material.dart';
import '../../../Constants/AppColors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../CustomFiles/CustomAppBar.dart';
import '../../../Constants/ApiClass/ApiErrorModel.dart';
import '../../../Helpers/AppTextStyles/AppTextStyles.dart';
import '../../../Helpers/CustomHeaderViewExpandable.dart';
import '../../../bloc/Profile/FormulaSection/formula_cubit.dart';
import '../../../bloc/Profile/FormulaSection/formula_model.dart';
import '../../../bloc/Profile/FormulaSection/formula_state.dart';
import '../../../Constants/ApiClass/FirebaseAnalytics/event_names.dart';
import '../../../Constants/ApiClass/FirebaseAnalytics/analytics_service.dart';

class FormulasScreen extends StatefulWidget {
  const FormulasScreen({super.key});

  @override
  State<FormulasScreen> createState() => _FormulasScreenState();
}

class _FormulasScreenState extends State<FormulasScreen> {
  late FormulaCubit _cubit;

  Map<int, bool> expandedMap = {};

  @override
  void initState() {
    super.initState();
    _cubit = FormulaCubit();
    _cubit.loadFormulas();
    AnalyticsService.instance.logVisibleScreen(FirebaseEvents.formulaScreen);
  }

  @override
  void dispose() {
    _cubit.close();
    expandedMap = {};
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          centerTitle: false,
          title: 'Formulas',
          leftButton: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: BlocConsumer<FormulaCubit, FormulaState>(
          listener: (context, state) {
            if (state.status == CommonApiStatus.failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage ?? 'No formulas found'),
                ),
              );
            }
          },
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.categories.isEmpty) {
              return const Center(child: Text("No formulas found"));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.categories.length,
              itemBuilder: (context, index) {
                final category = state.categories[index];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: CustomHeaderViewExpandable(
                    isNeedToShowLeftRightBottomBorder: false,
                    isNeedToShowLeftImage: false,
                    isExpanded: expandedMap[index] ?? false,
                    title: category.name,
                    fontStyle: AppTextStyles.regular(
                      16,
                    ).copyWith(height: 1.4, color: AppColors.white),
                    headerColor: expandedMap[index] ?? false
                        ? AppColors.primaryDark
                        : AppColors.grayMedium,
                    arrowBackgroundColor: expandedMap[index] ?? false
                        ? AppColors.extraDarkYellow
                        : AppColors.lightGreyWithAlphaDecreased,
                    arrowFrontColor: Colors.white,
                    isExpandedViewAvailable: true,
                    onHeaderTap: () {
                      setState(() {
                        expandedMap[index] = !(expandedMap[index] ?? false);
                      });
                    },
                    child: _buildFormulaBody(category),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildFormulaBody(FormulaModel category) {
    return Column(
      children: [
        ...List.generate(category.formulas.length, (index) {
          final formula = category.formulas[index];
          return Container(
            color: AppColors.greyForConversionScreen,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    formula.expression,
                    textAlign: TextAlign.left,
                    style: AppTextStyles.regular(
                      16,
                    ).copyWith(height: 1.4, color: AppColors.black),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
