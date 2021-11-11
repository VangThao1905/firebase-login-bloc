import 'package:firebaseloginbloc/events/login_event.dart';
import 'package:firebaseloginbloc/repositories/user_repository.dart';
import 'package:firebaseloginbloc/states/login_state.dart';
import 'package:firebaseloginbloc/validators/validators.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  UserRepository _userRepository;

  LoginBloc({required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(LoginState.initial());

  @override
  Stream<Transition<LoginEvent, LoginState>> transformEvents(
      Stream<LoginEvent> loginEvents,
      TransitionFunction<LoginEvent, LoginState> transitionFn) {
    final debounceStream = loginEvents.where((loginEvent) {
      return (loginEvent is LoginEventEmailChanged ||
          loginEvent is LoginEventPasswordChanged);
    }).debounceTime(Duration(milliseconds: 300)); //300 ms each event

    final nonDebounceStream = loginEvents.where((loginEvent) {
      return (loginEvent is! LoginEventEmailChanged &&
          loginEvent is! LoginEventPasswordChanged);
    });
    return super.transformEvents(
        nonDebounceStream.mergeWith([debounceStream]), transitionFn);
  }

  @override
  Stream<LoginState> mapEventToState(LoginEvent loginEvent) async* {
    final loginState = state;
    if (loginEvent is LoginEventEmailChanged) {
      yield loginState.cloneAndUpdate(
          isValidEmail: Validators.isValidEmail(loginEvent.email),
          isValidPassword: true);
    } else if (loginEvent is LoginEventPasswordChanged) {
      yield loginState.cloneAndUpdate(
          isValidEmail: true, isValidPassword: true);
    } else if (loginEvent is LoginEventWithGooglePressed  ) {
      try {
        await _userRepository.signInWithGoogle();
        yield LoginState.success();
      } catch (_) {
        yield LoginState.failure();
      }
    }
    else if (loginEvent is LoginEventWithEmailAndPasswordPressed) {
      try {
        await _userRepository.signInWithEmailAndPassword(
            loginEvent.email, loginEvent.password);
        yield LoginState.success();
      } catch (_) {
        yield LoginState.failure();
      }
    }
  }
}
