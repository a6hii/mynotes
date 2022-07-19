part of 'auth_bloc.dart';

// @immutable
// abstract class AuthState {
//   final bool isLoading;
//   final String? loadingText;
//   const AuthState({
//     required this.isLoading,
//     this.loadingText = 'Please wait a moment',
//   });
// }

// class AuthStateUninitialized extends AuthState {
//   const AuthStateUninitialized({required bool isLoading})
//       : super(isLoading: isLoading);
// }

// class AuthStateRegistering extends AuthState {
//   final Exception? exception;
//   const AuthStateRegistering({
//     required this.exception,
//     required isLoading,
//   }) : super(isLoading: isLoading);
// }

// class AuthStateForgotPassword extends AuthState {
//   final Exception? exception;
//   final bool hasSentEmail;
//   const AuthStateForgotPassword({
//     required this.exception,
//     required this.hasSentEmail,
//     required bool isLoading,
//   }) : super(isLoading: isLoading);
// }

// class AuthStateLoggedIn extends AuthState {
//   final AuthUser user;
//   const AuthStateLoggedIn({
//     required this.user,
//     required bool isLoading,
//   }) : super(isLoading: isLoading);
// }

// class AuthStateNeedsVerification extends AuthState {
//   const AuthStateNeedsVerification({required bool isLoading})
//       : super(isLoading: isLoading);
// }

// class AuthStateLoggedOut extends AuthState with EquatableMixin {
//   final Exception? exception;
//   const AuthStateLoggedOut({
//     required this.exception,
//     required bool isLoading,
//     String? loadingText,
//   }) : super(
//           isLoading: isLoading,
//           loadingText: loadingText,
//         );

//   @override
//   List<Object?> get props => [exception, isLoading];
// }

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthFailiure extends AuthState {
  final String message;
  const AuthFailiure({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}

class AuthSuccess extends AuthState {
  final AuthenticationDetail authenticationDetail;
  const AuthSuccess({
    required this.authenticationDetail,
  });
  @override
  List<Object> get props => [authenticationDetail];
}
