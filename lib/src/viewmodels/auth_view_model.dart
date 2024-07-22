//create authviewmodel provider class

import 'package:injectable/injectable.dart';
import 'package:merem_chat_app/core/helpers/shared_preference.dart';
import 'package:merem_chat_app/core/helpers/snackbar_helper.dart';
import 'package:merem_chat_app/core/state/app_state.dart';
import 'package:merem_chat_app/src/services/auth_service.dart';

@singleton
class AuthViewModel extends AppState {
  final SharedPreferencesService _prefService;
  final AuthService _authService;
  final ToastService _toastService;

  AuthViewModel(this._authService, this._prefService, this._toastService);

  Future<bool> registerWithEmailPassword({
    required String email,
    required String password,
    required String username,
  }) async {
    setBusy(true);
    final result = _authService.registerWithEmailPassword(
      email: email,
      password: password,
      username: username,
    );
    return await result.match(
      (error) {
        setBusy(false);
        _toastService.showError(error);
        return false;
      },
      (final user) {
        setBusy(false);
        _prefService.saveString(
          'user_id',
          user.uid,
        );
        _toastService.showInfo('Register success');
        return true;
      },
    ).run();
  }

  //login
  Future<bool> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    setBusy(true);
    final result = _authService.loginWithEmailPassword(
      email,
      password,
    );
    return await result.match(
      (error) {
        setBusy(false);
        _toastService.showError(error);
        return false;
      },
      (final user) {
        setBusy(false);
        _prefService.saveString(
          'user_id',
          user.uid,
        );
        return true;
      },
    ).run();
  }

  Future<bool> isLoggedIn() async {
    final userId = _prefService.getString('user_id');
    return userId != null && userId.isNotEmpty;
  }
}
