import 'package:firebaseloginbloc/blocs/authentication_bloc.dart';
import 'package:firebaseloginbloc/blocs/register_bloc.dart';
import 'package:firebaseloginbloc/events/authentication_event.dart';
import 'package:firebaseloginbloc/events/register_event.dart';
import 'package:firebaseloginbloc/pages/buttons/register_button.dart';
import 'package:firebaseloginbloc/repositories/user_repository.dart';
import 'package:firebaseloginbloc/states/register_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterPage extends StatefulWidget {
  final UserRepository _userRepository;

  RegisterPage({Key? key, required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  State<StatefulWidget> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late RegisterBloc _registerBloc;

  UserRepository get _userRepository => widget._userRepository;

  @override
  void initState() {
    super.initState();
    _registerBloc = BlocProvider.of<RegisterBloc>(context);
    _emailController.addListener(() {
      _registerBloc
          .add(RegisterEventEmailChanged(email: _emailController.text));
    });
    _passwordController.addListener(() {
      _registerBloc.add(
          RegisterEventPasswordChanged(password: _passwordController.text));
    });
  }

  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  bool isRegisterButtonEnabled(RegisterState registerState) =>
      registerState.isValidEmailAndPassword &&
      isPopulated &&
      !registerState.isSubmitting;

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: BlocBuilder<RegisterBloc, RegisterState>(
      builder: (context, registerState) {
        if (registerState.isFailure) {
          print('failure');
        } else if (registerState.isSubmitting) {
          print('submitting');
        } else if (registerState.isSuccess) {
          BlocProvider.of<AuthenticationBloc>(context)
              .add(AuthenticationEventLoggedIn());
        }
        return Padding(
          padding: EdgeInsets.all(20.0),
          child: Form(
            child: ListView(
              children: [
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                      icon: Icon(Icons.email), labelText: 'Enter your email'),
                  keyboardType: TextInputType.emailAddress,
                  autovalidate: true,
                  autocorrect: false,
                  validator: (_) {
                    return registerState.isValidEmail
                        ? null
                        : 'Invalid email format';
                  },
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                      icon: Icon(Icons.lock), labelText: 'Enter your password'),
                  obscureText: true,
                  autovalidate: true,
                  autocorrect: false,
                  validator: (_) {
                    return registerState.isValidPassword
                        ? null
                        : 'Invalid password format';
                  },
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                ),
                RegisterButton(onPressed: () {
                  if (isRegisterButtonEnabled(registerState)) {
                    _registerBloc.add(RegisterEventPressed(
                        email: _emailController.text,
                        password: _passwordController.text));
                  }
                }),
              ],
            ),
          ),
        );
      },
    ));
  }
}
