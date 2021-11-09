import 'package:firebaseloginbloc/events/login_event.dart';
import 'package:firebaseloginbloc/events/register_event.dart';
import 'package:firebaseloginbloc/repositories/user_repository.dart';
import 'package:firebaseloginbloc/states/login_state.dart';
import 'package:firebaseloginbloc/states/register_state.dart';
import 'package:firebaseloginbloc/validators/validators.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

class RegisterBloc extends Bloc<LoginEvent, LoginState> {
  UserRepository _userRepository;

  RegisterBloc({required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(LoginState.initial());

  @override
  Stream<Transition<RegisterEvent, RegisterState>> transformEvents(
      Stream<RegisterEvent> registerEvents,
      TransitionFunction<RegisterEvent, RegisterState> transitionFn) {
    final debounceStream = registerEvents.where((registerEvent) {
      return (registerEvent is RegisterEventEmailChanged ||
          registerEvent is RegisterEventPasswordChanged);
    }).debounceTime(Duration(milliseconds: 300)); //300 ms each event

    final nonDebounceStream = registerEvents.where((registerEvent) {
      return (registerEvent is! RegisterEventEmailChanged &&
          registerEvent is! RegisterEventPasswordChanged);
    });
    return super.transformEvents(nonDebounceStream.mergeWith([debounceStream]), transitionFn);
  }

  @override
  Stream<LoginState> mapEventToState(LoginEvent loginEvent) async* {
    final loginState = state;
    if (loginEvent is LoginEventEmailChanged) {
      yield loginState.cloneAndUpdate(
          isValidEmail: Validators.isValidEmail(loginEvent.email),
          isValidPassword: loginEvent.email);
    } else if (loginEvent is LoginEventPasswordChanged) {
      yield loginState.cloneAndUpdate(
          isValidEmail: null, isValidPassword: isValidPassword)
    } else if (loginEvent is LoginEventWithGoogleChanged) {
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
