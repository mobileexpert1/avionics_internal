import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../Constants/constantImages.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback? onFilterTap;
  final bool enableFilter;
  final bool enableBackArrow;
  final bool enableCloseScreen;
  final Function(String)? onChanged;

  const SearchBarWidget({
    Key? key,
    required this.controller,
    this.onFilterTap,
    required this.enableFilter,
    required this.enableBackArrow,
    required this.enableCloseScreen,
    this.onChanged,
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
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        size: 20,
                        color: Colors.black87,
                      ),
                    ),
                  if (enableBackArrow) const SizedBox(width: 15),
                  Expanded(
                    child: TextField(
                      controller: controller,
                      onChanged: onChanged,
                      decoration: InputDecoration(
                        hintText: "Try 'Airbus 320'",
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
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFFE1E4EA),
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFFE1E4EA),
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  if (enableFilter)
                    GestureDetector(
                      onTap: onFilterTap,
                      child: Container(
                        child: SvgPicture.asset(
                          CommonUi.setSvgImage(AssetsPath.sliders),
                          width: 60,
                          height: 60,
                        ),
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
        color: const Color(0xFFDDDDDD),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 0,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
    );
  }
}
