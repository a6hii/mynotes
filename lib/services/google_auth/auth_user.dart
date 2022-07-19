// import 'package:equatable/equatable.dart';
// import 'package:firebase_auth/firebase_auth.dart' show User;
// import 'package:flutter/foundation.dart';

// @immutable
// class AuthUser extends Equatable {
//   final String id;
//   final String name;
//   final String email;
//   final String? photoUrl;

//   const AuthUser({
//     required this.id,
//     required this.name,
//     required this.email,
//     this.photoUrl,
//   });

//   factory AuthUser.fromFirebase(User user) => AuthUser(
//         id: user.uid,
//         email: user.email!,
//         name: user.displayName!,
//         photoUrl: user.photoURL,
//       );

//   @override
//   List<Object?> get props => [
//         id,
//         name,
//         email,
//         photoUrl,
//       ];
// }
