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
  const SearchBarWidget({Key? key, required this.controller, this.onFilterTap,required this.enableFilter, required this.enableBackArrow,required this.enableCloseScreen})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          enableCloseScreen ? Icon(Icons.clear) : SizedBox.shrink(),
          Row(
            children: [
            enableBackArrow ? GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(Icons.arrow_back_ios_new, size: 20, color: Colors.black87),
              ):SizedBox.shrink(),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: "Try 'Airbus 320'",
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(12),
                      child: SvgPicture.asset(
                        CommonUi.setSvgImage(AssetsPath.search),
                        width: 18,
                        height: 30,
                        fit: BoxFit.contain,
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 13),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12),
             enableFilter ? GestureDetector(
                onTap: onFilterTap,
                child: SvgPicture.asset(
                  CommonUi.setSvgImage(AssetsPath.sliders),
                  width: 24,
                  height: 60,
                  fit: BoxFit.contain,
                ),
              ) : SizedBox.shrink(),
            ],
          ),
        ],
      ),
    );
  }
}

//
// enableBackArrow ?
//     : Widget() : c
