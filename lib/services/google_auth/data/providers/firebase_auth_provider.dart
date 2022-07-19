import 'package:firebase_auth/firebase_auth.dart'
    show AuthCredential, FirebaseAuth, User, UserCredential;

// class FirebaseAuthProvider implements AuthProvider {
//   @override
//   Future<void> initialize() async {
//     await Firebase.initializeApp(
//       options: DefaultFirebaseOptions.currentPlatform,
//     );
//   }

//   @override
//   Future<AuthUser> createUser({
//     required String email,
//     required String password,
//   }) async {
//     try {
//       await FirebaseAuth.instance.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       final user = currentUser;
//       if (user != null) {
//         return user;
//       } else {
//         throw UserNotLoggedInAuthException();
//       }
//     } on FirebaseAuthException catch (e) {
//       if (e.code == 'weak-password') {
//         throw WeakPasswordAuthException();
//       } else if (e.code == 'email-already-in-use') {
//         throw EmailAlreadyInUseAuthException();
//       } else if (e.code == 'invalid-email') {
//         throw InvalidEmailAuthException();
//       } else {
//         throw GenericAuthException();
//       }
//     } catch (_) {
//       throw GenericAuthException();
//     }
//   }

//   @override
//   AuthUser? get currentUser {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       return AuthUser.fromFirebase(user);
//     } else {
//       return null;
//     }
//   }

//   @override
//   Future<AuthUser> logIn({
//     required String email,
//     required String password,
//   }) async {
//     try {
//       await FirebaseAuth.instance.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       final user = currentUser;
//       if (user != null) {
//         return user;
//       } else {
//         throw UserNotLoggedInAuthException();
//       }
//     } on FirebaseAuthException catch (e) {
//       if (e.code == 'user-not-found') {
//         throw UserNotFoundAuthException();
//       } else if (e.code == 'wrong-password') {
//         throw WrongPasswordAuthException();
//       } else {
//         throw GenericAuthException();
//       }
//     } catch (_) {
//       throw GenericAuthException();
//     }
//   }

//   @override
//   Future<void> logOut() async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       await FirebaseAuth.instance.signOut();
//     } else {
//       throw UserNotLoggedInAuthException();
//     }
//   }

//   @override
//   Future<void> sendEmailVerification() async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       await user.sendEmailVerification();
//     } else {
//       throw UserNotLoggedInAuthException();
//     }
//   }

//   @override
//   Future<void> sendPasswordReset({required String toEmail}) async {
//     try {
//       await FirebaseAuth.instance.sendPasswordResetEmail(email: toEmail);
//     } on FirebaseAuthException catch (e) {
//       switch (e.code) {
//         case 'firebase_auth/invalid-email':
//           throw InvalidEmailAuthException();
//         case 'firebase_auth/user-not-found':
//           throw UserNotFoundAuthException();
//         default:
//           throw GenericAuthException();
//       }
//     } catch (_) {
//       throw GenericAuthException();
//     }
//   }
// }

class AuthenticationFirebaseProvider {
  final FirebaseAuth _firebaseAuth;
  AuthenticationFirebaseProvider({
    required FirebaseAuth firebaseAuth,
  }) : _firebaseAuth = firebaseAuth;

  Stream<User?> getAuthStates() {
    return _firebaseAuth.authStateChanges();
  }

  Future<User?> login({
    required AuthCredential credential,
  }) async {
    UserCredential userCredential =
        await _firebaseAuth.signInWithCredential(credential);
    return userCredential.user;
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }
}
