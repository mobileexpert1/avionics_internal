class ComparisonModel {
  final String detail;
  final AircraftData aircraft1;
  final AircraftData aircraft2;

  ComparisonModel({
    required this.detail,
    required this.aircraft1,
    required this.aircraft2,
  });

  factory ComparisonModel.fromJson(Map<String, dynamic> json) {
    return ComparisonModel(
      detail: json['detail'],
      aircraft1: AircraftData.fromJson(json['aircraft_1']),
      aircraft2: AircraftData.fromJson(json['aircraft_2']),
    );
  }
}


class AircraftData {
  final GeneralData general;
  final TechnicalData technicalData;
  final OperationalData operationalData;

  AircraftData({
    required this.general,
    required this.technicalData,
    required this.operationalData,
  });

  factory AircraftData.fromJson(Map<String, dynamic> json) {
    return AircraftData(
      general: GeneralData.fromJson(json['general']),
      technicalData: TechnicalData.fromJson(json['technical_data']),
      operationalData: OperationalData.fromJson(json['operational_data']),
    );
  }
}


class GeneralData {
  final String icaoTypeCode;
  final String wakeTurbulenceCategory;
  final String avionicsSystemNameFamily;
  final int noOfEngines;
  final String engineManufacturerAndModel;
  final String engineType;

  GeneralData({
    required this.icaoTypeCode,
    required this.wakeTurbulenceCategory,
    required this.avionicsSystemNameFamily,
    required this.noOfEngines,
    required this.engineManufacturerAndModel,
    required this.engineType,
  });

  factory GeneralData.fromJson(Map<String, dynamic> json) {
    return GeneralData(
      icaoTypeCode: json['icao_type_code'],
      wakeTurbulenceCategory: json['wake_turbulence_category'],
      avionicsSystemNameFamily: json['avionics_system_name_family'],
      noOfEngines: json['no_of_engines'],
      engineManufacturerAndModel: json['engine_manufacturer_and_model'],
      engineType: json['engine_type'],
    );
  }
}


class TechnicalData {
  final DimensionData wingspan;
  final DimensionData length;
  final DimensionData height;
  final String mtow;
  final String maxPayload;

  TechnicalData({
    required this.wingspan,
    required this.length,
    required this.height,
    required this.mtow,
    required this.maxPayload,
  });

  factory TechnicalData.fromJson(Map<String, dynamic> json) {
    return TechnicalData(
      wingspan: DimensionData.fromJson(json['wingspan_m_and_ft']),
      length: DimensionData.fromJson(json['length']),
      height: DimensionData.fromJson(json['height']),
      mtow: json['mtow'] ?? '',
      maxPayload: json['max_payload'] ?? '',
    );
  }
}

class DimensionData {
  final String meters;
  final String feet;

  DimensionData({
    required this.meters,
    required this.feet,
  });

  factory DimensionData.fromJson(Map<String, dynamic> json) {
    return DimensionData(
      meters: json.values.first.toString(),
      feet: json.values.last.toString(),
    );
  }
}


class OperationalData {
  final String takeoffSpeedKts;
  final String serviceCeilingFtFl;
  final String maxCertifiedAltitudeFtFl;
  final CruiseSpeed cruiseSpeed;
  final Range range;
  final String initialRateOfDescentFpm;
  final String averageRateOfDescentFpm;
  final String minimumCleanSpeedKts;
  final String approachSpeedKts;
  final String landingSpeedKts;
  final String landingDistanceM;
  final String runwayLengthRequiredM;
  final String stallSpeedIfAvailable;

  OperationalData({
    required this.takeoffSpeedKts,
    required this.serviceCeilingFtFl,
    required this.maxCertifiedAltitudeFtFl,
    required this.cruiseSpeed,
    required this.range,
    required this.initialRateOfDescentFpm,
    required this.averageRateOfDescentFpm,
    required this.minimumCleanSpeedKts,
    required this.approachSpeedKts,
    required this.landingSpeedKts,
    required this.landingDistanceM,
    required this.runwayLengthRequiredM,
    required this.stallSpeedIfAvailable,
  });

  factory OperationalData.fromJson(Map<String, dynamic> json) {
    return OperationalData(
      takeoffSpeedKts: json['takeoff_speed_kts'],
      serviceCeilingFtFl: json['service_ceiling_ft_fl'],
      maxCertifiedAltitudeFtFl: json['max_certified_altitude_ft_fl'],
      cruiseSpeed: CruiseSpeed.fromJson(json['cruise_speed_kts_mach']),
      range: Range.fromJson(json['range']),
      initialRateOfDescentFpm: json['initial_rate_of_descent_fpm'],
      averageRateOfDescentFpm: json['average_rate_of_descent_fpm'],
      minimumCleanSpeedKts: json['minimum_clean_speed_kts'],
      approachSpeedKts: json['approach_speed_kts'],
      landingSpeedKts: json['landing_speed_kts'],
      landingDistanceM: json['landing_distance_m'],
      runwayLengthRequiredM: json['runway_length_required_m'],
      stallSpeedIfAvailable: json['stall_speed_if_available'],
    );
  }
}

class CruiseSpeed {
  final String cruiseKt;
  final String cruiseMach;

  CruiseSpeed({
    required this.cruiseKt,
    required this.cruiseMach,
  });

  factory CruiseSpeed.fromJson(Map<String, dynamic> json) {
    return CruiseSpeed(
      cruiseKt: json['Cruise_Speed_kt'],
      cruiseMach: json['Cruise_Mach'],
    );
  }
}

class Range {
  final String ferryRangeNm;
  final String normalRangeNm;
  final String normalRangeKm;

  Range({
    required this.ferryRangeNm,
    required this.normalRangeNm,
    required this.normalRangeKm,
  });

  factory Range.fromJson(Map<String, dynamic> json) {
    return Range(
      ferryRangeNm: json['Ferry_Range_NM'],
      normalRangeNm: json['Normal_Range_NM'],
      normalRangeKm: json['Normal_Range_km'],
    );
  }
}



class ComparisonFilterItem {
  final String key;
  final String value;
  bool isSelected;

  ComparisonFilterItem({required this.key, required this.value, this.isSelected = false});
}
