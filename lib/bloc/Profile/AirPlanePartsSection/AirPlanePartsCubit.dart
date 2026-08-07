import 'package:flutter_bloc/flutter_bloc.dart';

import 'AirPlanePartsModel.dart';
import 'AirPlanePartsState.dart';


class AirPlanePartsCubit
    extends Cubit<AirPlanePartsState> {
  AirPlanePartsCubit()
      : super(const AirPlanePartsState()) {
    loadAircraftParts();
  }

  void loadAircraftParts() {
    emit(
      state.copyWith(
        isLoading: true,
        errorMessage: null,
      ),
    );

    final List<AirPlanePartsModel> parts = [
      const AirPlanePartsModel(
        id: 1,
        name: 'Nose',
        image: 'assets/images/plane_parts/nose.png',
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
        collectedCount: 0,
        totalCount: 5,
        isUnlocked: true,
        description: '',
        subParts: [
          AirPlaneSubPartModel(
            id: 201,
            name: 'Flight Display System',
            description:
            'Displays important flight information to the pilots.',
          ),
          AirPlaneSubPartModel(
            id: 202,
            name: 'Control Yoke',
            description:
            'Used by pilots to control aircraft movement.',
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
        collectedCount: 1,
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
            description:
            'Storage area used for carrying luggage and cargo.',
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
        collectedCount: 2,
        totalCount: 5,
        isUnlocked: false,
        description: '',
        subParts: [
          AirPlaneSubPartModel(
            id: 401,
            name: 'Flap',
            description:
            'High lift device used during takeoff and landing.',
          ),
          AirPlaneSubPartModel(
            id: 402,
            name: 'Aileron',
            description:
            'Controls aircraft rolling movement.',
          ),
          AirPlaneSubPartModel(
            id: 403,
            name: 'Winglet',
            description:
            'Reduces drag and improves fuel efficiency.',
          ),
        ],
      ),

      const AirPlanePartsModel(
        id: 5,
        name: 'Right Wing',
        image: 'assets/images/plane_parts/right_wing.png',
        collectedCount: 3,
        totalCount: 5,
        isUnlocked: false,
        description: '',
        subParts: [
          AirPlaneSubPartModel(
            id: 501,
            name: 'Flap',
            description:
            'Used to increase lift during low speed flight.',
          ),
          AirPlaneSubPartModel(
            id: 502,
            name: 'Spoiler',
            description:
            'Controls lift reduction and aircraft descent.',
          ),
          AirPlaneSubPartModel(
            id: 503,
            name: 'Fuel Tank',
            description:
            'Stores fuel required for aircraft operation.',
          ),
        ],
      ),

      const AirPlanePartsModel(
        id: 6,
        name: 'Engine',
        image: 'assets/images/plane_parts/engine.png',
        collectedCount: 4,
        totalCount: 5,
        isUnlocked: false,
        description: '',
        subParts: [
          AirPlaneSubPartModel(
            id: 601,
            name: 'Fan Blades',
            description:
            'Large rotating blades that generate airflow.',
          ),
          AirPlaneSubPartModel(
            id: 602,
            name: 'Compressor',
            description:
            'Compresses air before combustion.',
          ),
          AirPlaneSubPartModel(
            id: 603,
            name: 'Turbine',
            description:
            'Converts energy from combustion into mechanical power.',
          ),
        ],
      ),

      const AirPlanePartsModel(
        id: 7,
        name: 'Tail',
        image: 'assets/images/plane_parts/tail.png',
        collectedCount: 5,
        totalCount: 5,
        isUnlocked: false,
        description: '',
        subParts: [
          AirPlaneSubPartModel(
            id: 701,
            name: 'Vertical Stabilizer',
            description:
            'Provides directional stability.',
          ),
          AirPlaneSubPartModel(
            id: 702,
            name: 'Rudder',
            description:
            'Controls aircraft yaw movement.',
          ),
          AirPlaneSubPartModel(
            id: 703,
            name: 'Horizontal Stabilizer',
            description:
            'Provides pitch stability.',
          ),
        ],
      ),

      const AirPlanePartsModel(
        id: 8,
        name: 'Landing Gear',
        image: 'assets/images/plane_parts/landing_gear.png',
        collectedCount: 0,
        totalCount: 5,
        isUnlocked: false,
        description: '',
        subParts: [
          AirPlaneSubPartModel(
            id: 801,
            name: 'Main Gear',
            description:
            'Supports aircraft weight during landing and taxi.',
          ),
          AirPlaneSubPartModel(
            id: 802,
            name: 'Nose Gear',
            description:
            'Front landing support system.',
          ),
          AirPlaneSubPartModel(
            id: 803,
            name: 'Brake System',
            description:
            'Helps slow and stop the aircraft.',
          ),
        ],
      ),

      const AirPlanePartsModel(
        id: 9,
        name: 'Right Engine',
        image: 'assets/images/plane_parts/right_engine.png',
        collectedCount: 0,
        totalCount: 5,
        isUnlocked: false,
        description: '',
        subParts: [
          AirPlaneSubPartModel(
            id: 901,
            name: 'Engine Fan',
            description:
            'Front rotating section of the engine.',
          ),
          AirPlaneSubPartModel(
            id: 902,
            name: 'Exhaust Nozzle',
            description:
            'Controls exhaust gas flow from the engine.',
          ),
          AirPlaneSubPartModel(
            id: 903,
            name: 'Combustion Chamber',
            description:
            'Area where fuel combustion produces energy.',
          ),
        ],
      ),

      const AirPlanePartsModel(
        id: 10,
        name: 'Stabilizer',
        image: 'assets/images/plane_parts/stabilizer.png',
        collectedCount: 0,
        totalCount: 5,
        isUnlocked: false,
        description: '',
        subParts: [
          AirPlaneSubPartModel(
            id: 1001,
            name: 'Elevator',
            description:
            'Controls aircraft pitch movement.',
          ),
          AirPlaneSubPartModel(
            id: 1002,
            name: 'Trim Tab',
            description:
            'Helps maintain stable aircraft attitude.',
          ),
          AirPlaneSubPartModel(
            id: 1003,
            name: 'Horizontal Tail',
            description:
            'Provides balance and stability during flight.',
          ),
        ],
      ),
    ];

    emit(
      state.copyWith(
        parts: parts,
        isLoading: false,
      ),
    );
  }

  void unlockPart(int id) {
    final updatedParts = state.parts.map((part) {
      if (part.id != id) {
        return part;
      }

      return part.copyWith(
        isUnlocked: true,
        collectedCount: part.totalCount,
      );
    }).toList();

    emit(
      state.copyWith(
        parts: updatedParts,
      ),
    );
  }

  void updatePartProgress({
    required int id,
    required int collectedCount,
  }) {
    final updatedParts = state.parts.map((part) {
      if (part.id != id) {
        return part;
      }

      final updatedCount =
      collectedCount.clamp(0, part.totalCount);

      return part.copyWith(
        collectedCount: updatedCount,
        isUnlocked:
        updatedCount >= part.totalCount,
      );
    }).toList();

    emit(
      state.copyWith(
        parts: updatedParts,
      ),
    );
  }
}