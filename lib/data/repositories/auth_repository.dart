import '../mock/mock_store.dart';
import '../models/user_model.dart';

class AuthRepository {
  AuthRepository({MockStore? store}) : _store = store ?? MockStore.instance;

  final MockStore _store;

  Future<UserModel> login(String email, String password) async {
    await _store.delay();
    return _store.login(email: email, password: password);
  }

  Future<UserModel> signup({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    await _store.delay();
    return _store.signup(
      name: name,
      email: email,
      phone: phone,
      password: password,
    );
  }

  Future<UserModel?> getCurrentUserModel() async {
    await _store.delay(180);
    return _store.currentUser;
  }

  Future<UserModel> updateProfile({
    required String name,
    required String phone,
  }) async {
    await _store.delay();
    return _store.updateProfile(name: name, phone: phone);
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _store.delay();
    _store.sendPasswordResetEmail(email);
  }

  Future<void> deleteAccount({required String password}) async {
    await _store.delay();
    _store.deleteCurrentAccount(password: password);
  }

  Future<void> logout() async {
    await _store.delay(120);
    _store.logout();
  }
}
