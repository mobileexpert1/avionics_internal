import 'package:flutter_bloc/flutter_bloc.dart';
import 'ComparisonState.dart';
class ComparisonCubit extends Cubit<ComparisonState> {
  ComparisonCubit() : super(const ComparisonState(labels: [], a321Values: [], a322Values: []));

  void loadTechnicalData() {
    emit(const ComparisonState(
      labels: [
        'Crew',
        'PAX',
        'Length (ft/in)',
        'Wingspan (ft/in)',
        'Height (ft/in)',
        'Wingtip Conf.',
        'Main Gear Conf.',
        'MTOW (t)',
      ],
      a321Values: ['2', '/', '146.03', '111.88', '39.70', 'wingtip fences', 'D', '83.000'],
      a322Values: ['2', '/', '193.57', '197.83', '59.81', 'winglets', '2D', '242.000'],
    ));
  }

  void loadOperationalData() {
    emit(const ComparisonState(
      labels: [
        'TOD (m)',
        'V2 (IAS) kts',
        'RoC-Initial (ft/m)',
        'Max RoC (ft/m)',
        'CruiseSpeed TAS/Mach (kts/M)',
        'Max Speed TAS/Mach (kts/M)',
        'Cruising level',
        'Ceiling (ft)',
        'Absolute Ceiling (m)',
        'Max. Range (km)',
        'RoD avg',
        'Max. RoD (ft/min)',
        'V(MCS)',
        'Approach Category (APC)',
        'Vapp (IAS)',
        'V(ref) (IAS)',
        'Landing Distance (m)',
        'Fuel Consumption',
      ],
      a321Values: [
        '2',
        '/',
        '146.03',
        '111.88',
        '39.70',
        'wingtip fences',
        'D',
        '83.000',
        '83.000',
        '83.000',
        '83.000',
        '83.000',
        '83.000',
        '83.000',
        '83.000',
        '83.000',
        '83.000',
        '83.000'
      ],
      a322Values: [
        '2',
        '/',
        '193.57',
        '197.83',
        '59.81',
        'winglets',
        '2D',
        '242.000',
        '242.000',
        '242.000',
        '242.000',
        '242.000',
        '242.000',
        '242.000',
        '242.000',
        '242.000',
        '242.000',
        '242.000'
      ],
    ));
  }
}
