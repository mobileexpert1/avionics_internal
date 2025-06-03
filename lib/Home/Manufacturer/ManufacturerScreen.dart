import 'package:avionics_internal/Constants/constantImages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../bloc/manufacturer/manufacturer_cubit.dart';
import '../../bloc/manufacturer/manufacturer_state.dart';

class ManufacturerScreen extends StatefulWidget {
  @override
  _ManufacturerScreenState createState() => _ManufacturerScreenState();
}

class _ManufacturerScreenState extends State<ManufacturerScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    context.read<ManufacturerCubit>().loadManufacturers();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Manufacturer"),
        backgroundColor: Colors.white,
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          BlocBuilder<ManufacturerCubit, ManufacturerState>(
            builder: (context, state) {
              if (state.isLoading) {
                return Center(child: CircularProgressIndicator());
              }

              return ListView.builder(
                itemCount: state.manufacturers.length,
                itemBuilder: (context, index) {
                  final item = state.manufacturers[index];
                  return Card(
                    color: Colors.white,
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      leading: SvgPicture.asset(
                        CommonUi.setSvgImage(item.icon!),
                      ),
                      title: Text(item.name),
                      trailing: Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        // navigate to details screen
                      },
                    ),
                  );
                },
              );
            },
          ),
          Center(child: Text("Explore Tab")),
        ],
      ),
    );
  }
}
