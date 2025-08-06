class AircraftModel {
  final String name;
  final String id;
  final String manufacturer;

  AircraftModel({
    required this.name,
    required this.id,
    required this.manufacturer,
  });
}

// class AircraftModel {
//   final String id;
//   final String aircraftModel;
//   final bool isFavorite;
//   final String icaoTypeCode;
//   final String image;
//
//   AircraftModel({
//     required this.id,
//     required this.aircraftModel,
//     required this.isFavorite,
//     required this.icaoTypeCode,
//     required this.image,
//   });
//
//   factory AircraftModel.fromJson(Map<String, dynamic> json) {
//     return AircraftModel(
//       id: json['id'],
//       aircraftModel: json['Aircraft_Model'],
//       isFavorite: json['IsFavorite'],
//       icaoTypeCode: json['ICAO_Type_Code'],
//       image: json['Image'],
//     );
//   }
// }
