import 'dart:developer';

import 'package:chat/interfaces/iauth.interface.dart';
import 'package:chat/models/UserAccount.dart';
import 'package:stacked/stacked.dart';
import 'package:chat/app/app.locator.dart';
import 'package:chat/app/app.router.dart';
import 'package:stacked_services/stacked_services.dart';

class StartupViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _authService = locator<IAuthService>();

  setUp() {
    _startListenAuthStatus();
  }

  _startListenAuthStatus() {
    _authService.user.listen(_userAccountListener);
    log("Auth listener initated.");
  }

  _userAccountListener(UserAccount? account) {
    if (account != null) {
      _navigationService.pushNamedAndRemoveUntil(Routes.chatListView);
    } else {
      _navigationService.pushNamedAndRemoveUntil(Routes.loginView);
    }
  }
}
