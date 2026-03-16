import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../Constants/AppColors.dart';
import '../../Helpers/Custom_widget.dart';
import '../../bloc/MapSection/AircraftStationList/aircraft_Station_List_Model.dart';

class AirportStationDetailCard extends StatefulWidget {
  final AircraftStationModel? airportDetail;
  final bool? isComeFromLiveTracking;
  final VoidCallback? callBackForHideFlightCard;
  final int segmentIndex;

  const AirportStationDetailCard({
    super.key,
    this.callBackForHideFlightCard,
    this.airportDetail,
    this.isComeFromLiveTracking,
    this.segmentIndex = 0,
  });

  @override
  State<AirportStationDetailCard> createState() =>
      _AirportStationDetailCardState();
}

class _AirportStationDetailCardState extends State<AirportStationDetailCard> {
  int subSegmentIndex = 0;

  final subSegmentOptions = const [
    'General info',
    'Ops Info',
    'Ops Statistics',
  ];

  @override
  Widget build(BuildContext context) {
    final detail = widget.airportDetail;

    if (detail == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return GestureDetector(
      onTap: widget.callBackForHideFlightCard,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(5),
            topRight: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
          child: SingleChildScrollView(
            child: Column(
              children: widget.segmentIndex == 0
                  ? _buildAirportDetails(detail)
                  : _buildMoreDetails(detail),
            ),
          ),
        ),
      ),
    );
  }

  /// -------- Airport Details --------

  List<Widget> _buildAirportDetails(AircraftStationModel detail) {
    return [
      _row(detail.name, "Name", detail.city, "City"),
      _row(detail.state, "State", detail.country, "Country"),
      _row(
        "${detail.valueOrNA(detail.elev)} ",
        "Elevation (m)",
        detail.runwayLength,
        "Runway Length (m)",
      ),
      _row(detail.icao, "ICAO Code", detail.iataCode, "IATA Code"),
    ];
  }

  /// -------- More Details --------

  List<Widget> _buildMoreDetails(AircraftStationModel detail) {
    return [
      RadioChips(
        values: subSegmentOptions,
        selectedIndex: subSegmentIndex,
        onSelected: (i) => setState(() => subSegmentIndex = i),
      ),
      const SizedBox(height: 20),

      if (subSegmentIndex == 0) ...[
        _row(detail.name, "Name", detail.city, "City"),
        _row(detail.state, "State", detail.country, "Country"),
        _row(
          "${detail.valueOrNA(detail.iataCode)} / ${detail.valueOrNA(detail.icao)}",
          "IATA/ICAO Code",
          detail.numberOfTerminals,
          "Terminal(s) No",
        ),
        _row(detail.timezone, "Time Zone", detail.utcOffset, "UTC"),
      ],

      if (subSegmentIndex == 1) ...[
        _row(
          detail.runwaySurfaceType,
          "Type",
          detail.runwayDirection,
          "Runway direction",
        ),
        _row(
          detail.runwayLength,
          "Runway length (m)",
          detail.numberOfRunways,
          "Runway(s) No",
        ),
        _row(
          detail.elev,
          "Runway elevation (ft)",
          detail.runwaySurfaceType,
          "Runway surface",
        ),
      ],

      if (subSegmentIndex == 2) ...[
        _row(
          detail.annualMovements,
          "Annual movements (approx.)",
          detail.annualPassengerTraffic,
          "Annual passenger traffic",
        ),
      ],
    ];
  }

  /// -------- Reusable Row --------

  Widget _row(dynamic value1, String label1, dynamic value2, String label2) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(child: _field(label1, value1)),
          const SizedBox(width: 10),
          Expanded(child: _field(label2, value2)),
        ],
      ),
    );
  }

  Widget _field(String label, dynamic value) {
    final detail = widget.airportDetail!;
    return customField(
      label: label,
      text: detail.valueOrNA(value),
      labelColor: const Color(0xFF3E3C55),
      textColor: Colors.black,
    );
  }
}

class RadioChips extends StatelessWidget {
  final List<String> values;
  final int selectedIndex;
  final Function(int) onSelected;

  const RadioChips({
    super.key,
    required this.values,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(values.length, (index) {
        final selected = index == selectedIndex;

        return GestureDetector(
          onTap: () => onSelected(index),
          child: Container(
            height: 30,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: selected ? AppColors.primaryBlue : Colors.grey[500],
            ),
            child: Text(
              values[index],
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
      }),
    );
  }
}
