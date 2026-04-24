import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../Constants/AppColors.dart';
import '../Constants/constantImages.dart';
import 'AppTextStyles/AppTextStyles.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
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
    Key? key,
    required this.controller,
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
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 10, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        size: isComeFromMapSection == true ? 25 : 20,
                        color: Colors.black87,
                      ),
                    ),
                  if (enableBackArrow) const SizedBox(width: 15),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: (isComeFromMapSection == true
                            ? Colors.white
                            : Colors.transparent),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: GestureDetector(
                        onTap: enableGestureMode ? onTextTap : null,
                        child: AbsorbPointer(
                          absorbing: enableGestureMode,
                           child: TextField(
                            style: AppTextStyles.regular(
                              18.67,
                            ).copyWith(height: 1.0, color: AppColors.primaryDark),
                            controller: controller,
                            onChanged: onChanged,
                            decoration: InputDecoration(
                              hintText: searchTitle,
                              hintStyle: AppTextStyles.regular(
                                18.67,
                              ).copyWith(height: 1.0, color: AppColors.grayLight),
                              suffixIcon: Padding(
                                padding: const EdgeInsets.all(13),
                                child: SvgPicture.asset(
                                  CommonUi.setSvgImage(AssetsPath.compareFilter),
                                  color: Colors.black,
                                  width: 18,
                                  height: 18,
                                ),
                              ),
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
                                borderSide: BorderSide(
                                  color: (Colors.black),
                                  width: 0.6,
                                ),
                              ),

                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(13),
                                borderSide: BorderSide(
                                  color: (isComeFromMapSection == true ? Colors.transparent : Colors.black),
                                  width: 1.3,
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.transparent,
                            ),
                          ),
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