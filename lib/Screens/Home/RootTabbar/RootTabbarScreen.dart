import 'package:avionics_internal/Screens/Games/MainGameScreen/GameScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Constants/ApiClass/shared_prefs_helper.dart';
import '../../../Constants/constantImages.dart';
import '../../../bloc/MapSection/flight_Map_Cubit.dart';
import '../../MapSection/FlightMapscreen.dart';
import '../../Profile/ProfileScreen.dart';
import '../HomeAirbus/ChatSection/ChatBotScreen.dart';
import '../HomeScreen.dart';

class RootTabbarscreen extends StatefulWidget {
  static final GlobalKey<RootTabbarScreenState> globalKey =
  GlobalKey<RootTabbarScreenState>();

  RootTabbarscreen({Key? key}) : super(key: globalKey);

  @override
  State<RootTabbarscreen> createState() => RootTabbarScreenState();
}

class RootTabbarScreenState extends State<RootTabbarscreen> {
  int _selectedIndex = 0;
  List<Widget> _pages = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTokenAndInitPages();
  }

  Future<void> _loadTokenAndInitPages() async {
    await SharedPrefsHelper.clearApiFetchServer();
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('UserAccessTokenKey');

    setState(() {
      _pages = [
        HomeScreen(),
        BlocProvider(
          create: (context) => FlightMapCubit(),
          child: FlightMapScreen(onGoToFirstTab: () => onItemTapped(0)),
        ),
        GamesScreen(),
        token != null && token.isNotEmpty
            ? AskWilcoScreen(
                accessToken: token,
                isComeFromTab: true,
                title: '',
                sessionId: '',
              )
            : Center(child: Text("Token not found")),
        ProfileScreen(),
      ];
      _isLoading = false;
    });
  }

  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _pages[_selectedIndex],
      bottomNavigationBar: _isLoading
          ? null
          : BottomNavigationBar(
              backgroundColor: Colors.white,
              currentIndex: _selectedIndex,
              onTap: onItemTapped,
              selectedItemColor: Colors.black,
              unselectedItemColor: Colors.grey,
              type: BottomNavigationBarType.fixed,
              items: [
                BottomNavigationBarItem(
                  icon: Image.asset(
                    CommonUi.setPngImage(
                      _selectedIndex == 0
                          ? AssetsPath.ExploreIcon
                          : AssetsPath.ExploreUnSelectedIcon,
                    ),
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
                    color: _selectedIndex == 1 ? Colors.black : Colors.grey,
                  ),
                  label: 'Track',
                ),
                BottomNavigationBarItem(
                  icon: Image.asset(
                    CommonUi.setPngImage(AssetsPath.gameIcon),
                    width: 70,
                    height: 24,
                    color: _selectedIndex == 2 ? Colors.black : Colors.grey,
                  ),
                  label: 'Games',
                ),
                BottomNavigationBarItem(
                  icon: Image.asset(
                    CommonUi.setPngImage(AssetsPath.chatIcon),
                    width: 70,
                    height: 24,
                    color: _selectedIndex == 3 ? Colors.black : Colors.grey,
                  ),
                  label: 'AskWILCO',
                ),
                BottomNavigationBarItem(
                  icon: Image.asset(
                    CommonUi.setPngImage(AssetsPath.ProfileIcon),
                    width: 70,
                    height: 24,
                    color: _selectedIndex == 4 ? Colors.black : Colors.grey,
                  ),
                  label: 'Profile',
                ),
              ],
            ),
    );
  }
}
