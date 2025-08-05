import 'dart:convert';

AirCraftDetailModel airCraftDetailModelFromJson(String str) => AirCraftDetailModel.fromJson(json.decode(str));

String airCraftDetailModelToJson(AirCraftDetailModel data) => json.encode(data.toJson());

class AirCraftDetailModel {
  String detail;
  Results results;

  AirCraftDetailModel({
    required this.detail,
    required this.results,
  });

  factory AirCraftDetailModel.fromJson(Map<String, dynamic> json) => AirCraftDetailModel(
    detail: json["detail"],
    results: Results.fromJson(json["results"]),
  );

  Map<String, dynamic> toJson() => {
    "detail": detail,
    "results": results.toJson(),
  };
}

class Results {
  String id;
  DateTime createdAt;
  DateTime updatedAt;
  IdentificationClassification identificationClassification;
  PowerplantPropulsion powerplantPropulsion;
  Dimensions dimensions;
  Weights weights;
  Performance performance;
  OperationalLimitations operationalLimitations;
  LandingGear landingGear;
  CertificationEnvironmental certificationEnvironmental;

  Results({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.identificationClassification,
    required this.powerplantPropulsion,
    required this.dimensions,
    required this.weights,
    required this.performance,
    required this.operationalLimitations,
    required this.landingGear,
    required this.certificationEnvironmental,
  });

