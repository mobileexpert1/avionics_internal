import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../Constants/ApiClass/FirebaseAnalytics/analytics_service.dart';
import '../../Constants/ApiClass/FirebaseAnalytics/event_names.dart';
import '../../Constants/constantImages.dart';
import '../../Helpers/CacheManger/CachedImageFile.dart';
import '../../Helpers/CustomDivider.dart';
import '../../bloc/MapSection/flight_Map_Cubit.dart';
import '../../bloc/MapSection/flight_map_detailModel.dart';
import '../../bloc/MapSection/flight_map_state.dart';
import 'FlightTrackScreen.dart';
import 'MapHelpers/FlightDetailScreen.dart';
import 'MapHelpers/LiveBadge.dart';

class FlightDetailCard extends StatelessWidget {
  final FlightAircraftDetail? flightDetail;
  final bool? isComeFromLiveTracking;
  final VoidCallback? callBackForHideFlightCard;

  const FlightDetailCard({
    super.key,
    this.callBackForHideFlightCard,
    this.flightDetail,
    this.isComeFromLiveTracking,
  });

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    if (hours == 0 && minutes == 0) {
      return '0 min';
    } else if (hours == 0) {
      return '$minutes min';
    } else if (minutes == 0) {
      return '$hours h';
    } else {
      return '${hours}h ${minutes}min';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: kIsWeb ? 400.0 : 0.0),
      child: BlocBuilder<FlightMapCubit, FlightMapState>(
        builder: (context, state) {
          final selectedFlight = state.selectedFlight;
          final detail = flightDetail;

          if (selectedFlight == null && detail == null) {
            return const Text('No flight selected');
          }

          final groundSpeed =
              detail?.groundSpeed ?? selectedFlight?.groundSpeed ?? 0;
          final altitude = detail?.altitude ?? selectedFlight?.altitude ?? 0;
          final eta = detail?.eta ?? selectedFlight?.eta;
          final takeoffTime = detail?.takeoffTime;

          final aircraftType = detail?.aircraftModel ?? 'N/A';
          final manufacturer = detail?.manufacturer?.companyName ?? "N/A";
          final category = detail?.icaoTypeCode ?? detail?.type ?? "";
          final image = detail?.image ?? "";
          final airlineLogo = detail?.manufacturer?.airlineLogo ?? "";

          final airlineName =
              (detail?.manufacturer?.airlineName?.isNotEmpty ?? false)
              ? detail!.manufacturer!.airlineName!
              : 'N/A';

          final manufacturerLogo = detail?.manufacturer?.logo ?? "";
          final callSign =
              detail?.callsign ?? selectedFlight?.callSign ?? 'N/A';
          final departureIata = detail?.departureIcao ?? 'N/A';
          final arrivalIata = detail?.arrivalIcao ?? 'N/A';
          final flightNumber =
              selectedFlight?.flightNumber ?? detail?.flightNumber ?? '';

          final flightId = selectedFlight?.id ?? detail?.id ?? '';

          String timeSinceTakeoff = 'N/A';

          if (takeoffTime != null) {
            final duration = DateTime.now().toUtc().difference(takeoffTime);
            timeSinceTakeoff = '${_formatDuration(duration)} ago';
          }

          String timeToArrival = 'N/A';
          if (eta != null) {
            final duration = eta.difference(DateTime.now().toUtc());
            timeToArrival = duration.isNegative
                ? 'Landed'
                : 'in ${_formatDuration(duration)}';
          }

          double progress = 0.0;

          if (takeoffTime != null && eta != null) {
            final takeoffMillis = takeoffTime.millisecondsSinceEpoch;
            final etaMillis = eta.millisecondsSinceEpoch;
            final nowMillis = DateTime.now().toUtc().millisecondsSinceEpoch;

            final totalDuration = etaMillis - takeoffMillis;
            final elapsed = nowMillis - takeoffMillis;

            if (totalDuration > 0) {
              progress = (elapsed / totalDuration).clamp(0.0, 1.0);
            }
          }

          final departureCity = detail?.originAirport?.city ?? 'N/A';
          final arrivalCity = detail?.destinationAirport?.city ?? 'N/A';

          return GestureDetector(
            onTap: callBackForHideFlightCard,
            child: Card(
              color: Colors.white,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              elevation: 10,
              margin: EdgeInsets.zero,
              child: Padding(
                // padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                padding: const EdgeInsets.fromLTRB(20, 35, 20, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Wrap(
                                spacing: 8,
                                runSpacing: 6,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  ConstrainedBox(
                                    constraints: const BoxConstraints(
                                      maxWidth: 220, // prevents touching logo
                                    ),
                                    child: Text(
                                      aircraftType,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF3F3D56),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      category,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF3F3D56),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 4),
                              Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(6),
                                    child: manufacturerLogo.isEmpty
                                        ? SvgPicture.asset(
                                            CommonUi.setSvgImage(
                                              AssetsPath.manufacturer,
                                            ),
                                            width: 22,
                                            height: 16,
                                            fit: BoxFit.fill,
                                          )
                                        : CachedAnyImage(
                                            imagePath: manufacturerLogo,
                                            width: 22,
                                            height: 16,
                                            contentImage: BoxFit.contain,
                                            useCache: false,
                                          ),
                                  ),
                                  Text(
                                    manufacturer,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF3F3D56),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),

                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // CallSign Box
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 18,
                                          vertical: 3,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF3F3D56),
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                        child: Text(
                                          callSign,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      InkWell(
                                        borderRadius: BorderRadius.circular(6),
                                        onTap: () {
                                          if (isComeFromLiveTracking == true) {
                                            context
                                                .read<FlightMapCubit>()
                                                .stopTrackingFlight();
                                            Navigator.pop(context, flightId);
                                          } else {
                                            AnalyticsService.instance
                                                .buttonPressed(
                                                  FirebaseEvents
                                                      .trackAFlightButton,
                                                  FirebaseEvents.trackScreen,
                                                );

                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    BlocProvider.value(
                                                      value: context
                                                          .read<
                                                            FlightMapCubit
                                                          >(),
                                                      child: TrackFlightScreen(
                                                        flightNumber:
                                                            flightNumber,
                                                        initialFlight:
                                                            selectedFlight,
                                                        initialFlightDetail:
                                                            detail,
                                                        flightId: flightId,
                                                      ),
                                                    ),
                                              ),
                                            );
                                          }
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(4),
                                          child: state.isTracking
                                              ? const LiveBadge()
                                              : const Icon(
                                                  Icons.my_location,
                                                  color: Colors.blue,
                                                  size: 20,
                                                ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: airlineLogo.isEmpty
                                  ? SvgPicture.asset(
                                      CommonUi.setSvgImage(
                                        AssetsPath.airbusplane,
                                      ),
                                      width: 100,
                                      height: 30,
                                      fit: BoxFit.fill,
                                    )
                                  : CachedAnyImage(
                                      imagePath: airlineLogo,
                                      width: 100,
                                      height: 20,
                                      contentImage: BoxFit.contain,
                                      useCache: false,
                                    ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              airlineName,
                              style: const TextStyle(
                                fontSize: 15,
                                color: Color(0xFF3F3D56),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const CustomDivider(height: 1.0),
                    const SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            "$departureCity\n$departureIata\n$timeSinceTakeoff",
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Column(
                            children: [
                              LinearProgressIndicator(
                                value: progress,
                                backgroundColor: Colors.grey.shade300,
                                color: Colors.blue,
                                minHeight: 5,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Flexible(
                                    child: Text(
                                      groundSpeed == 0
                                          ? 'N/A'
                                          : '$groundSpeed km/h',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 3),
                                  const Text(
                                    "•",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  const SizedBox(width: 3),
                                  Flexible(
                                    child: Text(
                                      altitude == 0 ? 'N/A' : '$altitude m',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            "$arrivalCity\n$arrivalIata\n$timeToArrival",
                            style: const TextStyle(fontSize: 13),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: Colors.grey.shade300,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            final combinedDetail = detail?.copyWith(
                              latitude:
                                  (detail?.latitude != null &&
                                      detail!.latitude != 0.0)
                                  ? detail.latitude
                                  : selectedFlight?.latitude,
                              longitude:
                                  (detail?.longitude != null &&
                                      detail!.longitude != 0.0)
                                  ? detail.longitude
                                  : selectedFlight?.longitude,
                              groundSpeed:
                                  detail?.groundSpeed ??
                                  selectedFlight?.groundSpeed,
                              altitude:
                                  detail?.altitude ?? selectedFlight?.altitude,
                              takeoffTime:
                                  detail?.takeoffTime ??
                                  selectedFlight?.takeoffTime,
                              eta: detail?.eta ?? selectedFlight?.eta,
                              flightNumber:
                                  detail?.flightNumber ??
                                  selectedFlight?.flightNumber,
                              registration:
                                  detail?.registration ??
                                  selectedFlight?.registration,
                              callsign:
                                  detail?.callsign ?? selectedFlight?.callSign,
                              track: detail?.track ?? selectedFlight?.track,
                              vspeed:
                                  detail?.vspeed ??
                                  selectedFlight?.verticalSpeed,
                              source: detail?.source ?? selectedFlight?.source,
                              squawk: detail?.squawk ?? selectedFlight?.squawk,
                              flightTime:
                                  detail?.flightTime ??
                                  selectedFlight?.flightTime,
                            );

                            AnalyticsService.instance.buttonPressed(
                              FirebaseEvents.flightDetailScreen,
                              FirebaseEvents.trackScreen,
                            );

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BlocProvider.value(
                                  value: context.read<FlightMapCubit>(),
                                  child: FlightDetailScreen(
                                    ICAOType: category,
                                    flightDetail: combinedDetail,
                                  ),
                                ),
                              ),
                            );
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  "View Details",
                                  style: TextStyle(
                                    color: Color(0xFF3F3D56),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 14,
                                  color: Color(0xFF3F3D56),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
