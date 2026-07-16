import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../Constants/AppColors.dart';
import '../../../Helpers/AppTextStyles/AppTextStyles.dart';
import '../../../Helpers/Custom_widget.dart';
import '../../../bloc/MapSection/AircraftStationList/aircraft_Station_List_Model.dart';

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
  final labelColor = AppColors.primaryValueColour;
  final valueColor = AppColors.primaryValueColour;

  // final subSegmentOptions = const [
  //   'General info',
  //   'Ops Info',
  //   'Ops Statistics',
  // ];

  final subSegmentOptions = const ['Runway Info', 'MET & Traffic'];

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
          borderRadius: kIsWeb
              ? const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          )
              : const BorderRadius.only(
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
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
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
      customFieldForTextAndValue(
        false,
        fields: [
          ["Name", detail.name],
          [
            "IATA/ICAO Code",
            "${detail.valueOrNA(detail.iataCode)} / ${detail.valueOrNA(detail.icao)}",
          ],
          ["City, State", "${detail.city}, ${detail.state}"],
          //["State", detail.state],
          ["Country", detail.country],
          ["Time Zone", detail.timezone],
          ["Type", detail.runwaySurfaceType.toString()],
        ],
        context: context,
      ),
      if (detail.websiteUrl != null &&
          detail.websiteUrl!.isNotEmpty &&
          detail.websiteUrl != "N/A") ...[
        buildActionText("Visit Airport Website", () {
          if (detail.websiteUrl != null && detail.websiteUrl!.isNotEmpty) {
            _openUrl(detail.websiteUrl!);
          }
        }),
      ],
    ];
  }

  /// -------- More Details --------
  List<Widget> _buildMoreDetails(AircraftStationModel detail) {
    return [
      RadioChips(
        values: subSegmentOptions,
        selectedIndex: subSegmentIndex,
        onSelected: (i) => setState(() => subSegmentIndex = i),
        isForFlightScreen: true,
      ),
      const SizedBox(height: 15),
      if (subSegmentIndex == 0) ...[
        customFieldForTextAndValue(
          false,
          fields: [
            ["Terminal(s) No", detail.numberOfTerminals.toString()],
            ["Runway(s) No", detail.numberOfRunways.toString()],
            ["Runway Surface", detail.runwaySurfaceType.toString()],
            ["Runway(s) Directions", detail.runwayDirection.toString()],
            ["Runway(s) Elevation", detail.runwaySurfaceType.toString()],
            ["Runway(s) Length", detail.runwayLength.toString()],
          ],
          context: context,
        ),
      ],
      if (subSegmentIndex == 1) ...[
        customFieldForTextAndValue(
          false,
          fields: [
            ["Annual Movements (approx.)", detail.annualMovements.toString()],
            [
              "Annual Passenger Traffic (approx.)",
              detail.annualPassengerTraffic.toString(),
            ],
          ],
          context: context,
        ),

        if (detail.airportWeatherUrl != null &&
            detail.airportWeatherUrl!.isNotEmpty &&
            detail.airportWeatherUrl != "N/A") ...[
          buildActionText("Airport Weather & More", () {
            if (detail.airportWeatherUrl != null &&
                detail.airportWeatherUrl!.isNotEmpty) {
              _openUrl(detail.airportWeatherUrl!);
            }
          }),
        ],
      ],
    ];
  }
}

class RadioChips extends StatelessWidget {
  final List<String> values;
  final int selectedIndex;
  final bool isForFlightScreen;
  final Function(int) onSelected;

  const RadioChips({
    super.key,
    required this.values,
    required this.isForFlightScreen,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: isForFlightScreen ? MainAxisSize.max : MainAxisSize.min,
        children: List.generate(values.length, (index) {
          final selected = index == selectedIndex;
          return GestureDetector(
            onTap: () => onSelected(index),
            child: Container(
              height: 35,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: selected
                    ? AppColors.primaryBlue
                    : AppColors.greyForAirportDetailCard,
              ),
              child: Text(
                values[index],
                style: AppTextStyles.bold(12).copyWith(
                  height: 1.0,
                  color: selected ? AppColors.white : AppColors.grayMedium,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

Widget buildActionText(String title, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.primaryBlue,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 6),
        const Icon(
          Icons.arrow_forward_ios,
          size: 14,
          color: AppColors.primaryBlue,
        ),
      ],
    ),
  );
}

void _openUrl(String url) async {
  final Uri uri = Uri.parse(url);

  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