  factory Results.fromJson(Map<String, dynamic> json) => Results(
    id: json["id"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    identificationClassification: IdentificationClassification.fromJson(json["IdentificationClassification"]),
    powerplantPropulsion: PowerplantPropulsion.fromJson(json["PowerplantPropulsion"]),
    dimensions: Dimensions.fromJson(json["Dimensions"]),
    weights: Weights.fromJson(json["Weights"]),
    performance: Performance.fromJson(json["Performance"]),
    operationalLimitations: OperationalLimitations.fromJson(json["OperationalLimitations"]),
    landingGear: LandingGear.fromJson(json["LandingGear"]),
    certificationEnvironmental: CertificationEnvironmental.fromJson(json["CertificationEnvironmental"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "IdentificationClassification": identificationClassification.toJson(),
    "PowerplantPropulsion": powerplantPropulsion.toJson(),
    "Dimensions": dimensions.toJson(),
    "Weights": weights.toJson(),
    "Performance": performance.toJson(),
    "OperationalLimitations": operationalLimitations.toJson(),
    "LandingGear": landingGear.toJson(),
    "CertificationEnvironmental": certificationEnvironmental.toJson(),
  };
}

class CertificationEnvironmental {
  String certificationBasis;
  String easaTcdsNumber;
  String faaTcdsNumber;
  String specialConditions;
  String noiseCompliance;
  String emissionsCategory;

  CertificationEnvironmental({
    required this.certificationBasis,
    required this.easaTcdsNumber,
    required this.faaTcdsNumber,
    required this.specialConditions,
    required this.noiseCompliance,
    required this.emissionsCategory,
  });

  factory CertificationEnvironmental.fromJson(Map<String, dynamic> json) => CertificationEnvironmental(
    certificationBasis: json["Certification_Basis"],
    easaTcdsNumber: json["EASA_TCDS_Number"],
    faaTcdsNumber: json["FAA_TCDS_Number"],
    specialConditions: json["Special_Conditions"],
    noiseCompliance: json["Noise_Compliance"],
    emissionsCategory: json["Emissions_Category"],
  );

  Map<String, dynamic> toJson() => {
    "Certification_Basis": certificationBasis,
    "EASA_TCDS_Number": easaTcdsNumber,
    "FAA_TCDS_Number": faaTcdsNumber,
    "Special_Conditions": specialConditions,
    "Noise_Compliance": noiseCompliance,
    "Emissions_Category": emissionsCategory,
  };
}

class Dimensions {
  double wingspanM;
  double wingspanFt;
  double lengthM;
  double lengthFt;
  double heightM;
  double heightFt;
  int wingAreaM2;
  double cabinWidthM;
  String doorHeightM;
  String wingtipConfiguration;

  Dimensions({
    required this.wingspanM,
    required this.wingspanFt,
    required this.lengthM,
    required this.lengthFt,
    required this.heightM,
    required this.heightFt,
    required this.wingAreaM2,
    required this.cabinWidthM,
    required this.doorHeightM,
    required this.wingtipConfiguration,
  });

  factory Dimensions.fromJson(Map<String, dynamic> json) => Dimensions(
    wingspanM: json["Wingspan_m"]?.toDouble(),
    wingspanFt: json["Wingspan_ft"]?.toDouble(),
    lengthM: json["Length_m"]?.toDouble(),
    lengthFt: json["Length_ft"]?.toDouble(),
    heightM: json["Height_m"]?.toDouble(),
    heightFt: json["Height_ft"]?.toDouble(),
    wingAreaM2: json["Wing_Area_m2"],
    cabinWidthM: json["Cabin_Width_m"]?.toDouble(),
    doorHeightM: json["Door_Height_m"],
    wingtipConfiguration: json["Wingtip_Configuration"],
  );

  Map<String, dynamic> toJson() => {
    "Wingspan_m": wingspanM,
    "Wingspan_ft": wingspanFt,
    "Length_m": lengthM,
    "Length_ft": lengthFt,
    "Height_m": heightM,
    "Height_ft": heightFt,
    "Wing_Area_m2": wingAreaM2,
    "Cabin_Width_m": cabinWidthM,
    "Door_Height_m": doorHeightM,
    "Wingtip_Configuration": wingtipConfiguration,
  };
}

class IdentificationClassification {
  String icaoTypeCode;
  String manufacturer;
  String aircraftModel;
  String aircraftRole;
  String aircraftType;
  String wakeTurbulenceCategory;
  String civilianMilitaryOrDualUse;
  String countryOfOrigin;
  DateTime dateOfMaidenFlight;
  String yearOfIntroduction;
  String productionStatus;
  String avionicsSystem;
  String numberOfCrew;
  NumberOfPassengers numberOfPassengers;

  IdentificationClassification({
    required this.icaoTypeCode,
    required this.manufacturer,
    required this.aircraftModel,
    required this.aircraftRole,
    required this.aircraftType,
    required this.wakeTurbulenceCategory,
    required this.civilianMilitaryOrDualUse,
    required this.countryOfOrigin,
    required this.dateOfMaidenFlight,
    required this.yearOfIntroduction,
    required this.productionStatus,
    required this.avionicsSystem,
    required this.numberOfCrew,
    required this.numberOfPassengers,
  });

  factory IdentificationClassification.fromJson(Map<String, dynamic> json) => IdentificationClassification(
    icaoTypeCode: json["ICAO_Type_Code"],
    manufacturer: json["Manufacturer"],
    aircraftModel: json["Aircraft_Model"],
    aircraftRole: json["Aircraft_Role"],
    aircraftType: json["Aircraft_Type"],
    wakeTurbulenceCategory: json["Wake_Turbulence_Category"],
    civilianMilitaryOrDualUse: json["Civilian_Military_or_Dual_Use"],
    countryOfOrigin: json["Country_of_Origin"],
    dateOfMaidenFlight: DateTime.parse(json["Date_of_Maiden_Flight"]),
    yearOfIntroduction: json["Year_of_Introduction"],
    productionStatus: json["Production_Status"],
    avionicsSystem: json["Avionics_System"],
    numberOfCrew: json["Number_of_Crew"],
    numberOfPassengers: NumberOfPassengers.fromJson(json["Number_of_Passengers"]),
  );

  Map<String, dynamic> toJson() => {
    "ICAO_Type_Code": icaoTypeCode,
    "Manufacturer": manufacturer,
    "Aircraft_Model": aircraftModel,
    "Aircraft_Role": aircraftRole,
    "Aircraft_Type": aircraftType,
    "Wake_Turbulence_Category": wakeTurbulenceCategory,
    "Civilian_Military_or_Dual_Use": civilianMilitaryOrDualUse,
    "Country_of_Origin": countryOfOrigin,
    "Date_of_Maiden_Flight": "${dateOfMaidenFlight.year.toString().padLeft(4, '0')}-${dateOfMaidenFlight.month.toString().padLeft(2, '0')}-${dateOfMaidenFlight.day.toString().padLeft(2, '0')}",
    "Year_of_Introduction": yearOfIntroduction,
    "Production_Status": productionStatus,
    "Avionics_System": avionicsSystem,
    "Number_of_Crew": numberOfCrew,
    "Number_of_Passengers": numberOfPassengers.toJson(),
  };
}

class NumberOfPassengers {
  String typical;
  String maximum;

  NumberOfPassengers({
    required this.typical,
    required this.maximum,
  });

  factory NumberOfPassengers.fromJson(Map<String, dynamic> json) => NumberOfPassengers(
    typical: json["Typical"],
    maximum: json["Maximum"],
  );

  Map<String, dynamic> toJson() => {
    "Typical": typical,
    "Maximum": maximum,
  };
}

class LandingGear {
  String type;
  int numberOfWheels;
  String tyreSizeInches;
  String tyrePressureBarPsi;

  LandingGear({
    required this.type,
    required this.numberOfWheels,
    required this.tyreSizeInches,
    required this.tyrePressureBarPsi,
  });

  factory LandingGear.fromJson(Map<String, dynamic> json) => LandingGear(
    type: json["Type"],
    numberOfWheels: json["Number_of_Wheels"],
    tyreSizeInches: json["Tyre_Size_inches"],
    tyrePressureBarPsi: json["Tyre_Pressure_bar_psi"],
  );

  Map<String, dynamic> toJson() => {
    "Type": type,
    "Number_of_Wheels": numberOfWheels,
    "Tyre_Size_inches": tyreSizeInches,
    "Tyre_Pressure_bar_psi": tyrePressureBarPsi,
  };
}

class OperationalLimitations {
  String runwaySlopeLimitPercent;
  String maxCrosswindNormalLawKts;
  String maxCrosswindDegradedLawKts;
  String maxTailwindLandingKts;
  String maxTailwindTakeoffKts;
  String fieldElevationLimitFt;
  String maxRunwayAltitudeFt;
  AutolandCapability autolandCapability;

  OperationalLimitations({
    required this.runwaySlopeLimitPercent,
    required this.maxCrosswindNormalLawKts,
    required this.maxCrosswindDegradedLawKts,
    required this.maxTailwindLandingKts,
    required this.maxTailwindTakeoffKts,
    required this.fieldElevationLimitFt,
    required this.maxRunwayAltitudeFt,
    required this.autolandCapability,
  });

  factory OperationalLimitations.fromJson(Map<String, dynamic> json) => OperationalLimitations(
    runwaySlopeLimitPercent: json["Runway_Slope_Limit_percent"],
    maxCrosswindNormalLawKts: json["Max_Crosswind_Normal_Law_kts"],
    maxCrosswindDegradedLawKts: json["Max_Crosswind_Degraded_Law_kts"],
    maxTailwindLandingKts: json["Max_Tailwind_Landing_kts"],
    maxTailwindTakeoffKts: json["Max_Tailwind_Takeoff_kts"],
    fieldElevationLimitFt: json["Field_Elevation_Limit_ft"],
    maxRunwayAltitudeFt: json["Max_Runway_Altitude_ft"],
    autolandCapability: AutolandCapability.fromJson(json["Autoland_Capability"]),
  );

  Map<String, dynamic> toJson() => {
    "Runway_Slope_Limit_percent": runwaySlopeLimitPercent,
    "Max_Crosswind_Normal_Law_kts": maxCrosswindNormalLawKts,
    "Max_Crosswind_Degraded_Law_kts": maxCrosswindDegradedLawKts,
    "Max_Tailwind_Landing_kts": maxTailwindLandingKts,
    "Max_Tailwind_Takeoff_kts": maxTailwindTakeoffKts,
    "Field_Elevation_Limit_ft": fieldElevationLimitFt,
    "Max_Runway_Altitude_ft": maxRunwayAltitudeFt,
    "Autoland_Capability": autolandCapability.toJson(),
  };
}

class AutolandCapability {
  String supportedCategories;
  String certifiedAutolandLevel;

  AutolandCapability({
    required this.supportedCategories,
    required this.certifiedAutolandLevel,
  });

  factory AutolandCapability.fromJson(Map<String, dynamic> json) => AutolandCapability(
    supportedCategories: json["Supported_Categories"],
    certifiedAutolandLevel: json["Certified_Autoland_Level"],
  );

  Map<String, dynamic> toJson() => {
    "Supported_Categories": supportedCategories,
    "Certified_Autoland_Level": certifiedAutolandLevel,
  };
}

class Performance {
  String takeoffSpeedKts;
  String takeoffDistanceM;
  String initialClimbRateFpm;
  String averageRateOfClimbFpm;
  String maximumRateOfClimbFpm;
  String serviceCeilingFt;
  String maxCertifiedAltitudeFt;
  String cruiseSpeedKt;
  String cruiseMach;
  String maximumCruiseSpeedKtsOrMach;
  String vmoKts;
  String mmoMach;
  Range range;
  String initialRateOfDescentFpm;
  String averageRateOfDescentFpm;
  int minimumCleanSpeedKts;
  String approachSpeedKts;
  String approachCategory;
  String landingSpeedKts;
  int landingDistanceM;
  String runwayLengthRequiredM;
  String stallSpeedKts;

  Performance({
    required this.takeoffSpeedKts,
    required this.takeoffDistanceM,
    required this.initialClimbRateFpm,
    required this.averageRateOfClimbFpm,
    required this.maximumRateOfClimbFpm,
    required this.serviceCeilingFt,
    required this.maxCertifiedAltitudeFt,
    required this.cruiseSpeedKt,
    required this.cruiseMach,
    required this.maximumCruiseSpeedKtsOrMach,
    required this.vmoKts,
    required this.mmoMach,
    required this.range,
    required this.initialRateOfDescentFpm,
    required this.averageRateOfDescentFpm,
    required this.minimumCleanSpeedKts,
    required this.approachSpeedKts,
    required this.approachCategory,
    required this.landingSpeedKts,
    required this.landingDistanceM,
    required this.runwayLengthRequiredM,
    required this.stallSpeedKts,
  });

  factory Performance.fromJson(Map<String, dynamic> json) => Performance(
    takeoffSpeedKts: json["Takeoff_Speed_kts"],
    takeoffDistanceM: json["Takeoff_Distance_m"],
    initialClimbRateFpm: json["Initial_Climb_Rate_fpm"],
    averageRateOfClimbFpm: json["Average_Rate_of_Climb_fpm"],
    maximumRateOfClimbFpm: json["Maximum_Rate_of_Climb_fpm"],
    serviceCeilingFt: json["Service_Ceiling_ft"],
    maxCertifiedAltitudeFt: json["Max_Certified_Altitude_ft"],
    cruiseSpeedKt: json["Cruise_Speed_kt"],
    cruiseMach: json["Cruise_Mach"],
    maximumCruiseSpeedKtsOrMach: json["Maximum_Cruise_Speed_kts_or_Mach"],
    vmoKts: json["VMO_kts"],
    mmoMach: json["MMO_Mach"],
    range: Range.fromJson(json["Range"]),
    initialRateOfDescentFpm: json["Initial_Rate_of_Descent_fpm"],
    averageRateOfDescentFpm: json["Average_Rate_of_Descent_fpm"],
    minimumCleanSpeedKts: json["Minimum_Clean_Speed_kts"],
    approachSpeedKts: json["Approach_Speed_kts"],
    approachCategory: json["Approach_Category"],
    landingSpeedKts: json["Landing_Speed_kts"],
    landingDistanceM: json["Landing_Distance_m"],
    runwayLengthRequiredM: json["Runway_Length_Required_m"],
    stallSpeedKts: json["Stall_Speed_kts"],
  );

  Map<String, dynamic> toJson() => {
    "Takeoff_Speed_kts": takeoffSpeedKts,
    "Takeoff_Distance_m": takeoffDistanceM,
    "Initial_Climb_Rate_fpm": initialClimbRateFpm,
    "Average_Rate_of_Climb_fpm": averageRateOfClimbFpm,
    "Maximum_Rate_of_Climb_fpm": maximumRateOfClimbFpm,
    "Service_Ceiling_ft": serviceCeilingFt,
    "Max_Certified_Altitude_ft": maxCertifiedAltitudeFt,
    "Cruise_Speed_kt": cruiseSpeedKt,
    "Cruise_Mach": cruiseMach,
    "Maximum_Cruise_Speed_kts_or_Mach": maximumCruiseSpeedKtsOrMach,
    "VMO_kts": vmoKts,
    "MMO_Mach": mmoMach,
    "Range": range.toJson(),
    "Initial_Rate_of_Descent_fpm": initialRateOfDescentFpm,
    "Average_Rate_of_Descent_fpm": averageRateOfDescentFpm,
    "Minimum_Clean_Speed_kts": minimumCleanSpeedKts,
    "Approach_Speed_kts": approachSpeedKts,
    "Approach_Category": approachCategory,
    "Landing_Speed_kts": landingSpeedKts,
    "Landing_Distance_m": landingDistanceM,
    "Runway_Length_Required_m": runwayLengthRequiredM,
    "Stall_Speed_kts": stallSpeedKts,
  };
}

class Range {
  String normalRangeNm;
  String normalRangeKm;
  String ferryRangeNm;

  Range({
    required this.normalRangeNm,
    required this.normalRangeKm,
    required this.ferryRangeNm,
  });

  factory Range.fromJson(Map<String, dynamic> json) => Range(
    normalRangeNm: json["Normal_Range_NM"],
    normalRangeKm: json["Normal_Range_km"],
    ferryRangeNm: json["Ferry_Range_NM"],
  );

  Map<String, dynamic> toJson() => {
    "Normal_Range_NM": normalRangeNm,
    "Normal_Range_km": normalRangeKm,
    "Ferry_Range_NM": ferryRangeNm,
  };
}

class PowerplantPropulsion {
  int numberOfEngines;
  Engine engine;
  String apuType;
  Fuel fuel;

  PowerplantPropulsion({
    required this.numberOfEngines,
    required this.engine,
    required this.apuType,
    required this.fuel,
  });

  factory PowerplantPropulsion.fromJson(Map<String, dynamic> json) => PowerplantPropulsion(
    numberOfEngines: json["Number_of_Engines"],
    engine: Engine.fromJson(json["Engine"]),
    apuType: json["APU_Type"],
    fuel: Fuel.fromJson(json["Fuel"]),
  );

  Map<String, dynamic> toJson() => {
    "Number_of_Engines": numberOfEngines,
    "Engine": engine.toJson(),
    "APU_Type": apuType,
    "Fuel": fuel.toJson(),
  };
}

class Engine {
  String manufacturer;
  String model;
  String engineType;
  String thrustPerEngineKNOrKW;
  String physicalEngineCode;

  Engine({
    required this.manufacturer,
    required this.model,
    required this.engineType,
    required this.thrustPerEngineKNOrKW,
    required this.physicalEngineCode,
  });

  factory Engine.fromJson(Map<String, dynamic> json) => Engine(
    manufacturer: json["Manufacturer"],
    model: json["Model"],
    engineType: json["Engine_Type"],
    thrustPerEngineKNOrKW: json["Thrust_Per_Engine_kN_or_kW"],
    physicalEngineCode: json["Physical_Engine_Code"],
  );

  Map<String, dynamic> toJson() => {
    "Manufacturer": manufacturer,
    "Model": model,
    "Engine_Type": engineType,
    "Thrust_Per_Engine_kN_or_kW": thrustPerEngineKNOrKW,
    "Physical_Engine_Code": physicalEngineCode,
  };
}

class Fuel {
  String fuelType;
  String fuelAdditives;
  String capacityLOrKg;
  String fuelBurnCruiseKgPerHr;

  Fuel({
    required this.fuelType,
    required this.fuelAdditives,
    required this.capacityLOrKg,
    required this.fuelBurnCruiseKgPerHr,
  });

  factory Fuel.fromJson(Map<String, dynamic> json) => Fuel(
    fuelType: json["Fuel_Type"],
    fuelAdditives: json["Fuel_Additives"],
    capacityLOrKg: json["Capacity_L_or_kg"],
    fuelBurnCruiseKgPerHr: json["Fuel_Burn_Cruise_kg_per_hr"],
  );

  Map<String, dynamic> toJson() => {
    "Fuel_Type": fuelType,
    "Fuel_Additives": fuelAdditives,
    "Capacity_L_or_kg": capacityLOrKg,
    "Fuel_Burn_Cruise_kg_per_hr": fuelBurnCruiseKgPerHr,
  };
}

class Weights {
  String operatingEmptyWeightKg;
  String maximumZeroFuelWeightKg;
  String maximumTakeoffWeightKg;
  String maximumPayloadKg;
  String maximumLandingWeightKg;
  BaggageOrCargoVolume baggageOrCargoVolume;

  Weights({
    required this.operatingEmptyWeightKg,
    required this.maximumZeroFuelWeightKg,
    required this.maximumTakeoffWeightKg,
    required this.maximumPayloadKg,
    required this.maximumLandingWeightKg,
    required this.baggageOrCargoVolume,
  });

  factory Weights.fromJson(Map<String, dynamic> json) => Weights(
    operatingEmptyWeightKg: json["Operating_Empty_Weight_kg"],
    maximumZeroFuelWeightKg: json["Maximum_Zero_Fuel_Weight_kg"],
    maximumTakeoffWeightKg: json["Maximum_Takeoff_Weight_kg"],
    maximumPayloadKg: json["Maximum_Payload_kg"],
    maximumLandingWeightKg: json["Maximum_Landing_Weight_kg"],
    baggageOrCargoVolume: BaggageOrCargoVolume.fromJson(json["Baggage_or_Cargo_Volume"]),
  );

  Map<String, dynamic> toJson() => {
    "Operating_Empty_Weight_kg": operatingEmptyWeightKg,
    "Maximum_Zero_Fuel_Weight_kg": maximumZeroFuelWeightKg,
    "Maximum_Takeoff_Weight_kg": maximumTakeoffWeightKg,
    "Maximum_Payload_kg": maximumPayloadKg,
    "Maximum_Landing_Weight_kg": maximumLandingWeightKg,
    "Baggage_or_Cargo_Volume": baggageOrCargoVolume.toJson(),
  };
}

class BaggageOrCargoVolume {
  int minimumM3;
  int maximumM3;

  BaggageOrCargoVolume({
    required this.minimumM3,
    required this.maximumM3,
  });

  factory BaggageOrCargoVolume.fromJson(Map<String, dynamic> json) => BaggageOrCargoVolume(
    minimumM3: json["Minimum_m3"],
    maximumM3: json["Maximum_m3"],
  );

  Map<String, dynamic> toJson() => {
    "Minimum_m3": minimumM3,
    "Maximum_m3": maximumM3,
  };
}
