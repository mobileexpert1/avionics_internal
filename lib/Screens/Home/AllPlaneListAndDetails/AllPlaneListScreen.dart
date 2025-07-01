import 'package:avionics_internal/Helpers/CustomDivider.dart';
import 'package:avionics_internal/bloc/AllPlanes/AllPlanes_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Constants/AppColors.dart';
import '../../../Helpers/SearchBarWidget.dart';
import '../../../bloc/AllPlanes/AllPlanes_cubit.dart';
import '../HomeAirbus/AirCraftDetailScreen.dart';

class AllPlanesListScreen extends StatefulWidget {
  const AllPlanesListScreen({super.key});

  @override
  State<AllPlanesListScreen> createState() => _AllPlanesScreenState();
}

class _AllPlanesScreenState extends State<AllPlanesListScreen> {
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<AllplanesCubit>().loadAirbusModels();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            SearchBarWidget(
              enableBackArrow: true,
              enableFilter: false,
              enableCloseScreen: false,
              controller: searchController,
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'ALL AIRBUS MODELS',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Expanded(
              child: BlocBuilder<AllplanesCubit, AllplanesState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state.AllPlanes.isEmpty) {
                    return const Center(
                      child: Text(
                        'No models available',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: state.AllPlanes.length,
                    itemBuilder: (context, index) {
                      final model = state.AllPlanes[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 20,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 5,
                                spreadRadius: 1,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 0,
                            ),
                            leading: Image.asset(
                              model.image,
                              width: 90,
                              height: 60,
                              fit: BoxFit.contain,
                            ),
                            title: Row(
                              children: [
                                Text(
                                  model.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                if ((model.code ?? '').isNotEmpty)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(4),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey,
                                          spreadRadius: 0.1,
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      model.code!,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              size: 15,
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AirCraftDetailScreen(),
                                ),
                              );
                            },
                          ),
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
    );
  }
}
