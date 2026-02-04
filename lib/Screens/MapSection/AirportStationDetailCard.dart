import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Helpers/Custom_widget.dart';
import '../../bloc/MapSection/AircraftStationList/aircraft_Station_List_Model.dart';

class AirportStationDetailCard extends StatelessWidget {
  final AircraftStationModel? airportDetail;
  final bool? isComeFromLiveTracking;
  final VoidCallback? callBackForHideFlightCard;

  const AirportStationDetailCard({
    super.key,
    this.callBackForHideFlightCard,
    this.airportDetail,
    this.isComeFromLiveTracking,
  });

  @override
  Widget build(BuildContext context) {
    final detail = airportDetail;
    if (detail == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return GestureDetector(
      onTap: callBackForHideFlightCard,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
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
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "Airport Details",
                    style: TextStyle(
                      color: Color(0xFF3E3C55),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: customField(
                      label: 'Name',
                      text: detail.name == "" ? "N/A" : detail.name,
                      labelColor: const Color(0xFF3E3C55),
                      textColor: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: customField(
                      label: 'City',
                      text: detail.city == "" ? "N/A" : detail.city,
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
                      text: detail.state == "" ? "N/A" : detail.state,
                      labelColor: const Color(0xFF3E3C55),
                      textColor: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: customField(
                      label: 'Country',
                      text: detail.country == "" ? "N/A" : detail.country,
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
                      label: 'Elevation(m)',
                      text: detail.elev.toString() == ""
                          ? "N/A"
                          : detail.elev.toString(),
                      labelColor: const Color(0xFF3E3C55),
                      textColor: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: customField(
                      label: 'Runway Length(m)',
                      text: detail.runwayLength.toString() == ""
                          ? "N/A"
                          : detail.runwayLength.toString(),
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
                      label: 'ICAO Code',
                      text: detail.icao == "" ? "N/A" : detail.icao ?? "",
                      labelColor: const Color(0xFF3E3C55),
                      textColor: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: customField(
                      label: 'IATA Code',
                      text: detail.iataCode == ""
                          ? "N/A"
                          : detail.iataCode ?? "",
                      labelColor: const Color(0xFF3E3C55),
                      textColor: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
