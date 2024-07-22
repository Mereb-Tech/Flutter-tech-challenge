import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  bool _isBusy = false;

  bool get isBusy => _isBusy;

  void setBusy(bool value) {
    _isBusy = value;
    notifyListeners();
  }

  showLoader({required BuildContext context}) {
    Future.delayed(Duration.zero, () {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return const Center(
                child: CircularProgressIndicator(
              color: Colors.white,
            ));
          });
    });
  }
}
