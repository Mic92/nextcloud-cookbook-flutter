import 'dart:async';

import 'package:bloc/bloc.dart';
import '../../services/user_repository.dart';

import 'authentication.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository userRepository = UserRepository();

  @override
  AuthenticationState get initialState => AuthenticationUninitialized();

  @override
  Stream<AuthenticationState> mapEventToState(AuthenticationEvent event) async* {
    if (event is AppStarted) {
      final bool hasToken = await userRepository.hasAppAuthentication();

      if (hasToken) {
        yield AuthenticationLoading();
        await userRepository.loadAppAuthentication();
        yield AuthenticationAuthenticated();
      } else {
        yield AuthenticationUnauthenticated();
      }
    }

    if (event is LoggedIn) {
      yield AuthenticationLoading();
      await userRepository.persistAppAuthentication(event.appAuthentication);
      yield AuthenticationAuthenticated();
    }

    if (event is LoggedOut) {
      yield AuthenticationLoading();
      await userRepository.deleteAppAuthentication();
      yield AuthenticationUnauthenticated();
    }
  }
}