class VehicleModel {
  final String id;
  final String userId;
  final String make;
  final String model;
  final int year;
  final String licensePlate;

  VehicleModel({
    required this.id,
    required this.userId,
    required this.make,
    required this.model,
    required this.year,
    required this.licensePlate,
  });

  VehicleModel copyWith({
    String? id,
    String? userId,
    String? make,
    String? model,
    int? year,
    String? licensePlate,
  }) {
    return VehicleModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      make: make ?? this.make,
      model: model ?? this.model,
      year: year ?? this.year,
      licensePlate: licensePlate ?? this.licensePlate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'make': make,
      'model': model,
      'year': year,
      'license_plate': licensePlate,
    };
  }

  factory VehicleModel.fromMap(Map<String, dynamic> map) {
    return VehicleModel(
      id: map['id'] ?? '',
      userId: map['user_id'] ?? '',
      make: map['make'] ?? '',
      model: map['model'] ?? '',
      year: map['year']?.toInt() ?? 0,
      licensePlate: map['license_plate'] ?? '',
    );
  }
}
