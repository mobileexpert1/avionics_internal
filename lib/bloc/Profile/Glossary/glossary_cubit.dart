import 'package:flutter_bloc/flutter_bloc.dart';

import 'glossary_model.dart';
import 'glossary_state.dart';

class GlossaryCubit extends Cubit<GlossaryState> {
  GlossaryCubit() : super(const GlossaryState(glossaryData: {})) {
    loadGlossary();
  }

  void loadGlossary() {
    // Your glossary data here
    final data = {
      'A': [
        GlossaryItem(title: 'ADSHEX', description: 'Unique code for each airframe. Used as the unique identifier for ADS-B broadcasts.'),
        GlossaryItem(title: 'ATC Callsign', description: 'Used for air traffic control communication.'),
        GlossaryItem(title: 'ATC Callsign', description: ''),
      ],
      'B': [
        GlossaryItem(title: 'Barometer', description: 'Instrument for measuring atmospheric pressure.'),
        GlossaryItem(title: 'Barometer', description: ''),
      ],
      'C': [
        GlossaryItem(title: 'C', description: ''),
        GlossaryItem(title: 'C', description: ''),
      ],
      'D': [
        GlossaryItem(title: 'D', description: ''),
        GlossaryItem(title: 'D', description: ''),
      ],
    };
    emit(GlossaryState(glossaryData: data));
  }
}
