import 'package:avionics_internal/Constants/constantImages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../Helpers/CustomDivider.dart';
import '../../Helpers/SearchBarWidget.dart';
import '../../bloc/manufacturer/manufacturer_cubit.dart';
import '../../bloc/manufacturer/manufacturer_state.dart';

class ManufacturerScreen extends StatefulWidget {
  @override
  _ManufacturerScreenState createState() => _ManufacturerScreenState();
}

class _ManufacturerScreenState extends State<ManufacturerScreen> {
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ManufacturerCubit>().loadManufacturers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            children: [
              SearchBarWidget(
                controller: searchController,
                onFilterTap: () {},
              ),
              CustomDivider(),
              const SizedBox(height: 20),

              /// Expanded to allow ListView to render properly
              Expanded(
                child: BlocBuilder<ManufacturerCubit, ManufacturerState>(
                  builder: (context, state) {
                    if (state.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state.manufacturers.isEmpty) {
                      return const Center(child: Text("No manufacturers available."));
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: state.manufacturers.length,
                      itemBuilder: (context, index) {
                        final item = state.manufacturers[index];
                        return Card(
                          color: Colors.white,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            leading: SvgPicture.asset(
                              CommonUi.setSvgImage(item.icon!),
                              width: 40,
                              height: 40,
                            ),
                            title: Text(item.name),
                            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                            onTap: () {
                              // TODO: Navigate to details screen
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
