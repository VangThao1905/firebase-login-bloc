import 'package:firebaseloginbloc/blocs/authentication_bloc.dart';
import 'package:firebaseloginbloc/events/authentication_event.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('This is HomePage'),
        actions: [
          IconButton(
              onPressed: () {
                BlocProvider.of<AuthenticationBloc>(context)
                    .add(AuthenticationEventLoggedOut());
              },
              icon: Icon(Icons.exit_to_app))
        ],
      ),
      body: Center(
        child: Text(
          'Home page',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
