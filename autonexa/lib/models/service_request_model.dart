import 'package:autonexa/models/enums.dart';

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
    };
  }

  factory ServiceRequestModel.fromMap(Map<String, dynamic> map) {
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
    );
  }
}
