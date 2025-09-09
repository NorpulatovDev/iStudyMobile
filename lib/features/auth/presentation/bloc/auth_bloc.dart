import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:istudy/features/auth/data/models/user_model.dart';
import 'package:istudy/features/auth/data/repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc(this._authRepository) : super(AuthInitial()) {
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthCheckRequested>(_onCheckRequested);
  }

  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final user = await _authRepository.login(event.username, event.password);
      emit(AuthAuthenticated(user));
      print("AuthAuthenticated called!");
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      await _authRepository.logout();
      emit(AuthUnAuthenticated());
    } catch (e) {
      emit(AuthUnAuthenticated()); // Always logout even if API fails
    }
  }

  Future<void> _onCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final user = await _authRepository.getCurrentUser();
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthUnAuthenticated());
      }
    } catch (e) {
      emit(AuthUnAuthenticated());
    }
  }
}
