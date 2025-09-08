import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:newdaddys/firebase_options.dart';
import 'package:newdaddys/services/auth_service.dart';
import 'package:newdaddys/widgets/auth_wrapper.dart';
import 'package:newdaddys/screens/main_menu_screen.dart';
import 'package:newdaddys/screens/login_screen.dart';
import 'package:newdaddys/screens/registration_screen.dart';
import 'package:newdaddys/routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AuthService())],
      child: MaterialApp(
        title: 'Sugar Dating App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
        home: const AuthWrapper(),
        initialRoute: '/',
        routes: {
          AppRoutes.login: (context) => const LoginScreen(),
          AppRoutes.mainMenu: (context) => const MainMenuScreen(),
          AppRoutes.registration: (context) => const RegistrationScreen(),
        },
      ),
    );
  }
}
