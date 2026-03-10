class UserModel {
  final String uid;
  final String email;
  final String name;
  final String profilePic;
  final String banner;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.profilePic,
    required this.banner,
  });

  UserModel copyWith({
    String? uid,
    String? email,
    String? name,
    String? profilePic,
    String? banner,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      name: name ?? this.name,
      profilePic: profilePic ?? this.profilePic,
      banner: banner ?? this.banner,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'profilePic': profilePic,
      'banner': banner,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      profilePic: map['profilePic'] ?? '',
      banner: map['banner'] ?? '',
    );
  }

  @override
  String toString() {
    return 'UserModel(uid: $uid, email: $email, name: $name, profilePic: $profilePic, banner: $banner)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.uid == uid &&
        other.email == email &&
        other.name == name &&
        other.profilePic == profilePic &&
        other.banner == banner;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        email.hashCode ^
        name.hashCode ^
        profilePic.hashCode ^
        banner.hashCode;
  }
}
