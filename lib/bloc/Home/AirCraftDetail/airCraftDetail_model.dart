class AirCraftDetailResponse {
  final String detail;
  final AircraftResult results;

  AirCraftDetailResponse({required this.detail, required this.results});

  factory AirCraftDetailResponse.fromJson(Map<String, dynamic> json) {
    return AirCraftDetailResponse(
      detail: json['detail'] ?? '',
      results: AircraftResult.fromJson(json['results']),
    );
  }
}

class AircraftResult {
  final String id;
  final String createdAt;
  final String updatedAt;
  final List<AircraftImage> images;
  final IdentificationClassification identification;
  final PowerplantPropulsion powerplant;
  final Dimensions dimensions;
  final Weights weights;
  final Performance performance;
  final OperationalLimitations operationalLimitations;
  final LandingGear landingGear;
  final CertificationEnvironmental certification;

  AircraftResult({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.images,
    required this.identification,
    required this.powerplant,
    required this.dimensions,
    required this.weights,
    required this.performance,
    required this.operationalLimitations,
    required this.landingGear,
    required this.certification,
  });

  factory AircraftResult.fromJson(Map<String, dynamic> json) {
    return AircraftResult(
      id: json['id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      images: (json['Images'] as List)
          .map((i) => AircraftImage.fromJson(i))
          .toList(),
      identification: IdentificationClassification.fromJson(
        json['IdentificationClassification'],
      ),
      powerplant: PowerplantPropulsion.fromJson(json['PowerplantPropulsion']),
      dimensions: Dimensions.fromJson(json['Dimensions']),
      weights: Weights.fromJson(json['Weights']),
      performance: Performance.fromJson(json['Performance']),
      operationalLimitations: OperationalLimitations.fromJson(
        json['OperationalLimitations'],
      ),
      landingGear: LandingGear.fromJson(json['LandingGear']),
      certification: CertificationEnvironmental.fromJson(
        json['CertificationEnvironmental'],
      ),
    );
  }
}

class AircraftImage {
  final String url;
  final String source;
  final String cc;
  final bool isDefault;

  AircraftImage({
    required this.url,
    required this.source,
    required this.cc,
    required this.isDefault,
  });

