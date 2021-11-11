import 'package:firebaseloginbloc/events/login_event.dart';
import 'package:firebaseloginbloc/events/register_event.dart';
import 'package:firebaseloginbloc/repositories/user_repository.dart';
import 'package:firebaseloginbloc/states/register_state.dart';
import 'package:firebaseloginbloc/validators/validators.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  UserRepository _userRepository;

  RegisterBloc({required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(RegisterState.initial());

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
    return super.transformEvents(
        nonDebounceStream.mergeWith([debounceStream]), transitionFn);
  }

  @override
  Stream<RegisterState> mapEventToState(RegisterEvent registerEvent) async* {
    final registerState = state;
    if (registerEvent is RegisterEventEmailChanged) {
      yield registerState.cloneAndUpdate(
          isValidEmail: Validators.isValidEmail(registerEvent.email),
          isValidPassword: true);
    } else if (registerEvent is RegisterEventPasswordChanged) {
      yield registerState.cloneAndUpdate(
          isValidEmail: true,
          isValidPassword: Validators.isValidPassword(registerEvent.password));
    } else if (registerEvent is RegisterEventWithGoogleChanged) {
      try {
        await _userRepository.signInWithGoogle();
        yield RegisterState.success();
      } catch (_) {
        yield RegisterState.failure();
      }
    } else if (registerEvent is RegisterEventPressed) {
      try {
        await _userRepository.createUserWithEmailAndPassword(
            registerEvent.email, registerEvent.password);
        yield RegisterState.success();
      } catch (_) {
        yield RegisterState.failure();
      }
    }
  }
}
