import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../Constants/AppColors.dart';
import '../Constants/constantImages.dart';
import 'AppTextStyles/AppTextStyles.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;

  final VoidCallback? onFilterTap;
  final VoidCallback? onBackButtonTap;
  final bool enableFilter;
  final bool enableBackArrow;
  final bool enableCloseScreen;
  final Function(String)? onChanged;
  final bool? isComeFromMapSection;
  final String searchTitle;

  final bool enableGestureMode;
  final VoidCallback? onTextTap;

  const SearchBarWidget({
    super.key,
    required this.controller,
    this.focusNode,
    this.onFilterTap,
    this.onBackButtonTap,
    required this.enableFilter,
    required this.enableBackArrow,
    required this.enableCloseScreen,
    this.onChanged,
    this.isComeFromMapSection,
    required this.searchTitle,
    this.enableGestureMode = false,
    this.onTextTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 10, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (enableCloseScreen)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.clear, color: Colors.black87),
                  ),
                ),

              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (enableBackArrow)
                    GestureDetector(
                      onTap: onBackButtonTap,
                      child: SvgPicture.asset(
                        CommonUi.setSvgImage(AssetsPath.backArrowButton),
                        color: Colors.black,
                        fit: BoxFit.cover,
                      ),
                    ),

                  if (enableBackArrow) const SizedBox(width: 15),

                  /// SEARCH FIELD
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: (isComeFromMapSection == true
                            ? Colors.white
                            : Colors.transparent),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: TextField(
                        focusNode: focusNode,

                        controller: controller,
                        onChanged: onChanged,

                        readOnly: enableGestureMode,
                        onTap: enableGestureMode ? onTextTap : null,

                        style: AppTextStyles.regular(
                          18.67,
                        ).copyWith(height: 1.0, color: AppColors.primaryDark),

                        decoration: InputDecoration(
                          hintText: searchTitle,
                          hintStyle: AppTextStyles.regular(
                            18.67,
                          ).copyWith(height: 1.0, color: AppColors.grayLight),

                          suffixIcon: enableFilter
                              ? GestureDetector(
                                  onTap: onFilterTap,
                                  behavior: HitTestBehavior.opaque,
                                  child: Padding(
                                    padding: const EdgeInsets.all(13),
                                    child: SvgPicture.asset(
                                      CommonUi.setSvgImage(
                                        AssetsPath.compareFilter,
                                      ),
                                      width: 18,
                                      height: 18,
                                      color: Colors.black,
                                    ),
                                  ),
                                )
                              : null,

                          /// SEARCH ICON
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(13),
                            child: SvgPicture.asset(
                              CommonUi.setSvgImage(AssetsPath.searchIcon),
                              width: 18,
                              height: 18,
                            ),
                          ),

                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 16,
                          ),

                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(13),
                            borderSide: const BorderSide(
                              color: Colors.black,
                              width: 0.6,
                            ),
                          ),

                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(13),
                            borderSide: BorderSide(
                              color: (isComeFromMapSection == true
                                  ? Colors.transparent
                                  : Colors.black),
                              width: 1.0,
                            ),
                          ),

                          filled: true,
                          fillColor: Colors.transparent,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget dividerWithShadow() {
    return Container(
      height: 1.5,
      decoration: BoxDecoration(
        color: (isComeFromMapSection == true
            ? Colors.transparent
            : const Color(0xFFDDDDDD)),
        boxShadow: [
          BoxShadow(
            color: (isComeFromMapSection == true
                ? Colors.transparent
                : Colors.grey.withOpacity(0.5)),
            spreadRadius: 0,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
    );
  }
}
