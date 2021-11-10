import 'package:firebaseloginbloc/blocs/login_bloc.dart';
import 'package:firebaseloginbloc/repositories/user_repository.dart';
import 'package:firebaseloginbloc/states/login_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  final UserRepository _userRepository;

  LoginPage({required Key key, required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  LoginBloc _loginBloc;

  UserRepository get _userRepository => widget._userRepository;

  @override
  void initState() {
    super.initState();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _emailController.addListener(() {});
    _passwordController.addListener(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocBuilder<LoginBloc, LoginState>(
      builder: (context, loginState) {
        if(loginState.isFailure){

        }
      },
    ));
  }
}
