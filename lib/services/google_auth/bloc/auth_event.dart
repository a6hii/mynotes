part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

class AuthStarted extends AuthEvent {}

class AuthStateChanged extends AuthEvent {
  final AuthenticationDetail authenticationDetail;
  const AuthStateChanged({
    required this.authenticationDetail,
  });
  @override
  List<Object> get props => [authenticationDetail];
}

class AuthGoogleStarted extends AuthEvent {}

class AuthExited extends AuthEvent {}

// class AuthEventInitialize extends AuthEvent {
//   const AuthEventInitialize();
// }

// class AuthEventSendEmailVerification extends AuthEvent {
//   const AuthEventSendEmailVerification();
// }

// class AuthEventLogIn extends AuthEvent {
//   final String email;
//   final String password;
//   const AuthEventLogIn(this.email, this.password);
// }

// class AuthEventRegister extends AuthEvent {
//   final String email;
//   final String password;
//   const AuthEventRegister(this.email, this.password);
// }

// class AuthEventShouldRegister extends AuthEvent {
//   const AuthEventShouldRegister();
// }

// class AuthEventForgotPassword extends AuthEvent {
//   final String? email;
//   const AuthEventForgotPassword({this.email});
// }

// class AuthEventLogOut extends AuthEvent {
//   const AuthEventLogOut();
// }
