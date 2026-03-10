import 'package:autonexa/models/enums.dart';

class UserModel {
  final String id; // maps to uid/id
  final String? email;
  final String name;
  final String? phone;
  final ProviderCategory role;
  final bool isAvailableForP2p;
  final double? lastKnownLat;
  final double? lastKnownLng;
  final DateTime? createdAt;
  final String profilePic;

  UserModel({
    required this.id,
    this.email,
    required this.name,
    this.phone,
    this.role = ProviderCategory.regular_user,
    this.isAvailableForP2p = false,
    this.lastKnownLat,
    this.lastKnownLng,
    this.createdAt,
    this.profilePic = '',
  });

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? phone,
    ProviderCategory? role,
    bool? isAvailableForP2p,
    double? lastKnownLat,
    double? lastKnownLng,
    DateTime? createdAt,
    String? profilePic,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      isAvailableForP2p: isAvailableForP2p ?? this.isAvailableForP2p,
      lastKnownLat: lastKnownLat ?? this.lastKnownLat,
      lastKnownLng: lastKnownLng ?? this.lastKnownLng,
      createdAt: createdAt ?? this.createdAt,
      profilePic: profilePic ?? this.profilePic,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      if (email != null) 'email': email,
      'name': name,
      if (phone != null) 'phone': phone,
      'role': role.value,
      'is_available_for_p2p': isAvailableForP2p,
      if (lastKnownLat != null) 'last_known_lat': lastKnownLat,
      if (lastKnownLng != null) 'last_known_lng': lastKnownLng,
      if (createdAt != null) 'created_at': createdAt?.toIso8601String(),
      'profile_pic': profilePic,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? map['uid'] ?? '',
      email: map['email'],
      name: map['name'] ?? '',
      phone: map['phone'],
      role: map['role'] != null
          ? parseProviderCategory(map['role'])
          : ProviderCategory.regular_user,
      isAvailableForP2p: map['is_available_for_p2p'] ?? false,
      lastKnownLat: map['last_known_lat']?.toDouble(),
      lastKnownLng: map['last_known_lng']?.toDouble(),
      createdAt: map['created_at'] != null
          ? DateTime.tryParse(map['created_at'])
          : null,
      profilePic: map['profile_pic'] ?? map['profilePic'] ?? '',
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, role: $role)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.id == id &&
        other.email == email &&
        other.name == name &&
        other.phone == phone &&
        other.role == role &&
        other.isAvailableForP2p == isAvailableForP2p;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ email.hashCode ^ role.hashCode;
  }
}
