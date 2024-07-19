import 'package:flutter/material.dart';

customResponse({required BuildContext context, required String message}) {
  return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(behavior: SnackBarBehavior.floating, content: Text(message)));
}
