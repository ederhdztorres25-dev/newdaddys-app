import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:newdaddys/services/auth_service.dart';
import 'package:newdaddys/firebase_options.dart';
import 'package:newdaddys/widgets/auth_wrapper.dart';
import 'package:newdaddys/screens/main_menu_screen.dart';
import 'package:newdaddys/screens/recovery_password_process/recovery_password_step1_screen.dart';
import 'package:newdaddys/screens/recovery_password_process/recovery_password_step2_screen.dart';
import 'package:newdaddys/screens/registration_screen.dart';
import 'package:newdaddys/screens/login_screen.dart';
import 'package:newdaddys/screens/registration_process/verification_screen.dart';
import 'package:newdaddys/screens/registration_process/profile_preference_screen.dart';
import 'package:newdaddys/screens/registration_process/personal_details_screen.dart';
import 'package:newdaddys/screens/registration_process/photo_upload_screen.dart';
import 'package:newdaddys/screens/registration_process/physical_characteristics_screen.dart';
import 'package:newdaddys/screens/registration_process/phone_number_screen.dart';
import 'package:newdaddys/routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Verificar si Firebase ya está inicializado
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    // Si ya está inicializado, continuar
    print('Firebase ya inicializado: $e');
  }

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
          AppRoutes.recoveryPasswordStep1:
              (context) => const RecoveryPasswordStep1Screen(),
          AppRoutes.recoveryPasswordStep2:
              (context) => const RecoveryPasswordStep2Screen(),
          AppRoutes.mainMenu: (context) => const MainMenuScreen(),
          AppRoutes.registration: (context) => const RegistrationScreen(),
          AppRoutes.verification: (context) => const VerificationScreen(),
          AppRoutes.profilePreference:
              (context) => const ProfilePreferenceScreen(),
          AppRoutes.personalDetails: (context) => const PersonalDetailsScreen(),
          AppRoutes.photoUpload: (context) => const PhotoUploadScreen(),
          AppRoutes.physicalCharacteristics:
              (context) => const PhysicalCharacteristicsScreen(),
          AppRoutes.phoneNumber: (context) => const PhoneNumberScreen(),
        },
      ),
    );
  }
}
