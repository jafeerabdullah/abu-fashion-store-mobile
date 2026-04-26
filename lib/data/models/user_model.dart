class UserModel {
  final String uid;
  final String name;
  final String email;
  final String? phone;

  const UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.phone,
  });

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    } else if (parts.isNotEmpty && parts[0].isNotEmpty) {
      return parts[0][0].toUpperCase();
    }
    return 'U';
  }

  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? phone,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
    );
  }

  Map<String, dynamic> toMap() => {
    'uid': uid,
    'name': name,
    'email': email,
    'phone': phone,
  };

  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
    uid: map['uid'] as String,
    name: map['name'] as String,
    email: map['email'] as String,
    phone: map['phone'] as String?,
  );
}
