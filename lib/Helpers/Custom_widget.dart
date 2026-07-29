import 'package:avionics_internal/Constants/AppColors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/Home/AirCraftDetail/airCraftDetail_cubit.dart';
import 'AppTextStyles/AppTextStyles.dart';

Widget customFieldForTextAndValue(
  bool isComeFromSavedFlight, {
  double? width,
  Function(int index)? onInfoTap,
  required List<List<dynamic>> fields,
  required BuildContext context,
}) {
  return SizedBox(
    width: width,
    child: Column(
      children: List.generate((fields.length / 2).ceil(), (i) {
        final first = fields[i * 2];

        final second = i * 2 + 1 < fields.length ? fields[i * 2 + 1] : null;
        final bool firstShowInfo = first.length > 2 && first[2] == true;
        final bool secondShowInfo =
            second != null && second.length > 2 && second[2] == true;

        return Padding(
          padding: const EdgeInsets.only(bottom: 7),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Flexible(
                          child: Text(
                            first[0].toString(),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.regular(14).copyWith(
                              height: 1.3,
                              color: isComeFromSavedFlight
                                  ? AppColors.white
                                  : AppColors.lightGreyTextFieldHeading,
                            ),
                          ),
                        ),

                        if (firstShowInfo) ...[
                          const SizedBox(width: 4),
                          GestureDetector(
                            onTap: () {
                              if (first.length > 3 && first[3] != null) {
                                final key = first[3].toString();
                                final isForLive = first[4].toString();

                                final value = context
                                    .read<AirCraftDetailCubit>()
                                    .getFieldValue(key, isForLive);

                                showAutoDismissDialog(
                                  context,
                                  first[0].toString(),
                                  value,
                                );
                              } else {
                                showAutoDismissDialog(
                                  context,
                                  first[0],
                                  first[1],
                                );
                              }
                            },
                            child: const Icon(Icons.info_outline, size: 16),
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(width: 15),

                  Expanded(
                    child: second != null
                        ? Row(
                            children: [
                              Flexible(
                                child: Text(
                                  second[0].toString(),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyles.regular(14).copyWith(
                                    height: 1.3,
                                    color: isComeFromSavedFlight
                                        ? AppColors.white
                                        : AppColors.lightGreyTextFieldHeading,
                                  ),
                                ),
                              ),

                              if (secondShowInfo) ...[
                                const SizedBox(width: 4),
                                GestureDetector(
                                  onTap: () {
                                    if (second.length > 3 &&
                                        second[3] != null) {
                                      final key = second[3].toString();
                                      final isForLive = second[4].toString();

                                      final value = context
                                          .read<AirCraftDetailCubit>()
                                          .getFieldValue(key, isForLive);

                                      showAutoDismissDialog(
                                        context,
                                        second[0].toString(),
                                        value,
                                      );
                                    } else {
                                      showAutoDismissDialog(
                                        context,
                                        second[0],
                                        second[1],
                                      );
                                    }
                                  },
                                  child: const Icon(
                                    Icons.info_outline,
                                    size: 16,
                                  ),
                                ),
                              ],
                            ],
                          )
                        : const SizedBox(),
                  ),
                ],
              ),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      first[1].toString(),
                      style: AppTextStyles.bold(18).copyWith(
                        height: 1.4,
                        color: isComeFromSavedFlight
                            ? AppColors.white
                            : AppColors.black,
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: second != null
                        ? Text(
                            second[1].toString(),
                            style: AppTextStyles.bold(18).copyWith(
                              height: 1.4,
                              color: isComeFromSavedFlight
                                  ? AppColors.white
                                  : AppColors.black,
                            ),
                          )
                        : const SizedBox(),
                  ),
                ],
              ),

              Row(
                children: [
                  Expanded(
                    child: Divider(
                      thickness: 2,
                      color: AppColors.separatorColourAppBar,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: second != null
                        ? Divider(
                            thickness: 2,
                            color: AppColors.separatorColourAppBar,
                          )
                        : const SizedBox(),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    ),
  );
}

void showAutoDismissDialog(BuildContext context, String title, String content) {
  final screenWidth = MediaQuery.of(context).size.width;

  showDialog(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black54,
    builder: (_) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        child: SizedBox(
          width: kIsWeb ? screenWidth * 0.2 : null,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1F1F4B),
              borderRadius: BorderRadius.circular(28),
            ),
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
            child: Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 40),
                      child: Text(
                        title,
                        style: AppTextStyles.regular(15).copyWith(
                          height: 1.0,
                          color: AppColors.greyFlightDetailText,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(height: 1, color: Colors.white24),
                    const SizedBox(height: 20),
                    Text(
                      content,
                      style: AppTextStyles.regular(
                        15,
                      ).copyWith(height: 1.0, color: AppColors.white),
                    ),
                  ],
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      height: 25,
                      width: 25,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white54),
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

// Widget customFieldWithNewModifications({
//   required String label,
//   required String text,
//   double? width,
//   bool showInfoIcon = false,
//   Color labelColor = Colors.white70,
//   Color textColor = Colors.white,
//   required TextStyle fontStyleLabel,
//   required TextStyle fontStyleText,
//   VoidCallback? onInfoTap,
// }) {
//   return SizedBox(
//     width: width,
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             Flexible(
//               child: Text(
//                 label,
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//                 style: fontStyleLabel,
//               ),
//             ),
//
//             if (showInfoIcon) ...[
//               const SizedBox(width: 4),
//               GestureDetector(
//                 onTap: onInfoTap,
//                 child: Icon(Icons.info_outline, size: 20),
//               ),
//             ],
//           ],
//         ),
//
//         const SizedBox(height: 5),
//
//         Text(
//           text,
//           style: fontStyleText,
//           maxLines: 4,
//           overflow: TextOverflow.ellipsis,
//         ),
//       ],
//     ),
//   );
// }
//
// Widget buildFieldRows(
//     List<List<String>> fields, {
//       Color labelColor = Colors.white,
//       Color valueColor = Colors.white,
//     }) {
//   return Column(
//     children: List.generate((fields.length / 2).ceil(), (i) {
//       final first = fields[i * 2];
//       final second = i * 2 + 1 < fields.length ? fields[i * 2 + 1] : null;
//       return Padding(
//         padding: const EdgeInsets.only(bottom: 7),
//         child: Column(
//           children: [
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Expanded(
//                   child: SizedBox(
//                     child: Text(
//                       first[0],
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                       style: AppTextStyles.regular(14).copyWith(
//                         height: 1.3,
//                         color: AppColors.lightGreyTextFieldHeading,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 15),
//                 Expanded(
//                   child: second != null
//                       ? SizedBox(
//                     child: Text(
//                       second[0],
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                       style: AppTextStyles.regular(14).copyWith(
//                         height: 1.4,
//                         color: AppColors.lightGreyTextFieldHeading,
//                       ),
//                     ),
//                   )
//                       : const SizedBox(),
//                 ),
//               ],
//             ),
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Expanded(
//                   child: Text(
//                     first[1],
//                     style: AppTextStyles.bold(
//                       18,
//                     ).copyWith(height: 1.4, color: AppColors.black),
//                   ),
//                 ),
//                 const SizedBox(width: 15),
//                 Expanded(
//                   child: second != null
//                       ? Text(
//                     second[1],
//                     style: AppTextStyles.bold(
//                       18,
//                     ).copyWith(height: 1.4, color: AppColors.black),
//                   )
//                       : const SizedBox(),
//                 ),
//               ],
//             ),
//
//             Row(
//               children: [
//                 Expanded(
//                   child: Divider(
//                     thickness: 2,
//                     color: AppColors.separatorColourAppBar,
//                   ),
//                 ),
//                 const SizedBox(width: 15),
//                 Expanded(
//                   child: second != null
//                       ? Divider(
//                     thickness: 2,
//                     color: AppColors.separatorColourAppBar,
//                   )
//                       : const SizedBox(),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       );
//     }),
//   );
// }
