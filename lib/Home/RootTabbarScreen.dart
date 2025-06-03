import 'package:flutter/material.dart';
import 'Manufacturer/ManufacturerScreen.dart';

class RootTabbarscreen extends StatefulWidget {
  @override
  State<RootTabbarscreen> createState() => _RootTabbarScreenState();
}

class _RootTabbarScreenState extends State<RootTabbarscreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    ManufacturerScreen(),
    Center(child: Text('Map')),
    Center(child: Text('Compare')),
    Center(child: Text('Saved')),
    Center(child: Text('Profile')),
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
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Explore',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.map_outlined), label: 'Map'),
          BottomNavigationBarItem(
            icon: Icon(Icons.compare_arrows_outlined),
            label: 'Compare',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_outline),
            label: 'Saved',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
