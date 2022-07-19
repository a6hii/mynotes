import 'dart:async';

import 'package:bloc/bloc.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/services/google_auth/data/repositories/auth_repository.dart';
import 'package:mynotes/services/google_auth/model/auth_details.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthenticationRepository _authenticationRepository;
  StreamSubscription<AuthenticationDetail>? authStreamSub;
  AuthBloc({
    required AuthenticationRepository authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        super(AuthInitial()) {
    on<AuthStarted>((event, emit) {
      try {
        emit(AuthLoading());
        authStreamSub = _authenticationRepository
            .getAuthDetailStream()
            .listen((authDetail) {
          add(AuthStateChanged(authenticationDetail: authDetail));
        });
      } catch (e) {
        print(
          'Error occured while fetching authentication detail : ${e.toString()}',
        );
        emit(
          const AuthFailiure(
            message: 'Error occrued while fetching auth detail',
          ),
        );
      }
    });
    //forgot password
    on<AuthStateChanged>((event, emit) {
      if (event.authenticationDetail.isValid!) {
        emit(AuthSuccess(authenticationDetail: event.authenticationDetail));
      } else {
        emit(const AuthFailiure(message: 'User has logged out'));
      }
    });
    // send email verification
    on<AuthGoogleStarted>((event, emit) async {
      try {
        emit(AuthLoading());
        AuthenticationDetail authenticationDetail =
            await _authenticationRepository.authenticateWithGoogle();

        if (authenticationDetail.isValid!) {
          emit(AuthSuccess(authenticationDetail: authenticationDetail));
        } else {
          emit(const AuthFailiure(message: 'User detail not found.'));
        }
      } catch (error) {
        print('Error occured while login with Google ${error.toString()}');
        emit(const AuthFailiure(
          message: 'Unable to login with Google. Try again.',
        ));
      }
    });
    on<AuthExited>((event, emit) async {
      try {
        emit(AuthLoading());
        await _authenticationRepository.unAuthenticate();
      } catch (error) {
        print('Error occured while logging out. : ${error.toString()}');
        emit(
            const AuthFailiure(message: 'Unable to logout. Please try again.'));
      }
    });
  }
}
