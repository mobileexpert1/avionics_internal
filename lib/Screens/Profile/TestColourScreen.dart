import 'package:flutter/material.dart';

import '../../CustomFiles/CustomAppBar.dart';

class TestColourScreen extends StatelessWidget {
  TestColourScreen({super.key});

  final List<Map<String, dynamic>> colors = [
    {
      "name": "Primary Dark",
      "color": const Color(0xFF1B1748),
      "rgb": "32, 30, 72",
      "hex": "#1B1748",
    },
    {
      "name": "Primary Blue",
      "color": const Color(0xFF4797DB),
      "rgb": "71, 151, 219",
      "hex": "#4797DB",
    },

    // 🟡 Secondary
    {
      "name": "Secondary Yellow",
      "color": const Color(0xFFF9E84B),
      "rgb": "249, 232, 75",
      "hex": "#F9E84B",
    },
    {
      "name": "Secondary Green",
      "color": const Color(0xFF9CD450),
      "rgb": "156, 212, 80",
      "hex": "#9CD450",
    },
    {
      "name": "Secondary Cyan",
      "color": const Color(0xFF3EE1E1),
      "rgb": "62, 225, 225",
      "hex": "#3EE1E1",
    },
    {
      "name": "Secondary Red",
      "color": const Color(0xFFD44545),
      "rgb": "212, 69, 69",
      "hex": "#D44545",
    },

    // ⚫ Grays
    {
      "name": "Black",
      "color": const Color(0xFF000000),
      "rgb": "0, 0, 0",
      "hex": "#000000",
    },
    {
      "name": "Gray Dark",
      "color": const Color(0xFF575757),
      "rgb": "87, 87, 87",
      "hex": "#575757",
    },
    {
      "name": "Gray Medium",
      "color": const Color(0xFF969696),
      "rgb": "150, 150, 150",
      "hex": "#969696",
    },
    {
      "name": "Gray Light",
      "color": const Color(0xFFD6D6D6),
      "rgb": "214, 214, 214",
      "hex": "#D6D6D6",
    },
    {
      "name": "Gray Very Light",
      "color": const Color(0xFFE3E3E3),
      "rgb": "227, 227, 227",
      "hex": "#E3E3E3",
    },

    // ⚪ White
    {
      "name": "White",
      "color": const Color(0xFFFFFFFF),
      "rgb": "255, 255, 255",
      "hex": "#FFFFFF",
    },

    //Extra Colour
    {
      "name": "Extra Color Used",
      "color": const Color(0xFFFFCB19),
      "rgb": "255, 203, 25",
      "hex": "#FFFFFF",
    },

    //Extra Colour
    {
      "name": "Extra Color Used",
      "color": const Color(0xFFF3F3F3),
      "rgb": "243, 243, 243",
      "hex": "#FFFFFF",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: "App Colors Code Used",
        leftButton: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView.builder(
        itemCount: colors.length,
        itemBuilder: (context, index) {
          final item = colors[index];

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: item["color"],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item["name"],
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color:
                        item["name"].toString().contains("White") ||
                            item["name"].toString().contains("Light")
                        ? Colors.black
                        : Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text("RGB: ${item['rgb']}"),
                Text("HEX: ${item['hex']}"),
              ],
            ),
          );
        },
      ),
    );
  }
}
