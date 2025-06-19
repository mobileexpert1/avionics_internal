import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../Constants/constantImages.dart';
import 'SearchBarWidget.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback? onFilterTap;
  final enableFilter;
  final enableBackArrow;
  final enableCloseScreen;
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
    return Padding(
      padding: EdgeInsets.zero, // 🔧 No space above/below
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          enableCloseScreen ? const Icon(Icons.clear) : const SizedBox.shrink(),
          Row(
            children: [
              enableBackArrow
                  ? GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        size: 20,
                        color: Colors.black87,
                      ),
                    )
                  : const SizedBox.shrink(),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: controller,
                  onChanged: onChanged,
                  decoration: InputDecoration(
                    hintText: "",
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(12),
                      child: SvgPicture.asset(
                        CommonUi.setSvgImage(AssetsPath.search),
                        width: 18,
                        height: 30,
                        fit: BoxFit.contain,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 13),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFE1E4EA),
                        width: 1.8,
                      ),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFE1E4EA),
                        width: 1.8,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              enableFilter
                  ? GestureDetector(
                      onTap: onFilterTap,
                      child: SvgPicture.asset(
                        CommonUi.setSvgImage(AssetsPath.sliders),
                        width: 24,
                        height: 60,
                        fit: BoxFit.contain,
                      ),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        ],
      ),
    );
  }
}
