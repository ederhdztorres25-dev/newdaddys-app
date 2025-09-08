import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:newdaddys/services/auth_service.dart';
import 'package:newdaddys/screens/main_menu_screen.dart';
import 'package:newdaddys/screens/login_screen.dart';

/// Wrapper de autenticación que maneja la navegación automática
/// basada en el estado de autenticación del usuario
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(
      builder: (context, authService, child) {
        return _buildScreen(authService);
      },
    );
  }

  /// Construye la pantalla correspondiente según el estado de autenticación
  Widget _buildScreen(AuthService authService) {
    // Si el usuario está autenticado, mostrar el menú principal
    if (authService.isAuthenticated) {
      return const MainMenuScreen();
    }

    // Si no está autenticado, mostrar la pantalla de login
    return const LoginScreen();
  }
}
