import 'package:flutter/material.dart';

class CustomTabBar extends StatefulWidget {
  final List<String> tabTitles;
  final Function(int) onTabSelected;
  final int initialIndex;

  const CustomTabBar({
    Key? key,
    required this.tabTitles,
    required this.onTabSelected,
    this.initialIndex = 0,
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

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Column(
      // Wrap with Column to add the bottom border
      crossAxisAlignment: CrossAxisAlignment.start, // Align tabs to the left
      children: [
        Container(
          width: screenWidth / 2, // Adjust for the desired partial width
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: List.generate(widget.tabTitles.length, (index) {
              final bool isSelected = _selectedIndex == index;
              return GestureDetector(
                onTap: () => _handleTabTap(index),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 1.0,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // Align text and underline
                    children: [
                      const Divider(
                        height: 20,
                        thickness: 1,
                        color: Colors.grey,
                      ),
                      Text(
                        widget.tabTitles.elementAt(index),
                        style: TextStyle(
                          fontSize: 10.0,
                          fontWeight: FontWeight.w500, // Medium weight
                          color: isSelected ? Colors.black : Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 6.0),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        height: 2.0,
                        width: isSelected ? 30.0 : 0.0,
                        // Adjust underline width
                        margin: const EdgeInsets.only(left: 2.0),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(1.0),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
        const Divider(height: 1, thickness: 1, color: Colors.grey),
        // Bottom border
      ],
    );
  }
}
