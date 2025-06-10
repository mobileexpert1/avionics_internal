import 'package:avionics_internal/Home/SavedFlights/SavedFlighScreen.dart';
import 'package:flutter/material.dart';
import '../../Constants/constantImages.dart';
import '../../Profile/ProfileScreen.dart';
import '../HomeAirbus/AircraftComparisonScreen.dart';
import '../HomeScreen.dart';
import '../Manufacturer/ManufacturerScreen.dart';

class RootTabbarscreen extends StatefulWidget {
  @override
  State<RootTabbarscreen> createState() => _RootTabbarScreenState();
}

class _RootTabbarScreenState extends State<RootTabbarscreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(),
    Center(child: Text('Map')),
    AircraftComparisonScreen(),
    SavedFlighScreen(showTabs: true),
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
              CommonUi.setPngImage(AssetsPath.CompareIcon),
              width: 70,
              height: 24,
            ),
            label: 'Compare',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              CommonUi.setPngImage(AssetsPath.SavedIcon),
              width: 70,
              height: 24,
            ),
            label: 'Saved',
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
