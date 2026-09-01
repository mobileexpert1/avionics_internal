import 'package:flutter_bloc/flutter_bloc.dart';

import 'AirmanshipBadgeModel.dart';
import 'AirmanshipBadgesState.dart';

class AirmanshipBadgesCubit extends Cubit<AirmanshipBadgesState> {
  AirmanshipBadgesCubit()
      : super(
    const AirmanshipBadgesState(
      categories: [
        AirmanshipBadgeModel(
          title: 'Persistence',
          badges: [
            AirmanshipBadgeItemModel(
              title: 'Holding Pattern',
              icon: 'assets/images/badges/holding_pattern.png',
            ),
            AirmanshipBadgeItemModel(
              title: 'Transatlantic',
              icon: 'assets/images/badges/transatlantic.png',
            ),
            AirmanshipBadgeItemModel(
              title: 'Circumnavigation',
              icon: 'assets/images/badges/circumnavigation.png',
            ),
          ],
        ),

        AirmanshipBadgeModel(
          title: 'Returning',
          badges: [
            AirmanshipBadgeItemModel(
              title: 'Return to Base',
              icon: 'assets/images/badges/return_to_base.png',
            ),
            AirmanshipBadgeItemModel(
              title: 'Diversion',
              icon: 'assets/images/badges/diversion.png',
            ),
            AirmanshipBadgeItemModel(
              title: 'Go-Around',
              icon: 'assets/images/badges/go_around.png',
            ),
            AirmanshipBadgeItemModel(
              title: 'Wheels Up',
              icon: 'assets/images/badges/wheels_up.png',
            ),
          ],
        ),

        AirmanshipBadgeModel(
          title: 'Experience',
          badges: [
            AirmanshipBadgeItemModel(
              title: 'Short-haul',
              icon: 'assets/images/badges/short_haul.png',
            ),
            AirmanshipBadgeItemModel(
              title: 'Medium-haul',
              icon: 'assets/images/badges/medium_haul.png',
            ),
            AirmanshipBadgeItemModel(
              title: 'Long-haul',
              icon: 'assets/images/badges/long_haul.png',
            ),
          ],
        ),

        AirmanshipBadgeModel(
          title: 'Mastery',
          badges: [
            AirmanshipBadgeItemModel(
              title: 'Multi-Type Rated',
              icon: 'assets/images/badges/multi_type_rated.png',
            ),
            AirmanshipBadgeItemModel(
              title: 'Full Fleet',
              icon: 'assets/images/badges/full_fleet.png',
            ),
            AirmanshipBadgeItemModel(
              title: 'Master Aviator',
              icon: 'assets/images/badges/master_aviator.png',
            ),
          ],
        ),
      ],
    ),
  );
}