  factory AircraftImage.fromJson(Map<String, dynamic> json) {
    return AircraftImage(
      url: json['url'] ?? '',
      source: json['source'] ?? '',
      cc: json['cc'] ?? '',
      isDefault: json['is_default'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {'url': url, 'source': source, 'cc': cc, 'is_default': isDefault};
  }

  /// Create list from JSON and auto-sort by isDefault
  static List<AircraftImage> fromJsonList(List<dynamic> jsonList) {
    List<AircraftImage> images = jsonList
        .map((item) => AircraftImage.fromJson(item))
        .toList();

    images.sort((a, b) {
      if (a.isDefault == b.isDefault) return 0;
      return a.isDefault ? -1 : 1;
    });

    return images;
  }
}

class IdentificationClassification {
  final String icaoTypeCode;
  final String manufacturer;
  final String aircraftModel;
  final String aircraftRole;
  final String aircraftType;
  final String wakeTurbulenceCategory;
  final String civilianMilitaryOrDualUse;
  final String countryOfOrigin;
  final String dateOfMaidenFlight;
  final String yearOfIntroduction;
  final String productionStatus;
  final String avionicsSystem;
  final String numberOfCrew;
  final PassengerCapacity numberOfPassengers;

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

  factory IdentificationClassification.fromJson(Map<String, dynamic> json) {
    return IdentificationClassification(
      icaoTypeCode: json['ICAO_Type_Code'],
      manufacturer: json['Manufacturer'],
      aircraftModel: json['Aircraft_Model'],
      aircraftRole: json['Aircraft_Role'],
      aircraftType: json['Aircraft_Type'],
      wakeTurbulenceCategory: json['Wake_Turbulence_Category'],
      civilianMilitaryOrDualUse: json['Civilian_Military_or_Dual_Use'],
      countryOfOrigin: json['Country_of_Origin'],
      dateOfMaidenFlight: json['Date_of_Maiden_Flight'],
      yearOfIntroduction: json['Year_of_Introduction'],
      productionStatus: json['Production_Status'],
      avionicsSystem: json['Avionics_System'],
      numberOfCrew: json['Number_of_Crew'],
      numberOfPassengers: PassengerCapacity.fromJson(
        json['Number_of_Passengers'],
      ),
    );
  }
}

class PassengerCapacity {
  final String typical;
  final String maximum;

  PassengerCapacity({required this.typical, required this.maximum});

  factory PassengerCapacity.fromJson(Map<String, dynamic> json) {
    return PassengerCapacity(
      typical: json['Typical'],
      maximum: json['Maximum'],
    );
  }
}

class PowerplantPropulsion {
  final int numberOfEngines;
  final Engine engine;
  final String apuType;
  final Fuel fuel;

  PowerplantPropulsion({
    required this.numberOfEngines,
    required this.engine,
    required this.apuType,
    required this.fuel,
  });

  factory PowerplantPropulsion.fromJson(Map<String, dynamic> json) {
    return PowerplantPropulsion(
      numberOfEngines: json['Number_of_Engines'],
      engine: Engine.fromJson(json['Engine']),
      apuType: json['APU_Type'],
      fuel: Fuel.fromJson(json['Fuel']),
    );
  }
}

class Engine {
  final String manufacturer;
  final String model;
  final String engineType;
  final String thrust;
  final String physicalEngineCode;

  Engine({
    required this.manufacturer,
    required this.model,
    required this.engineType,
    required this.thrust,
    required this.physicalEngineCode,
  });

  factory Engine.fromJson(Map<String, dynamic> json) {
    return Engine(
      manufacturer: json['Manufacturer'],
      model: json['Model'],
      engineType: json['Engine_Type'],
      thrust: json['Thrust_Per_Engine_kN_or_kW'],
      physicalEngineCode: json['Physical_Engine_Code'],
    );
  }
}

class Fuel {
  final String fuelType;
  final String fuelAdditives;
  final String capacity;
  final String burnRate;

  Fuel({
    required this.fuelType,
    required this.fuelAdditives,
    required this.capacity,
    required this.burnRate,
  });

  factory Fuel.fromJson(Map<String, dynamic> json) {
    return Fuel(
      fuelType: json['Fuel_Type'],
      fuelAdditives: json['Fuel_Additives'],
      capacity: json['Capacity_L_or_kg'],
      burnRate: json['Fuel_Burn_Cruise_kg_per_hr'],
    );
  }
}

class Dimensions {
  final String wingspanM;
  final String wingspanFt;
  final String lengthM;
  final String lengthFt;
  final String heightM;
  final String heightFt;
  final String wingAreaM2;
  final String cabinWidthM;
  final String doorHeightM;
  final String wingtipConfiguration;

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

  factory Dimensions.fromJson(Map<String, dynamic> json) {
    return Dimensions(
      wingspanM: json['Wingspan_m'],
      wingspanFt: json['Wingspan_ft'],
      lengthM: json['Length_m'],
      lengthFt: json['Length_ft'],
      heightM: json['Height_m'],
      heightFt: json['Height_ft'],
      wingAreaM2: json['Wing_Area_m2'],
      cabinWidthM: json['Cabin_Width_m'],
      doorHeightM: json['Door_Height_m'],
      wingtipConfiguration: json['Wingtip_Configuration'],
    );
  }
}

class Weights {
  final String emptyWeight;
  final String zeroFuelWeight;
  final String takeoffWeight;
  final String payload;
  final String landingWeight;
  final CargoVolume baggage;

  Weights({
    required this.emptyWeight,
    required this.zeroFuelWeight,
    required this.takeoffWeight,
    required this.payload,
    required this.landingWeight,
    required this.baggage,
  });

  factory Weights.fromJson(Map<String, dynamic> json) {
    return Weights(
      emptyWeight: json['Operating_Empty_Weight_kg'],
      zeroFuelWeight: json['Maximum_Zero_Fuel_Weight_kg'],
      takeoffWeight: json['Maximum_Takeoff_Weight_kg'],
      payload: json['Maximum_Payload_kg'],
      landingWeight: json['Maximum_Landing_Weight_kg'],
      baggage: CargoVolume.fromJson(json['Baggage_or_Cargo_Volume']),
    );
  }
}

class CargoVolume {
  final String minimum;
  final String maximum;

  CargoVolume({required this.minimum, required this.maximum});

  factory CargoVolume.fromJson(Map<String, dynamic> json) {
    return CargoVolume(
      minimum: json['Minimum_m3'],
      maximum: json['Maximum_m3'],
    );
  }
}

class Performance {
  final String takeoffSpeedKts;
  final String takeoffDistanceM;
  final String climbInitialFpm;
  final String climbAvgFpm;
  final String climbMaxFpm;
  final String serviceCeiling;
  final String maxCertifiedAltitude;
  final String cruiseSpeedKt;
  final String cruiseMach;
  final String maxCruiseSpeed;
  final String vmoKts;
  final String mmoMach;
  final Range range;
  final String descentInitialFpm;
  final String descentAvgFpm;
  final String minCleanSpeed;
  final String approachSpeed;
  final String approachCategory;
  final String landingSpeed;
  final String landingDistance;
  final String runwayRequired;
  final String stallSpeed;

  Performance({
    required this.takeoffSpeedKts,
    required this.takeoffDistanceM,
    required this.climbInitialFpm,
    required this.climbAvgFpm,
    required this.climbMaxFpm,
    required this.serviceCeiling,
    required this.maxCertifiedAltitude,
    required this.cruiseSpeedKt,
    required this.cruiseMach,
    required this.maxCruiseSpeed,
    required this.vmoKts,
    required this.mmoMach,
    required this.range,
    required this.descentInitialFpm,
    required this.descentAvgFpm,
    required this.minCleanSpeed,
    required this.approachSpeed,
    required this.approachCategory,
    required this.landingSpeed,
    required this.landingDistance,
    required this.runwayRequired,
    required this.stallSpeed,
  });

  factory Performance.fromJson(Map<String, dynamic> json) {
    return Performance(
      takeoffSpeedKts: json['Takeoff_Speed_kts'],
      takeoffDistanceM: json['Takeoff_Distance_m'],
      climbInitialFpm: json['Initial_Climb_Rate_fpm'],
      climbAvgFpm: json['Average_Rate_of_Climb_fpm'],
      climbMaxFpm: json['Maximum_Rate_of_Climb_fpm'],
      serviceCeiling: json['Service_Ceiling_ft'],
      maxCertifiedAltitude: json['Max_Certified_Altitude_ft'],
      cruiseSpeedKt: json['Cruise_Speed_kt'],
      cruiseMach: json['Cruise_Mach'],
      maxCruiseSpeed: json['Maximum_Cruise_Speed_kts_or_Mach'],
      vmoKts: json['VMO_kts'],
      mmoMach: json['MMO_Mach'],
      range: Range.fromJson(json['Range']),
      descentInitialFpm: json['Initial_Rate_of_Descent_fpm'],
      descentAvgFpm: json['Average_Rate_of_Descent_fpm'],
      minCleanSpeed: json['Minimum_Clean_Speed_kts'],
      approachSpeed: json['Approach_Speed_kts'],
      approachCategory: json['Approach_Category'],
      landingSpeed: json['Landing_Speed_kts'],
      landingDistance: json['Landing_Distance_m'],
      runwayRequired: json['Runway_Length_Required_m'],
      stallSpeed: json['Stall_Speed_kts'],
    );
  }
}

class Range {
  final String normalRangeNm;
  final String normalRangeKm;
  final String ferryRangeNm;

  Range({
    required this.normalRangeNm,
    required this.normalRangeKm,
    required this.ferryRangeNm,
  });

  factory Range.fromJson(Map<String, dynamic> json) {
    return Range(
      normalRangeNm: json['Normal_Range_NM'],
      normalRangeKm: json['Normal_Range_km'],
      ferryRangeNm: json['Ferry_Range_NM'],
    );
  }
}

class OperationalLimitations {
  final String runwaySlopeLimit;
  final String maxCrosswindNormal;
  final String maxCrosswindDegraded;
  final String maxTailwindLanding;
  final String maxTailwindTakeoff;
  final String fieldElevationLimit;
  final String maxRunwayAltitude;
  final AutolandCapability autoland;

  OperationalLimitations({
    required this.runwaySlopeLimit,
    required this.maxCrosswindNormal,
    required this.maxCrosswindDegraded,
    required this.maxTailwindLanding,
    required this.maxTailwindTakeoff,
    required this.fieldElevationLimit,
    required this.maxRunwayAltitude,
    required this.autoland,
  });

  factory OperationalLimitations.fromJson(Map<String, dynamic> json) {
    return OperationalLimitations(
      runwaySlopeLimit: json['Runway_Slope_Limit_percent'],
      maxCrosswindNormal: json['Max_Crosswind_Normal_Law_kts'],
      maxCrosswindDegraded: json['Max_Crosswind_Degraded_Law_kts'],
      maxTailwindLanding: json['Max_Tailwind_Landing_kts'],
      maxTailwindTakeoff: json['Max_Tailwind_Takeoff_kts'],
      fieldElevationLimit: json['Field_Elevation_Limit_ft'],
      maxRunwayAltitude: json['Max_Runway_Altitude_ft'],
      autoland: AutolandCapability.fromJson(json['Autoland_Capability']),
    );
  }
}

class AutolandCapability {
  final String supportedCategories;
  final String certifiedLevel;

  AutolandCapability({
    required this.supportedCategories,
    required this.certifiedLevel,
  });

  factory AutolandCapability.fromJson(Map<String, dynamic> json) {
    return AutolandCapability(
      supportedCategories: json['Supported_Categories'],
      certifiedLevel: json['Certified_Autoland_Level'],
    );
  }
}

class LandingGear {
  final String type;
  final String numberOfWheels;
  final String tyreSize;
  final String tyrePressure;

  LandingGear({
    required this.type,
    required this.numberOfWheels,
    required this.tyreSize,
    required this.tyrePressure,
  });

  factory LandingGear.fromJson(Map<String, dynamic> json) {
    return LandingGear(
      type: json['Type'],
      numberOfWheels: json['Number_of_Wheels'],
      tyreSize: json['Tyre_Size_inches'],
      tyrePressure: json['Tyre_Pressure_bar_psi'],
    );
  }
}

class CertificationEnvironmental {
  final String certificationBasis;
  final String easa;
  final String faa;
  final String specialConditions;
  final String noiseCompliance;
  final String emissionsCategory;

  CertificationEnvironmental({
    required this.certificationBasis,
    required this.easa,
    required this.faa,
    required this.specialConditions,
    required this.noiseCompliance,
    required this.emissionsCategory,
  });

  factory CertificationEnvironmental.fromJson(Map<String, dynamic> json) {
    return CertificationEnvironmental(
      certificationBasis: json['Certification_Basis'],
      easa: json['EASA_TCDS_Number'],
      faa: json['FAA_TCDS_Number'],
      specialConditions: json['Special_Conditions'],
      noiseCompliance: json['Noise_Compliance'],
      emissionsCategory: json['Emissions_Category'],
    );
  }
}
