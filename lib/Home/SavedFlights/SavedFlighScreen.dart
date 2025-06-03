import 'package:avionics_internal/Constants/constantImages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../bloc/manufacturer/manufacturer_cubit.dart';
import '../../bloc/manufacturer/manufacturer_state.dart';

class SavedFlighScreen extends StatefulWidget {
  final bool showTabs;

  const SavedFlighScreen({Key? key, this.showTabs = true}) : super(key: key);

  @override
  State<SavedFlighScreen> createState() => _SavedFlighScreenState();
}

class _SavedFlighScreenState extends State<SavedFlighScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    context.read<ManufacturerCubit>().loadManufacturers();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Saved"),
        backgroundColor: Colors.white,
        elevation: 4,
        // <-- This adds shadow
        shadowColor: Colors.grey.withOpacity(0.5),
        surfaceTintColor: Colors.white,
      ),
      body: Column(
        children: [
          if (widget.showTabs) ...[
            const SizedBox(height: 10),
            TabBar(
              controller: _tabController,
              labelColor: const Color(0xFF3F3D56),
              unselectedLabelColor: Colors.grey,
              indicatorColor: const Color(0xFF1877F2),
              indicatorWeight: 2.5,
              tabs: const [
                Tab(text: 'SAVED'),
                Tab(text: 'FAVORITE'),
              ],
            ),
            const Divider(height: 1),
          ],
          Expanded(
            child: widget.showTabs
                ? TabBarView(
                    controller: _tabController,
                    children: [
                      _buildSavedTab(context),
                      _buildFavoriteTab(context),
                    ],
                  )
                : _buildSavedTab(context), // Only show one tab if hidden
          ),
        ],
      ),
    );
  }

  Widget _buildSavedTab(BuildContext context) {
    return BlocBuilder<ManufacturerCubit, ManufacturerState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.manufacturers.isEmpty) {
          return const Center(child: Text("No manufacturers available."));
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(
                widget.showTabs == true ? '' : 'Saved',
                style: TextStyle(
                  fontSize: widget.showTabs == true ? 0 : 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ...state.manufacturers.map((item) {
              return Card(
                color: Colors.white,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: SvgPicture.asset(
                    CommonUi.setSvgImage(item.icon!),
                    width: 30,
                    height: 30,
                  ),
                  title: Text(item.name),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {},
                ),
              );
            }).toList(),
          ],
        );
      },
    );
  }

  Widget _buildFavoriteTab(BuildContext context) {
    return const Center(child: Text("Favorite list goes here"));
  }
}
