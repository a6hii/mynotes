// import 'package:mynotes/services/auth/auth_provider.dart';
// import 'package:mynotes/services/auth/auth_user.dart';
// import 'package:mynotes/services/auth/firebase_auth_provider.dart';

// class AuthService implements AuthProvider {
//   final AuthProvider provider;
//   const AuthService(this.provider);

//   factory AuthService.firebase() => AuthService(FirebaseAuthProvider());

//   @override
//   Future<AuthUser> createUser({
//     required String email,
//     required String password,
//   }) =>
//       provider.createUser(
//         email: email,
//         password: password,
//       );

//   @override
//   AuthUser? get currentUser => provider.currentUser;

//   @override
//   Future<AuthUser> logIn({
//     required String email,
//     required String password,
//   }) =>
//       provider.logIn(
//         email: email,
//         password: password,
//       );

//   @override
//   Future<void> logOut() => provider.logOut();

//   @override
//   Future<void> sendEmailVerification() => provider.sendEmailVerification();

//   @override
//   Future<void> initialize() => provider.initialize();

//   @override
//   Future<void> sendPasswordReset({required String toEmail}) =>
//       provider.sendPasswordReset(toEmail: toEmail);
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:mynotes/services/google_auth/model/auth_details.dart';
import 'package:mynotes/services/google_auth/data/providers/firebase_auth_provider.dart';
import 'package:mynotes/services/google_auth/data/providers/google_sign_in_provider.dart';

class AuthenticationRepository {
  final AuthenticationFirebaseProvider _authenticationFirebaseProvider;
  final GoogleSignInProvider _googleSignInProvider;
  AuthenticationRepository(
      {required AuthenticationFirebaseProvider authenticationFirebaseProvider,
      required GoogleSignInProvider googleSignInProvider})
      : _googleSignInProvider = googleSignInProvider,
        _authenticationFirebaseProvider = authenticationFirebaseProvider;

  Stream<AuthenticationDetail> getAuthDetailStream() {
    return _authenticationFirebaseProvider.getAuthStates().map((user) {
      return _getAuthCredentialFromFirebaseUser(user: user);
    });
  }

  Future<AuthenticationDetail> authenticateWithGoogle() async {
    User? user = await _authenticationFirebaseProvider.login(
        credential: await _googleSignInProvider.login());
    return _getAuthCredentialFromFirebaseUser(user: user);
  }

  Future<void> unAuthenticate() async {
    await _googleSignInProvider.logout();
    await _authenticationFirebaseProvider.logout();
  }

  AuthenticationDetail _getAuthCredentialFromFirebaseUser(
      {required User? user}) {
    AuthenticationDetail authDetail;
    if (user != null) {
      authDetail = AuthenticationDetail(
        isValid: true,
        uid: user.uid,
        email: user.email,
        photoUrl: user.photoURL,
        name: user.displayName,
      );
    } else {
      authDetail = AuthenticationDetail(isValid: false);
    }
    return authDetail;
  }
}
