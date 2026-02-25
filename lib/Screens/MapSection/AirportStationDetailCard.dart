import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../Helpers/Custom_widget.dart';
import '../../bloc/MapSection/AircraftStationList/aircraft_Station_List_Model.dart';

class AirportStationDetailCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final detail = airportDetail;
    if (detail == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final List<Widget> children = segmentIndex == 0
        ? [
            Row(
              children: [
                Expanded(
                  child: customField(
                    label: 'Name',
                    text: detail.valueOrNA(detail.name),
                    labelColor: const Color(0xFF3E3C55),
                    textColor: Colors.black,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: customField(
                    label: 'City',
                    text: detail.valueOrNA(detail.city),
                    labelColor: const Color(0xFF3E3C55),
                    textColor: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: customField(
                    label: 'State',
                    text: detail.valueOrNA(detail.state),
                    labelColor: const Color(0xFF3E3C55),
                    textColor: Colors.black,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: customField(
                    label: 'Country',
                    text: detail.valueOrNA(detail.country),
                    labelColor: const Color(0xFF3E3C55),
                    textColor: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: customField(
                    label: 'IATA/ICAO Code ',
                    text:
                        "${detail.valueOrNA(detail.iataCode)} / "
                        "${detail.valueOrNA(detail.icao)}",
                    labelColor: const Color(0xFF3E3C55),
                    textColor: Colors.black,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: customField(
                    label: 'Terminal(s) No',
                    text: detail.valueOrNA(detail.numberOfTerminals),
                    labelColor: const Color(0xFF3E3C55),
                    textColor: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: customField(
                    label: 'Time Zone',
                    text: detail.valueOrNA(detail.timezone),
                    labelColor: const Color(0xFF3E3C55),
                    textColor: Colors.black,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: customField(
                    label: 'UTC',
                    text: detail.valueOrNA(detail.utcOffset),
                    labelColor: const Color(0xFF3E3C55),
                    textColor: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
          ]
        : [
            Row(
              children: [
                Expanded(
                  child: customField(
                    label: 'Type',
                    text: detail.valueOrNA(detail.type),
                    labelColor: const Color(0xFF3E3C55),
                    textColor: Colors.black,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: customField(
                    label: 'Runway(s) No',
                    text: detail.valueOrNA(detail.numberOfRunways),
                    labelColor: const Color(0xFF3E3C55),
                    textColor: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: customField(
                    label: 'Runway(s) direction ',
                    text: detail.valueOrNA(detail.runwayDirection),
                    labelColor: const Color(0xFF3E3C55),
                    textColor: Colors.black,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: customField(
                    label: 'Runway(s) elevation (ft)',
                    text: detail.valueOrNA(detail.elev),
                    labelColor: const Color(0xFF3E3C55),
                    textColor: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: customField(
                    label: 'Runway(s) length (m)',
                    text: detail.valueOrNA(detail.runwayLength),
                    labelColor: const Color(0xFF3E3C55),
                    textColor: Colors.black,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: customField(
                    label: 'Runway(s) surface type',
                    text: detail.valueOrNA(detail.runwaySurfaceType),
                    labelColor: const Color(0xFF3E3C55),
                    textColor: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
          ];

    return GestureDetector(
      onTap: callBackForHideFlightCard,
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
          child: SingleChildScrollView(child: Column(children: children)),
        ),
      ),
    );
  }
}
