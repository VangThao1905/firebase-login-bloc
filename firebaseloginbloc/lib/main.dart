import 'package:firebase_core/firebase_core.dart';
import 'package:firebaseloginbloc/blocs/authentication_bloc.dart';
import 'package:firebaseloginbloc/blocs/login_bloc.dart';
import 'package:firebaseloginbloc/blocs/simple_bloc_observer.dart';
import 'package:firebaseloginbloc/events/authentication_event.dart';
import 'package:firebaseloginbloc/pages/home_page.dart';
import 'package:firebaseloginbloc/pages/login_page.dart';
import 'package:firebaseloginbloc/pages/splash_page.dart';
import 'package:firebaseloginbloc/repositories/user_repository.dart';
import 'package:firebaseloginbloc/states/authentication_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = SimpleBlocObserver();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final UserRepository _userRepository = UserRepository();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Login with firebase",
        home: BlocProvider(
          create: (context) {
            final authenticationBloc =
                AuthenticationBloc(userRepository: _userRepository);
            authenticationBloc.add(AuthenticationEventStarted());
            return authenticationBloc;
          },
          child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, authenticationState) {
              if (authenticationState is AuthenticationStateSuccess) {
                return HomePage();
              } else if (authenticationState is AuthenticationStateFailure) {
                return BlocProvider(
                  create: (context) =>
                      LoginBloc(userRepository: _userRepository),
                  child: LoginPage(
                    userRepository: _userRepository,
                  ),
                );
              }
              // return BlocProvider(
              //   create: (context) => LoginBloc(userRepository: _userRepository),
              //   child: LoginPage(
              //     userRepository: _userRepository,
              //   ),
              // );
               return SplashPage();
            },
          ),
        ));
  }
}
