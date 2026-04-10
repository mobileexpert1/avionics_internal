import 'package:avionics_internal/Constants/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../Helpers/AppTextStyles/AppTextStyles.dart';
import '../providers/calculations.dart';

class HistoryCard extends StatelessWidget {
  const HistoryCard({
    Key? key,
    required this.operation,
    required this.result,
    required this.time,
    required this.date,
  }) : super(key: key);

  final String operation;
  final String result;
  final String time;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primaryDark,
      child: InkWell(
        onTap: () {
          Provider.of<Calculations>(context, listen: false).add(result);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.white12, width: 0.5),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    time,
                    style: AppTextStyles.bold(
                      14,
                    ).copyWith(height: 1.0, color: AppColors.white),

                    // style: const TextStyle(
                    //   color: Colors.white70,
                    //   fontSize: 14,
                    // ),
                  ),
                  Text(
                    date,
                    style: AppTextStyles.bold(
                      13,
                    ).copyWith(height: 1.0, color: AppColors.white),
                  ),
                ],
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: RichText(
                    textAlign: TextAlign.end,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: operation,
                          style: AppTextStyles.bold(18).copyWith(
                            height: 1.0,
                            color: AppColors.extraDarkYellow,
                          ),
                        ),
                        TextSpan(
                          text: " = ",
                          style: AppTextStyles.bold(
                            18,
                          ).copyWith(height: 1.0, color: AppColors.white),
                        ),
                        TextSpan(
                          text: result,
                          style: AppTextStyles.bold(
                            18,
                          ).copyWith(height: 1.0, color: AppColors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
