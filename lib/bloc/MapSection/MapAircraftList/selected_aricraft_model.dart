import '../../../Database/db_helper.dart';

class SelectedAircraftModel extends BaseModel {
  @override
  String? userId;

  @override
  final String id;
  final String? aircraftModel;
  final String? manufacturerName;

  SelectedAircraftModel({
    required this.id,
    this.aircraftModel,
    this.manufacturerName,
    this.userId,
  });

  @override
  String get table => 'selected_aircraft';

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'aircraftModel': aircraftModel,
      'manufacturerName': manufacturerName,
      'user_id': userId,
    };
  }

  factory SelectedAircraftModel.fromMap(Map<String, dynamic> map) {
    return SelectedAircraftModel(
      id: map['id'] as String,
      aircraftModel: map['aircraftModel'] as String?,
      manufacturerName: map['manufacturerName'] as String?,
      userId: map['user_id'] as String?,
    );
  }
}
