import 'package:avionics_internal/Constants/constantImages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../CustomFiles/CustomTabBar.dart';
import '../../bloc/SavedFlighDetails/savedFlight_cubit.dart';
import '../../bloc/SavedFlighDetails/savedFlight_state.dart';

class SavedFlighScreen extends StatefulWidget {
  final bool showTabs;

  const SavedFlighScreen({Key? key, this.showTabs = true}) : super(key: key);

  @override
  State<SavedFlighScreen> createState() => _SavedFlighScreenState();
}

class _SavedFlighScreenState extends State<SavedFlighScreen> {
  int _currentTabIndex = 0;
  final List<String> _tabTitles = ['SAVED', 'FAVORITE'];
  late final List<Widget> _tabContents;

  @override
  void initState() {
    super.initState();
    _tabContents = [_buildSavedTab(), _buildFavoriteTab()];
    BlocProvider.of<SavedFlightCubit>(context).loadManufacturers();
  }

  Widget _buildSavedTab() {
    return BlocBuilder<SavedFlightCubit, SavedFlightState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.savedflight.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.bookmark_border, size: 50, color: Colors.grey),
                SizedBox(height: 10),
                Text("No saved items yet."),
              ],
            ),
          );
        }

        return ListView(
          padding: const EdgeInsets.all(15),
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: Text(
                _currentTabIndex == 1 ? 'Favorites' : 'Saved',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            ...state.savedflight.map((item) {
              return Card(
                color: Colors.white,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: SvgPicture.asset(
                    CommonUi.setSvgImage(item.icon!), // Use your CommonUi
                    width: 30,
                    height: 30,
                  ),
                  title: Text(item.name),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 15),
                  onTap: () {},
                ),
              );
            }),
          ],
        );
      },
    );
  }

  // This method builds the content for the "FAVORITE" tab
  Widget _buildFavoriteTab() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [SizedBox(height: 10), Text("Favorite list goes here")],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Saved"),
        backgroundColor: Colors.white,
        elevation: 4,
        shadowColor: Colors.grey.withOpacity(0.5),
        surfaceTintColor: Colors.white,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.showTabs)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 1.0,
              ),
              child: CustomTabBar(
                tabTitles: _tabTitles,
                initialIndex: _currentTabIndex,
                onTabSelected: (index) {
                  setState(() {
                    _currentTabIndex = index;
                  });
                  print('Tab selected: ${_tabTitles[index]}');
                },
              ),
            ),
          Expanded(child: _tabContents[_currentTabIndex]),
        ],
      ),
    );
  }
}
