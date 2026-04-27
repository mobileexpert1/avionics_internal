import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../Constants/ApiClass/FirebaseAnalytics/analytics_service.dart';
import '../../../Constants/ApiClass/FirebaseAnalytics/event_names.dart';
import '../../../Constants/AppColors.dart';
import '../../../Constants/constantImages.dart';
import '../../../Helpers/AppTextStyles/AppTextStyles.dart';
import '../../../Helpers/CacheManger/CachedImageFile.dart';
import '../../../Helpers/CustomDivider.dart';
import '../../../bloc/MapSection/flight_Map_Cubit.dart';
import '../../../bloc/MapSection/flight_map_detailModel.dart';
import '../../../bloc/MapSection/flight_map_state.dart';
import '../FlightTrackScreen.dart';
import '../MapHelpers/FlightDetailScreen.dart';
import '../MapHelpers/FlightDetailScreenForMapSection.dart';
import '../MapHelpers/LiveBadge.dart';

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
                padding: const EdgeInsets.fromLTRB(20, 25, 20, 0),
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
                                      maxWidth: 220,
                                    ),
                                    child: Text(
                                      "A320-200",
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTextStyles.bold(24).copyWith(
                                        height: 1.0,
                                        color: AppColors.primaryValueColour,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryBlue,
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      category,
                                      style: AppTextStyles.regular(12).copyWith(
                                        height: 1.0,
                                        color: AppColors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 20),
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
                                            width: 25,
                                            height: 19,
                                            fit: BoxFit.fill,
                                          )
                                        : CachedAnyImage(
                                            imagePath: manufacturerLogo,
                                            width: 25,
                                            height: 19,
                                            contentImage: BoxFit.contain,
                                            useCache: false,
                                          ),
                                  ),

                                  Text(
                                    manufacturer,
                                    style: AppTextStyles.semiBold(14).copyWith(
                                      height: 1.0,
                                      color: AppColors.primaryValueColour,
                                    ),
                                  ),

                                  SizedBox(width: 5),

                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 7,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF3F3D56),
                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ),
                                        ),
                                        child: Text(
                                          callSign,
                                          style: AppTextStyles.regular(12)
                                              .copyWith(
                                                height: 1.0,
                                                color: AppColors.white,
                                              ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                InkWell(
                                  borderRadius: BorderRadius.circular(6),
                                  onTap: () {
                                    if (isComeFromLiveTracking == true) {
                                      context
                                          .read<FlightMapCubit>()
                                          .stopTrackingFlight();
                                      Navigator.pop(context, flightId);
                                    } else {
                                      AnalyticsService.instance.buttonPressed(
                                        FirebaseEvents.trackAFlightButton,
                                        FirebaseEvents.trackScreen,
                                      );

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => BlocProvider.value(
                                            value: context
                                                .read<FlightMapCubit>(),
                                            child: TrackFlightScreen(
                                              flightNumber: flightNumber,
                                              initialFlight: selectedFlight,
                                              initialFlightDetail: detail,
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
                                SizedBox(width: 10),
                                InkWell(
                                  borderRadius: BorderRadius.circular(6),
                                  onTap: () {
                                    if (isComeFromLiveTracking == true) {
                                      context
                                          .read<FlightMapCubit>()
                                          .stopTrackingFlight();
                                      Navigator.pop(context, flightId);
                                    } else {
                                      AnalyticsService.instance.buttonPressed(
                                        FirebaseEvents.trackAFlightButton,
                                        FirebaseEvents.trackScreen,
                                      );

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => BlocProvider.value(
                                            value: context
                                                .read<FlightMapCubit>(),
                                            child: TrackFlightScreen(
                                              flightNumber: flightNumber,
                                              initialFlight: selectedFlight,
                                              initialFlightDetail: detail,
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
                            SizedBox(height: 10),
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
                                      height: 30,
                                      contentImage: BoxFit.contain,
                                      useCache: false,
                                    ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const CustomDivider(height: 0.5),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: "$departureCity\n",
                                  style: AppTextStyles.semiRegular(16).copyWith(
                                    height: 1.2,
                                    color: AppColors.black,
                                  ),
                                ),
                                TextSpan(
                                  text: "$departureIata\n",
                                  style: AppTextStyles.bold(20).copyWith(
                                    height: 1.4,
                                    color: AppColors.primaryValueColour,
                                  ),
                                ),
                                TextSpan(
                                  text: timeSinceTakeoff,
                                  style: AppTextStyles.semiRegular(14).copyWith(
                                    height: 1.6,
                                    color: AppColors.grayMedium,
                                  ),
                                ),
                              ],
                            ),
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
                                      style: AppTextStyles.regular(14).copyWith(
                                        height: 1.0,
                                        color: AppColors.primaryBlue,
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
                                      style: AppTextStyles.regular(14).copyWith(
                                        height: 1.0,
                                        color: AppColors.primaryBlue,
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
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: "$arrivalCity\n",
                                  style: AppTextStyles.semiRegular(16).copyWith(
                                    height: 1.2,
                                    color: AppColors.black,
                                  ),
                                ),
                                TextSpan(
                                  text: "$arrivalIata\n",
                                  style: AppTextStyles.bold(20).copyWith(
                                    height: 1.4,
                                    color: AppColors.primaryValueColour,
                                  ),
                                ),
                                TextSpan(
                                  text: timeToArrival,
                                  style: AppTextStyles.semiRegular(14).copyWith(
                                    height: 1.6,
                                    color: AppColors.grayMedium,
                                  ),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                    Material(
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
                                detail?.vspeed ?? selectedFlight?.verticalSpeed,
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
                                child: FlightDetailScreenForMapSection(
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
                            children: [
                              Text(
                                "View Details",
                                style: AppTextStyles.bold(18).copyWith(
                                  height: 1.0,
                                  color: AppColors.primaryValueColour,
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Icon(
                                Icons.arrow_forward_ios,
                                size: 15,
                                color: AppColors.primaryValueColour,
                              ),
                            ],
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
