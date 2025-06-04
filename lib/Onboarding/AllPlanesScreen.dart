import 'package:avionics_internal/Helpers/CustomDivider.dart';
import 'package:avionics_internal/bloc/AllPlanes/AllPlanes_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/AllPlanes/AllPlanes_cubit.dart';
import '../Helpers/SearchBarWidget.dart';
import '../Home/FilterScreen.dart';

class AllPlanesScreen extends StatefulWidget {
  const AllPlanesScreen({super.key});

  @override
  State<AllPlanesScreen> createState() => _AllPlanesScreenState();
}

class _AllPlanesScreenState extends State<AllPlanesScreen> {
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<AllplanesCubit>().loadAirbusModels();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
        child: Column(
          children: [
            SearchBarWidget(
              controller: searchController,
              onFilterTap: () {
              },
            ),
            CustomDivider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'ALL AIRBUS MODELS',
                  style: TextStyle(
                    fontSize: 16,
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
                  return ListView.builder(
                    itemCount: state.AllPlanes.length,
                    itemBuilder: (context, index) {
                      final model = state.AllPlanes[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        color: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
                        child: ListTile(
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
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(4),
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
                            trailing: const Icon(Icons.arrow_forward_ios, size: 16)
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
