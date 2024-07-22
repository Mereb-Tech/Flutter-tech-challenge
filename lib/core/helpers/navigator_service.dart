// import 'package:flutter/material.dart';
// import 'package:injectable/injectable.dart';

// @singleton
// class NavigationService {
//   GlobalKey<NavigatorState>? navigationKey;

//   static NavigationService instance = NavigationService();

//   NavigationService() {
//     navigationKey = GlobalKey<NavigatorState>();
//   }

//   navigate(Widget rn) {
//     if (navigationKey?.currentState != null) {
//       return navigationKey?.currentState!.push(
//         MaterialPageRoute(builder: (context) => rn),
//       );
//     }
//   }

//   navigateAndRemove(Widget rn) {
//     if (navigationKey?.currentState != null) {
//       return navigationKey?.currentState!.pushAndRemoveUntil(
//         MaterialPageRoute(builder: (context) => rn),
//         (route) => false,
//       );
//     }
//   }

//   goBack() {
//     return navigationKey?.currentState!.pop();
//   }

//   // Let's create loader also in this service
//   showLoader() {
//     Future.delayed(Duration.zero, () {
//       if (navigationKey?.currentContext != null) {
//         showDialog(
//             context: navigationKey!.currentContext!,
//             barrierDismissible: false,
//             builder: (BuildContext context) {
//               return const Center(
//                   child: CircularProgressIndicator(
//                 color: Colors.white,
//               ));
//             });
//       }
//     });
//   }
// }
