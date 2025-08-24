import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:newdaddys/services/auth_service.dart';
import 'package:newdaddys/screens/main_menu_screen.dart';
import 'package:newdaddys/screens/login_screen.dart';
import 'package:newdaddys/screens/registration_process/profile_preference_screen.dart';

/// Wrapper de autenticación que maneja la navegación automática
/// basada en el estado de autenticación y completitud del perfil del usuario
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(
      builder: (context, authService, child) {
        // Si el usuario no está autenticado, mostrar login
        if (!authService.isAuthenticated) {
          return const LoginScreen();
        }

        // Si está autenticado, verificar si el perfil está completo
        return FutureBuilder<bool>(
          future: authService.isProfileComplete(),
          builder: (context, snapshot) {
            // Mientras se verifica el perfil, mostrar loading
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            // Si hay error, mostrar login por seguridad
            if (snapshot.hasError) {
              return const LoginScreen();
            }

            final isProfileComplete = snapshot.data ?? false;

            // Si el perfil no está completo, ir al proceso de registro
            if (!isProfileComplete) {
              return const ProfilePreferenceScreen();
            }

            // Si todo está completo, mostrar el menú principal
            return const MainMenuScreen();
          },
        );
      },
    );
  }
}
