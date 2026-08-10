import 'package:flutter_bloc/flutter_bloc.dart';

import 'AirPlanePartsModel.dart';
import 'AirPlanePartsState.dart';

class AirPlanePartsCubit extends Cubit<AirPlanePartsState> {
  AirPlanePartsCubit() : super(const AirPlanePartsState()) {
    loadAircraftParts();
  }

  void loadAircraftParts() {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    final List<AirPlanePartsModel> parts = [
      const AirPlanePartsModel(
        id: 1,
        name: 'Nose',
        image: 'assets/images/plane_parts/nose.png',
        modelPath: 'assets/3d_models/Airplane1.glb',
        collectedCount: 5,
        totalCount: 5,
        isUnlocked: true,
        description: '',
        subParts: [
          AirPlaneSubPartModel(
            id: 101,
            name: 'Radome',
            description:
                'A radar-transparent cover that protects the weather radar antenna from airflow, moisture, and debris.',
          ),
          AirPlaneSubPartModel(
            id: 102,
            name: 'Weather Radar Antenna',
            description:
                'An antenna system that detects weather conditions ahead of the aircraft.',
          ),
          AirPlaneSubPartModel(
            id: 103,
            name: 'Pitot Tubes',
            description:
                'Sensors used to measure aircraft airspeed using air pressure.',
          ),
        ],
      ),

      const AirPlanePartsModel(
        id: 2,
        name: 'Cockpit',
        image: 'assets/images/plane_parts/cockpit.png',
        modelPath: 'assets/3d_models/right-engine.glb',
        collectedCount: 5,
        totalCount: 5,
        isUnlocked: true,
        description: '',
        subParts: [
          AirPlaneSubPartModel(
            id: 201,
            name: 'Flight Display System',
            description: 'Displays important flight information to the pilots.',
          ),
          AirPlaneSubPartModel(
            id: 202,
            name: 'Control Yoke',
            description: 'Used by pilots to control aircraft movement.',
          ),
          AirPlaneSubPartModel(
            id: 203,
            name: 'Instrument Panel',
            description:
                'Contains aircraft monitoring and navigation instruments.',
          ),
        ],
      ),

      const AirPlanePartsModel(
        id: 3,
        name: 'Fuselage',
        image: 'assets/images/plane_parts/fuselage.png',
        modelPath: 'assets/3d_models/right-engine.glb',
        collectedCount: 2,
        totalCount: 5,
        isUnlocked: false,
        description:
            'Main body structure of the aircraft that connects cockpit, wings and tail.',
        subParts: [
          AirPlaneSubPartModel(
            id: 301,
            name: 'Passenger Cabin',
            description:
                'Main area designed for passengers and equipment storage.',
          ),
          AirPlaneSubPartModel(
            id: 302,
            name: 'Cargo Hold',
            description: 'Storage area used for carrying luggage and cargo.',
          ),
          AirPlaneSubPartModel(
            id: 303,
            name: 'Aircraft Skin',
            description:
                'Outer metal structure protecting internal aircraft systems.',
          ),
        ],
      ),

      const AirPlanePartsModel(
        id: 4,
        name: 'Left Wing',
        image: 'assets/images/plane_parts/left_wing.png',
        modelPath: 'assets/3d_models/Airplane1.glb',
        collectedCount: 1,
        totalCount: 5,
        isUnlocked: false,
        description: '',
        subParts: [
          AirPlaneSubPartModel(
            id: 401,
            name: 'Flap',
            description: 'High lift device used during takeoff and landing.',
          ),
          AirPlaneSubPartModel(
            id: 402,
            name: 'Aileron',
            description: 'Controls aircraft rolling movement.',
          ),
          AirPlaneSubPartModel(
            id: 403,
            name: 'Winglet',
            description: 'Reduces drag and improves fuel efficiency.',
          ),
        ],
      ),

      const AirPlanePartsModel(
        id: 5,
        name: 'Right Wing',
        image: 'assets/images/plane_parts/right_wing.png',
        modelPath: 'assets/3d_models/Airplane1.glb',
        collectedCount: 5,
        totalCount: 5,
        isUnlocked: false,
        description: '',
        subParts: [
          AirPlaneSubPartModel(
            id: 501,
            name: 'Flap',
            description: 'Used to increase lift during low speed flight.',
          ),
          AirPlaneSubPartModel(
            id: 502,
            name: 'Spoiler',
            description: 'Controls lift reduction and aircraft descent.',
          ),
          AirPlaneSubPartModel(
            id: 503,
            name: 'Fuel Tank',
            description: 'Stores fuel required for aircraft operation.',
          ),
        ],
      ),
    ];

    emit(state.copyWith(parts: parts, isLoading: false));
  }

  void unlockPart(int id) {
    final updatedParts = state.parts.map((part) {
      if (part.id != id) {
        return part;
      }

      return part.copyWith(isUnlocked: true, collectedCount: part.totalCount);
    }).toList();

    emit(state.copyWith(parts: updatedParts));
  }

  void updatePartProgress({required int id, required int collectedCount}) {
    final updatedParts = state.parts.map((part) {
      if (part.id != id) {
        return part;
      }

      final updatedCount = collectedCount.clamp(0, part.totalCount);

      return part.copyWith(
        collectedCount: updatedCount,
        isUnlocked: updatedCount >= part.totalCount,
      );
    }).toList();

    emit(state.copyWith(parts: updatedParts));
  }
}
