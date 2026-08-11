import 'package:avionics_internal/Constants/AppColors.dart';
import 'package:avionics_internal/Screens/Games/MainGameScreen/GameScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Constants/ApiClass/alertHelperForSubsPopup.dart';
import '../../../Constants/constantImages.dart';
import '../../../Helpers/AppTextStyles/AppTextStyles.dart';
import '../../../Helpers/CreditManager/CreditManager.dart';
import '../../../bloc/MapSection/flight_Map_Cubit.dart';
import '../../../bloc/MapSection/flight_map_repository.dart';
import '../../MapSection/FlightMapScreen.dart';
import '../../Profile/ProfileScreen.dart';
import '../../Profile/SettingScreen/SettingMenuScreen/3_AddOnPacks/AddOnPacksScreen.dart';
import '../../WilcoBoat/ChatBotScreen.dart';
import '../HomeScreen.dart';

class RootTabbarscreen extends StatefulWidget {
  static final GlobalKey<RootTabbarScreenState> globalKey =
      GlobalKey<RootTabbarScreenState>();

  const RootTabbarscreen({Key? key}) : super(key: key);

  @override
  State<RootTabbarscreen> createState() => RootTabbarScreenState();
}

class RootTabbarScreenState extends State<RootTabbarscreen> {
  int _selectedIndex = 0;
  List<Widget> _pages = [];
  bool _isLoading = true;
  final creditManager = CreditManager();

  @override
  void initState() {
    super.initState();
    _loadTokenAndInitPages();
  }

  Future<void> _loadTokenAndInitPages() async {
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
                isFromHistory: false,
                title: '',
                sessionId: '',
              )
            : Center(child: Text("Token not found")),
        ProfileScreen(),
      ];
      _isLoading = false;
    });
  }

  Future<void> onItemTapped(int index) async {
    final bool isRestrictedTab = index == 1;

    if (isRestrictedTab) {
      final bool success = await creditManager.tryUseCredit(
        amount: 8,
        isComeFromTabbar: true,
        onError: (String message) async {
          if (mounted) {
            Future.microtask(() {
              AlertHelperForSubsPopup.showSubscriptionEndAlert(
                isFromTrackingClass: false,
                context: context,
                title: "Credits limit exhausted",
                isFromWilcoAndTrackingScreen: true,
                buttonText: "Buy Credits",
                message:
                    "Your credits limit has been exhausted. Please purchase a extra credits.",
                onGoToActionBlock: () {
                  FlightRepository().openAddOnPacksBottomSheet(
                    context,
                    AddOnPackType.creditsOnly,
                  );
                },
              );
            });
          }
        },
      );

      if (success && mounted) {
        setState(() {
          _selectedIndex = index;
        });
      }
    } else {
      if (!mounted) return;

      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _pages[_selectedIndex],
      bottomNavigationBar: _isLoading
          ? null
          : Container(
              height: 95,
              color: Colors.white,
              child: Row(
                children: [
                  _buildNavItem(
                    0,
                    AssetsPath.exploreTabBarIcon,
                    AssetsPath.unExploreTabBarIcon,
                    'Explore',
                  ),
                  _buildNavItem(
                    1,
                    AssetsPath.trackTabBarIcon,
                    AssetsPath.unTrackTabBarIcon,
                    'Track',
                  ),
                  _buildNavItem(
                    2,
                    AssetsPath.gamesTabBarIcon,
                    AssetsPath.unGamesTabBarIcon,
                    'Games',
                  ),
                  _buildNavItem(
                    3,
                    AssetsPath.wilcoTabBarIcon,
                    AssetsPath.unWilcoTabBarIcon,
                    'WILCO',
                  ),
                  _buildNavItem(
                    4,
                    AssetsPath.profileTabBarIcon,
                    AssetsPath.unProfileTabBarIcon,
                    'Profile',
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildNavItem(
    int index,
    String activeIcon,
    String inactiveIcon,
    String label,
  ) {
    final isSelected = _selectedIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => onItemTapped(index),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF1E1B4B) : Colors.white,
            border: Border(
              top: BorderSide(color: AppColors.greyWithBottomLine, width: 1.5),
            ),
          ),
          height: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 5),
              SvgPicture.asset(
                CommonUi.setSvgImage(isSelected ? inactiveIcon : activeIcon),
                width: 45,
                height: 45,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: AppTextStyles.regular(14).copyWith(
                  height: 1.0,
                  color: isSelected ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 13),
            ],
          ),
        ),
      ),
    );
  }
}
