import 'package:firebaseloginbloc/blocs/register_bloc.dart';
import 'package:firebaseloginbloc/pages/register_page.dart';
import 'package:firebaseloginbloc/repositories/user_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterUserButton extends StatelessWidget {
  final UserRepository _userRepository;

  RegisterUserButton({Key? key, required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      height: 45,
      child: FlatButton(
        color: Colors.blue,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return BlocProvider(
              create: (context) =>
                  RegisterBloc(userRepository: _userRepository),
              child: RegisterPage(
                userRepository: _userRepository,
              ),
            );
          }));
        },
        child: Text(
          'Register',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}
