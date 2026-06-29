import '../../../Database/db_helper.dart';
import '../../home/manufacturer/manufacturer_list_model.dart';

class HomeResponse {
  final String detail;
  final bool isActiveSubscription;
  final List<ManufacturerListModel> manufacturers;
  final List<Flight> flights;
  final List<Favourite> favourites;
  final CurrentPlan? currentPlan;
  final UserDetails? userDetails;

  HomeResponse({
    required this.detail,
    required this.isActiveSubscription,
    required this.manufacturers,
    required this.flights,
    required this.favourites,
    this.currentPlan,
    this.userDetails,
  });

  factory HomeResponse.fromJson(Map<String, dynamic> json) => HomeResponse(
    detail: json['detail'] ?? '',
    isActiveSubscription: json['is_active_subscription'] ?? false,
    manufacturers: (json['manufacturer'] as List<dynamic>? ?? [])
        .map((e) => ManufacturerListModel.fromJson(e))
        .toList(),
    flights: (json['flight'] as List<dynamic>? ?? [])
        .map((e) => Flight.fromJson(e))
        .toList(),
    favourites: (json['favourite'] as List<dynamic>? ?? [])
        .map((e) => Favourite.fromJson(e))
        .toList(),
    currentPlan: json['current_plan'] != null
        ? CurrentPlan.fromJson(json['current_plan'])
        : null,
    userDetails: json['user'] != null
        ? UserDetails.fromJson(json['user'])
        : null,
  );
}

class Flight extends BaseModel {
  @override
  final String id;
  @override
  String? userId;

  final String model;
  final String code;
  final String? image;
  final String companyName;
  final String? logo;
  final String flightId;

  Flight({
    required this.id,
    required this.model,
    required this.code,
    this.image,
    required this.companyName,
    this.logo,
    required this.flightId,
    this.userId,
  });

  factory Flight.fromJson(Map<String, dynamic> json) => Flight(
    id: json['id'] ?? '',
    model: json['model'] ?? '',
    code: json['code'] ?? '',
    image: json['image'],
    companyName: json['company_name'] ?? '',
    logo: json['logo'],
    flightId: json['flight_id'] ?? '',
    userId: json['user_id'],
  );

  factory Flight.fromMap(Map<String, dynamic> m) => Flight(
    id: m['id'],
    model: m['model'],
    code: m['code'],
    image: m['image'],
    companyName: m['company_name'],
    logo: m['logo'],
    flightId: m['flight_id'],
    userId: m['user_id'],
  );

  @override
  Map<String, dynamic> toMap() => {
    'id': id,
    'model': model,
    'code': code,
    'image': image,
    'company_name': companyName,
    'logo': logo,
    'flight_id': flightId,
    'user_id': userId,
  };

  Map<String, dynamic> toJson() => {
    'id': id,
    'model': model,
    'code': code,
    'image': image,
    'company_name': companyName,
    'logo': logo,
    'flight_id': flightId,
  };

  @override
  String get table => 'flights';
}

class Favourite extends BaseModel {
  final String id;
  final String aircraftModel;
  final String iCAOCode;
  final String image;
  final String callSign;
  final String flightId;
  final String flightNumber;

  Favourite({
    required this.id,
    required this.aircraftModel,
    required this.iCAOCode,
    required this.image,
    required this.callSign,
    required this.flightId,
    required this.flightNumber,
  });

  factory Favourite.fromJson(Map<String, dynamic> json) => Favourite(
    id: json['id'] ?? '',
    aircraftModel: json['Aircraft_Model'] ?? '',
    iCAOCode: json['ICAO_Type_Code'],
    image: json['Image'],
    callSign: json['callsign'] ?? '',
    flightId: json['flight_id'] ?? '',
    flightNumber: json['flight_number'] ?? '',
  );

  factory Favourite.fromMap(Map<String, dynamic> m) => Favourite(
    id: m['id'] ?? '',
    aircraftModel: m['Aircraft_Model'] ?? '',
    iCAOCode: m['ICAO_Type_Code'],
    image: m['Image'],
    callSign: m['callsign'] ?? '',
    flightId: m['flight_id'] ?? '',
    flightNumber: m['flight_number'] ?? '',
  );

  @override
  Map<String, dynamic> toMap() => {
    'id': id,
    'Aircraft_Model': aircraftModel,
    'ICAO_Type_Code': iCAOCode,
    'Image': image,
  };

  Map<String, dynamic> toJson() => {
    'id': id,
    'Aircraft_Model': aircraftModel,
    'ICAO_Type_Code': iCAOCode,
    'Image': image,
  };

  @override
  String get table => 'favourites';
}

class CurrentPlan {
  final String id;
  final String name;
  final double price;
  final String billingCycle;
  final String startDate;
  final String expiryDate;
  final double totalToken;
  final double totalCredit;
  final double tokenUsage;
  final double creditUsage;
  final double creditLimit;
  final double alreadyTotalAddOnToken;
  final double alreadyTotalAddOnCredit;

  CurrentPlan({
    required this.id,
    required this.name,
    required this.price,
    required this.billingCycle,
    required this.startDate,
    required this.expiryDate,
    required this.totalToken,
    required this.totalCredit,
    required this.tokenUsage,
    required this.creditUsage,
    required this.creditLimit,

    required this.alreadyTotalAddOnToken,
    required this.alreadyTotalAddOnCredit,
  });

  factory CurrentPlan.fromJson(Map<String, dynamic> json) {
    return CurrentPlan(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      billingCycle: json['billing_cycle'] ?? '',
      startDate: (json['start_date']),
      expiryDate: (json['expiry_date']),
      totalToken: (json['total_token'] ?? 0).toDouble(),
      totalCredit: (json['total_credit'] ?? 0).toDouble(),
      tokenUsage: (json['token_usage'] ?? 0).toDouble(),
      creditUsage: (json['credit_usage'] ?? 0).toDouble(),
      creditLimit: json['credit_usage'] ?? '',

      alreadyTotalAddOnToken: (json['total_add_on_token'] ?? 0).toDouble(),
      alreadyTotalAddOnCredit: (json['total_add_on_credit'] ?? 0).toDouble(),
    );
  }
}

class UserDetails {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String userTypeUrl;

  UserDetails({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.userTypeUrl,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      userTypeUrl: json['user_type_url'] ?? '',
    );
  }
}
