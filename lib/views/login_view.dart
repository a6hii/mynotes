import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/extensions/buildcontext/loc.dart';
import 'package:mynotes/main.dart';
import 'package:mynotes/services/google_auth/bloc/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/services/phone_auth/bloc/phone_auth_bloc.dart';
import 'package:mynotes/services/phone_auth/data/provider/phone_auth_firebase_provider.dart';
import 'package:mynotes/services/phone_auth/data/repositories/phone_auth_repository.dart';
import 'package:mynotes/views/phone_login_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.loc.login),
      ),
      body: Builder(
        builder: (context) {
          return BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthSuccess) {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const HomePage()));
              } else if (state is AuthFailiure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                  ),
                );
              }
            },
            buildWhen: (current, next) {
              if (next is AuthSuccess) {
                return false;
              }
              return true;
            },
            builder: (context, state) {
              if (state is AuthInitial || state is AuthFailiure) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      OutlinedButton(
                        onPressed: () => BlocProvider.of<AuthBloc>(context).add(
                          AuthGoogleStarted(),
                        ),
                        child: const Text('Login with Google'),
                      ),
                      OutlinedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BlocProvider(
                                      create: (context) => PhoneAuthBloc(
                                        phoneAuthRepository:
                                            PhoneAuthRepository(
                                          phoneAuthFirebaseProvider:
                                              PhoneAuthFirebaseProvider(
                                                  firebaseAuth:
                                                      FirebaseAuth.instance),
                                        ),
                                      ),
                                      child: const LoginPhoneNumberView(),
                                    )),
                          );
                        },
                        child: const Text('Login with Phone Number'),
                      ),
                    ],
                  ),
                );
              } else if (state is AuthLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              return Center(
                  child: Text('Undefined state : ${state.runtimeType}'));
            },
          );
        },
      ),
    );
  }
}
