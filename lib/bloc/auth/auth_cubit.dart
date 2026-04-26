import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_state.dart';
import '../../data/repositories/auth_repository.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit(this._authRepository) : super(const AuthInitial());

  Future<void> checkAuthStatus() async {
    emit(const AuthLoading());
    try {
      final user = await _authRepository.getCurrentUserModel();
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(const AuthUnauthenticated());
      }
    } catch (_) {
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> login(String email, String password) async {
    emit(const AuthLoading());
    try {
      final user = await _authRepository.login(email, password);
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(_normalizeErrorMessage(e)));
    }
  }

  Future<void> signup({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    emit(const AuthLoading());
    try {
      final user = await _authRepository.signup(
        name: name,
        email: email,
        phone: phone,
        password: password,
      );
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(_normalizeErrorMessage(e)));
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _authRepository.sendPasswordResetEmail(email);
    } catch (e) {
      throw Exception(_normalizeErrorMessage(e));
    }
  }

  Future<void> logout() async {
    await _authRepository.logout();
    emit(const AuthUnauthenticated());
  }

  Future<void> updateProfile({
    required String name,
    required String phone,
  }) async {
    if (state is! AuthAuthenticated) {
      throw Exception('You need to log in before editing your profile.');
    }

    try {
      final updatedUser = await _authRepository.updateProfile(
        name: name,
        phone: phone,
      );
      emit(AuthAuthenticated(updatedUser));
    } catch (e) {
      throw Exception(_normalizeErrorMessage(e));
    }
  }

  Future<void> deleteAccount(String password) async {
    if (state is! AuthAuthenticated) {
      throw Exception('You need to log in before deleting your account.');
    }

    try {
      await _authRepository.deleteAccount(password: password);
      emit(const AuthUnauthenticated());
    } catch (e) {
      throw Exception(_normalizeErrorMessage(e));
    }
  }

  String _normalizeErrorMessage(Object error) {
    final message = error.toString();
    const prefix = 'Exception: ';
    if (message.startsWith(prefix)) {
      return message.substring(prefix.length);
    }
    return message;
  }
}
