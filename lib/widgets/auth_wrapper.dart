import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:newdaddys/services/auth_service.dart';
import 'package:newdaddys/screens/main_menu_screen.dart';
import 'package:newdaddys/screens/login_screen.dart';

/// Wrapper de autenticación que verifica el estado de autenticación
/// y redirige al usuario a la pantalla correspondiente
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(
      builder: (context, authService, child) {
        // Mostrar loading mientras se verifica el estado de autenticación
        if (authService.currentUser == null && !authService.isAuthenticated) {
          // Usuario no autenticado - mostrar pantalla de login
          return const LoginScreen();
        } else {
          // Usuario autenticado - mostrar menú principal
          return const MainMenuScreen();
        }
      },
    );
  }
}
