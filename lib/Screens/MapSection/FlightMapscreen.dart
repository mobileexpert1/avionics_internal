import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../Constants/ApiClass/ApiErrorModel.dart';
import '../../bloc/MapSection/flight_Map_Cubit.dart';
import '../../bloc/MapSection/flight_map_state.dart';

class FlightMapScreen extends StatefulWidget {
  const FlightMapScreen({Key? key}) : super(key: key);

  @override
  State<FlightMapScreen> createState() => _FlightMapscreenState();
}

class _FlightMapscreenState extends State<FlightMapScreen> {

  @override
  void initState() {
    super.initState();
    context.read<FlightMapCubit>().getCurrentLocation();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FlightMapCubit, FlightMapState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.status == CommonApiStatus.failure) {
          return Center(
            child: Text(state.errorMessage ?? 'Failed to get location'),
          );
        }

        if (state.status == CommonApiStatus.success && state.position != null) {
          final position = state.position!;
          final currentLatLng = LatLng(position.latitude, position.longitude);

          return FlutterMap(
            options: MapOptions(center: currentLatLng, zoom: 15),
            children: [
              TileLayer(
                urlTemplate:
                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: const ['a', 'b', 'c'],
                userAgentPackageName: 'com.example.yourapp',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: currentLatLng,
                    width: 60,
                    height: 60,
                    builder: (ctx) => const Icon(
                      Icons.location_on,
                      color: Colors.red,
                      size: 40,
                    ),
                  ),
                ],
              ),
            ],
          );
        }

        return const Center(child: Text('Fetching your location...'));
      },
    );
  }
}
