import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:merem_chat_app/src/view/auth/auth.dart';
import 'package:merem_chat_app/src/view/chat/chat_page.dart';
import 'package:merem_chat_app/src/view/chat/home_page.dart';
import 'package:merem_chat_app/src/view/profile/profile_page.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: SplashRoute.page, initial: true),
        AutoRoute(page: LoginRoute.page),
        AutoRoute(page: RegisterRoute.page),
        AutoRoute(page: HomeRoute.page),
        AutoRoute(page: ChatDetailRoute.page),
        AutoRoute(page: ProfileRoute.page),
      ];
}
