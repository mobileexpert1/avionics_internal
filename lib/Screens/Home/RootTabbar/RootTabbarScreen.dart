import 'package:flutter/material.dart';
import '../../../Constants/constantImages.dart';
import '../../Profile/ProfileScreen.dart';
import '../HomeAirbus/AirCraftSection/AircraftComparisonScreen.dart';
import '../HomeScreen.dart';
import '../Manufacturer/ManufacturerListScreen.dart';


class RootTabbarscreen extends StatefulWidget {
  @override
  State<RootTabbarscreen> createState() => _RootTabbarScreenState();
}

class _RootTabbarScreenState extends State<RootTabbarscreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(),
    Center(child: Text('Map')),
    Center(child: Text('Game')),
    Center(child: Text('AskWILCO')),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              CommonUi.setPngImage(AssetsPath.ExploreIcon),
              width: 70,
              height: 30,
            ),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              CommonUi.setPngImage(AssetsPath.MapIcon),
              width: 70,
              height: 24,
            ),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              CommonUi.setPngImage(AssetsPath.gameIcon),
              width: 70,
              height: 24,
            ),
            label: 'Game',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              CommonUi.setPngImage(AssetsPath.chatIcon),
              width: 70,
              height: 24,
            ),
            label: 'AskWILCO',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              CommonUi.setPngImage(AssetsPath.ProfileIcon),
              width: 70,
              height: 24,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
