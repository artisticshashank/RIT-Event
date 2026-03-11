import 'package:autonexa/models/enums.dart';

/// Thin snapshot of the responder (provider) embedded in service_requests JOIN
class ResponderInfo {
  final String id;
  final String name;
  final String? avatarUrl;
  final double? rating;

  const ResponderInfo({
    required this.id,
    required this.name,
    this.avatarUrl,
    this.rating,
  });

  factory ResponderInfo.fromMap(Map<String, dynamic> map) {
    return ResponderInfo(
      id: map['id'] ?? '',
      name: map['name'] ?? 'Provider',
      avatarUrl: map['avatar_url'],
      rating: (map['rating'] as num?)?.toDouble(),
    );
  }
}

class ServiceRequestModel {
  final String id;
  final String requesterId;
  final String? responderId;
  final ServiceType requestType;
  final String? description;
  final double locationLat;
  final double locationLng;
  final ServiceStatus status;
  final DateTime? createdAt;
  // Extended fields
  final String? locationAddress;
  final String? vehicleInfo;
  final String? fuelQuantity;
  final String? fuelType;
  final String? issueType;
  final double? price;
  final double? distanceKm;
  // JOIN data
  final ResponderInfo? responder;

  ServiceRequestModel({
    required this.id,
    required this.requesterId,
    this.responderId,
    required this.requestType,
    this.description,
    required this.locationLat,
    required this.locationLng,
    this.status = ServiceStatus.searching,
    this.createdAt,
    this.locationAddress,
    this.vehicleInfo,
    this.fuelQuantity,
    this.fuelType,
    this.issueType,
    this.price,
    this.distanceKm,
    this.responder,
  });

  ServiceRequestModel copyWith({
    String? id,
    String? requesterId,
    String? responderId,
    ServiceType? requestType,
    String? description,
    double? locationLat,
    double? locationLng,
    ServiceStatus? status,
    DateTime? createdAt,
    String? locationAddress,
    String? vehicleInfo,
    String? fuelQuantity,
    String? fuelType,
    String? issueType,
    double? price,
    double? distanceKm,
    ResponderInfo? responder,
  }) {
    return ServiceRequestModel(
      id: id ?? this.id,
      requesterId: requesterId ?? this.requesterId,
      responderId: responderId ?? this.responderId,
      requestType: requestType ?? this.requestType,
      description: description ?? this.description,
      locationLat: locationLat ?? this.locationLat,
      locationLng: locationLng ?? this.locationLng,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      locationAddress: locationAddress ?? this.locationAddress,
      vehicleInfo: vehicleInfo ?? this.vehicleInfo,
      fuelQuantity: fuelQuantity ?? this.fuelQuantity,
      fuelType: fuelType ?? this.fuelType,
      issueType: issueType ?? this.issueType,
      price: price ?? this.price,
      distanceKm: distanceKm ?? this.distanceKm,
      responder: responder ?? this.responder,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'requester_id': requesterId,
      if (responderId != null) 'responder_id': responderId,
      'request_type': requestType.value,
      if (description != null) 'description': description,
      'location_lat': locationLat,
      'location_lng': locationLng,
      'status': status.value,
      if (createdAt != null) 'created_at': createdAt?.toIso8601String(),
      if (locationAddress != null) 'location_address': locationAddress,
      if (vehicleInfo != null) 'vehicle_info': vehicleInfo,
      if (fuelQuantity != null) 'fuel_quantity': fuelQuantity,
      if (fuelType != null) 'fuel_type': fuelType,
      if (issueType != null) 'issue_type': issueType,
      if (price != null) 'price': price,
      if (distanceKm != null) 'distance_km': distanceKm,
    };
  }

  factory ServiceRequestModel.fromMap(Map<String, dynamic> map) {
    // Supabase JOIN returns responder as a nested map or null
    final responderMap = map['responder'];
    ResponderInfo? responderInfo;
    if (responderMap is Map<String, dynamic>) {
      responderInfo = ResponderInfo.fromMap(responderMap);
    }

    return ServiceRequestModel(
      id: map['id'] ?? '',
      requesterId: map['requester_id'] ?? '',
      responderId: map['responder_id'],
      requestType: map['request_type'] != null
          ? parseServiceType(map['request_type'])
          : ServiceType.mechanical_repair,
      description: map['description'],
      locationLat: map['location_lat']?.toDouble() ?? 0.0,
      locationLng: map['location_lng']?.toDouble() ?? 0.0,
      status: map['status'] != null
          ? parseServiceStatus(map['status'])
          : ServiceStatus.searching,
      createdAt: map['created_at'] != null
          ? DateTime.tryParse(map['created_at'])
          : null,
      locationAddress: map['location_address'],
      vehicleInfo: map['vehicle_info'],
      fuelQuantity: map['fuel_quantity'],
      fuelType: map['fuel_type'],
      issueType: map['issue_type'],
      price: map['price']?.toDouble(),
      distanceKm: map['distance_km']?.toDouble(),
      responder: responderInfo,
    );
  }
}
