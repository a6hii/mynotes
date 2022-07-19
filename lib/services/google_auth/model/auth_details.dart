// import 'package:mynotes/services/auth/auth_user.dart';

// abstract class AuthProvider {
//   Future<void> initialize();
//   AuthUser? get currentUser;
//   Future<AuthUser> logIn({
//     required String email,
//     required String password,
//   });
//   Future<AuthUser> createUser({
//     required String email,
//     required String password,
//   });
//   Future<void> logOut();
//   Future<void> sendEmailVerification();
//   Future<void> sendPasswordReset({required String toEmail});
// }

import 'dart:convert';

class AuthenticationDetail {
  final bool? isValid;
  final String? uid;
  final String? photoUrl;
  final String? email;
  final String? name;

  AuthenticationDetail({
    required this.isValid,
    this.uid,
    this.photoUrl,
    this.email,
    this.name,
  });

  AuthenticationDetail copyWith({
    bool? isValid,
    String? uid,
    String? photoUrl,
    String? email,
    String? name,
  }) {
    return AuthenticationDetail(
      isValid: isValid ?? this.isValid,
      uid: uid ?? this.uid,
      photoUrl: photoUrl ?? this.photoUrl,
      email: email ?? this.email,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'isValid': isValid,
      'uid': uid,
      'photoUrl': photoUrl,
      'email': email,
      'name': name,
    };
  }

  factory AuthenticationDetail.fromMap(Map<String, dynamic>? map) {
    return AuthenticationDetail(
      isValid: map?['isValid'],
      uid: map?['uid'],
      photoUrl: map?['photoUrl'],
      email: map?['email'],
      name: map?['name'],
    );
  }

  String toJson() => json.encode(toMap());

  factory AuthenticationDetail.fromJson(String source) =>
      AuthenticationDetail.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AuthenticationDetail(isValid: $isValid, uid: $uid, photoUrl: $photoUrl, email: $email, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AuthenticationDetail &&
        other.isValid == isValid &&
        other.uid == uid &&
        other.photoUrl == photoUrl &&
        other.email == email &&
        other.name == name;
  }

  @override
  int get hashCode {
    return isValid.hashCode ^
        uid.hashCode ^
        photoUrl.hashCode ^
        email.hashCode ^
        name.hashCode;
  }
}
