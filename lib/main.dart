import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/firebase_options.dart';
import 'package:mynotes/services/google_auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/google_auth/data/providers/firebase_auth_provider.dart';
import 'package:mynotes/services/google_auth/data/providers/google_sign_in_provider.dart';
import 'package:mynotes/services/google_auth/data/repositories/auth_repository.dart';
import 'package:mynotes/services/phone_auth/bloc/phone_auth_bloc.dart';
import 'package:mynotes/services/phone_auth/data/provider/phone_auth_firebase_provider.dart';
import 'package:mynotes/services/phone_auth/data/repositories/phone_auth_repository.dart';
import 'package:mynotes/views/login_view.dart';
import 'package:mynotes/views/notes/create_update_note_view.dart';
import 'package:mynotes/views/notes/notes_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(
            authenticationRepository: AuthenticationRepository(
              authenticationFirebaseProvider: AuthenticationFirebaseProvider(
                firebaseAuth: FirebaseAuth.instance,
              ),
              googleSignInProvider: GoogleSignInProvider(
                googleSignIn: GoogleSignIn(),
              ),
            ),
          ),
        ),
        BlocProvider<PhoneAuthBloc>(
          create: (context) => PhoneAuthBloc(
            phoneAuthRepository: PhoneAuthRepository(
              phoneAuthFirebaseProvider: PhoneAuthFirebaseProvider(
                firebaseAuth: FirebaseAuth.instance,
              ),
            ),
          ),
        ),
      ],
      child: MaterialApp(
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomePage(),
        routes: {
          createOrUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
        },
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthFailiure) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const LoginView(),
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is AuthInitial) {
          BlocProvider.of<AuthBloc>(context).add(AuthStarted());
          return const CircularProgressIndicator();
          //return const NotesView();
        } else if (state is AuthLoading) {
          return const CircularProgressIndicator();
        } else if (state is AuthSuccess) {
          return const NotesView();
        } else {
          return const Scaffold(
            body: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
