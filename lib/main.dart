import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:merem_chat_app/core/helpers/shared_preference.dart';
import 'package:merem_chat_app/core/state/app_state.dart';
import 'package:merem_chat_app/di.dart';
import 'package:merem_chat_app/firebase_options.dart';
import 'package:merem_chat_app/routes/app_router.dart';
import 'package:merem_chat_app/src/viewmodels/auth_view_model.dart';
import 'package:merem_chat_app/theme/theme.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await configureDependencies();
  await getIt<SharedPreferencesService>().init();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final appRouter = AppRouter();
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => getIt<AppState>(),
        ),
        ChangeNotifierProvider(
          create: (context) => getIt<AuthViewModel>(),
        ),
      ],
      child: MaterialApp.router(
        routerConfig: appRouter.config(),
        title: 'Flutter Chat App Demo',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
      ),
    );
  }
}
