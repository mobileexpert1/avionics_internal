import 'package:flutter/material.dart';
import '../Constants/constantImages.dart';

class BottomNavHelper {
  static BottomNavigationBar buildBottomNavigationBar({
    required int currentIndex,
    required Function(int) onTap,
  }) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey,
      currentIndex: currentIndex,
      onTap: onTap,
      items: [
        BottomNavigationBarItem(
          icon: Image.asset(
            CommonUi.setPngImage(AssetsPath.ExploreIcon),
            width: 24,
            height: 70,
          ),
          label: 'Explore',
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            CommonUi.setPngImage(AssetsPath.MapIcon),
            width: 24,
            height: 70,
          ),
          label: 'Map',
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            CommonUi.setPngImage(AssetsPath.CompareIcon),
            width: 24,
            height: 70,
          ),
          label: 'Compare',
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            CommonUi.setPngImage(AssetsPath.SavedIcon),
            width: 24,
            height: 70,
          ),
          label: 'Saved',
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            CommonUi.setPngImage(AssetsPath.ProfileIcon),
            width: 24,
            height: 70,
          ),
          label: 'Profile',
        ),
      ],
    );
  }
}
