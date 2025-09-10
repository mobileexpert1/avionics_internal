import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../Constants/constantImages.dart';

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
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 11, 16, 8),
          // Add bottom spacing
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
                      child:  Icon(
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
                            : Colors.transparent), // Light grey background
                        borderRadius: BorderRadius.circular(
                          5,
                        ), // Optional: add rounded corners
                      ),
                      child: TextField(
                        controller: controller,
                        onChanged: onChanged,
                        decoration: InputDecoration(
                          hintText: searchTitle,
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(12),
                            child: SvgPicture.asset(
                              CommonUi.setSvgImage(AssetsPath.search),
                              width: 18,
                              height: 18,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 10,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: (isComeFromMapSection == true
                                  ? Colors.transparent
                                  : Color(0xFFE1E4EA)),
                              width: 1.5,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: (isComeFromMapSection == true
                                  ? Colors.transparent
                                  : Color(0xFFE1E4EA)),
                              width: 1.5,
                            ),
                          ),
                          filled:
                              true, // Required to apply fillColor if using directly
                          fillColor: Colors
                              .transparent, // Set to transparent because we're using Container color
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  if (enableFilter)
                    GestureDetector(
                      onTap: onFilterTap,
                      child:  SvgPicture.asset(
                          CommonUi.setSvgImage(AssetsPath.sliders),
                          width: 60,
                          height: 60,
                        ),
                    ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        dividerWithShadow(),
      ],
    );
  }

  Widget dividerWithShadow() {
    return Container(
      height: 1.5,
      decoration: BoxDecoration(
        color: (isComeFromMapSection == true
            ? Colors.transparent
            : Color(0xFFDDDDDD)),
        boxShadow: [
          BoxShadow(
            color: (isComeFromMapSection == true
                ? Colors.transparent
                : Colors.grey.withOpacity(0.5)),
            spreadRadius: 0,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
    );
  }
}
