import 'package:flutter/material.dart';

class CustomTabBar extends StatefulWidget {
  final List<String> tabTitles;
  final Function(int) onTabSelected;
  final int initialIndex;
  final bool isComeFromComparsionScreen;

  const CustomTabBar({
    Key? key,
    required this.tabTitles,
    required this.onTabSelected,
    this.initialIndex = 0,
    this.isComeFromComparsionScreen = false,
  }) : super(key: key);

  @override
  _CustomTabBarState createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  void _handleTabTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
    widget.onTabSelected(index);
  }

  /// Measure text width dynamically
  double _textWidth(String text, TextStyle style) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();
    return tp.width;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final selectedStyle = const TextStyle(
      fontSize: 10.0,
      fontWeight: FontWeight.w500,
      color: Colors.black,
    );
    final unselectedStyle = const TextStyle(
      fontSize: 10.0,
      fontWeight: FontWeight.w500,
      color: Colors.grey,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        SizedBox(
          width:
              screenWidth /
              (widget.isComeFromComparsionScreen == false ? 2 : 1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: List.generate(widget.tabTitles.length, (index) {
              final bool isSelected = _selectedIndex == index;
              final style = isSelected ? selectedStyle : unselectedStyle;

              final textWidth = _textWidth(widget.tabTitles[index], style);

              return GestureDetector(
                onTap: () => _handleTabTap(index),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 0.0,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.tabTitles[index], style: style),
                      const SizedBox(height: 7.0),
                      Align(
                        alignment: Alignment.center,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          height: 2,
                          width: isSelected ? textWidth + 5 : 0.0,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(1.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
        const Divider(height: 0, thickness: 1, color: Colors.grey),
      ],
    );
  }
}
