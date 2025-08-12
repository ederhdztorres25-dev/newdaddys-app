import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:newdaddys/services/auth_service.dart';
import 'package:newdaddys/theme/app_colors.dart';
import 'package:newdaddys/theme/app_fonts.dart';
import 'package:newdaddys/theme/app_sizes.dart';
import 'package:newdaddys/widgets/custom_text_field.dart';
import 'package:newdaddys/widgets/custom_button.dart';
import 'package:newdaddys/widgets/social_button.dart';

import 'package:newdaddys/routes/app_routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Maneja el inicio de sesión con email y contraseña
  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final result = await authService.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (result.isSuccess) {
        if (mounted) {
          // El AuthWrapper detectará automáticamente el cambio de estado
          // y redirigirá al usuario al MainMenuScreen
          // No necesitamos navegar manualmente
        }
      } else {
        if (mounted) {
          _showErrorDialog(result.message);
        }
      }
    } catch (e) {
      if (mounted) {
        _showErrorDialog('Error inesperado: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  /// Maneja el inicio de sesión con Google
  Future<void> _handleGoogleLogin() async {
    setState(() => _isLoading = true);

    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final result = await authService.signInWithGoogle();

      if (result.isSuccess) {
        if (mounted) {
          // El AuthWrapper detectará automáticamente el cambio de estado
          // y redirigirá al usuario al MainMenuScreen
          // No necesitamos navegar manualmente
        }
      } else {
        if (mounted) {
          _showErrorDialog(result.message);
        }
      }
    } catch (e) {
      if (mounted) {
        _showErrorDialog('Error inesperado: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: AppColors.primary,
            title: Text(
              'Error',
              style: AppFonts.h3.copyWith(color: Colors.white),
            ),
            content: Text(
              message,
              style: AppFonts.bodyMedium.copyWith(color: Colors.white),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'OK',
                  style: AppFonts.bodyMedium.copyWith(
                    color: AppColors.secondary,
                  ),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * AppSizes.horizontalPadding,
            vertical: screenHeight * 0.1,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo
                Image.asset(
                  'assets/images/logo.png',
                  height: screenHeight * AppSizes.logoHeight,
                  color: AppColors.secondary,
                ),

                const Spacer(flex: 1),

                // Título de bienvenida
                Text(
                  'Bienvenido',
                  style: AppFonts.h1.copyWith(color: AppColors.secondary),
                ),

                const Spacer(flex: 1),

                // Campo de Email
                SizedBox(
                  height: screenHeight * AppSizes.inputHeight,
                  child: CustomTextField(
                    controller: _emailController,
                    hintText: 'Email',
                    prefixIcon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'El email es requerido';
                      }
                      if (!RegExp(
                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                      ).hasMatch(value!)) {
                        return 'Formato de email inválido';
                      }
                      return null;
                    },
                  ),
                ),

                const Spacer(flex: 1),

                // Campo de Contraseña
                SizedBox(
                  height: screenHeight * AppSizes.inputHeight,
                  child: CustomTextField(
                    controller: _passwordController,
                    hintText: 'Password',
                    prefixIcon: Icons.lock,
                    isPassword: true,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'La contraseña es requerida';
                      }
                      if (value!.length < 6) {
                        return 'La contraseña debe tener al menos 6 caracteres';
                      }
                      return null;
                    },
                  ),
                ),

                const Spacer(flex: 1),

                // Link de recuperación de contraseña
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.recoveryPasswordStep1,
                      );
                    },
                    child: Text(
                      '¿Olvidaste tu contraseña?',
                      style: AppFonts.bodyMedium.copyWith(
                        color: AppColors.secondary,
                      ),
                    ),
                  ),
                ),

                const Spacer(flex: 1),

                // Botón principal de login
                CustomButton(
                  text: _isLoading ? 'Iniciando sesión...' : 'Iniciar sesión',
                  onPressed: _isLoading ? null : _handleLogin,
                  height: screenHeight * AppSizes.buttonHeight,
                ),

                const Spacer(flex: 1),

                const Spacer(flex: 1),

                const Spacer(flex: 1),

                // Separador de métodos de login
                Center(
                  child: Text(
                    'O continua con',
                    style: TextStyle(
                      fontSize: AppFonts.bodyMedium.fontSize,
                      fontWeight: AppFonts.bodyMedium.fontWeight,
                      color: AppColors.placeholderText,
                    ),
                  ),
                ),

                const Spacer(flex: 1),

                // Botón de login con Google
                SocialButton(
                  text: 'Continuar con Google',
                  icon: Icon(
                    Icons.account_circle,
                    color: AppColors.placeholderText,
                  ),
                  onPressed: _isLoading ? null : _handleGoogleLogin,
                  height: screenHeight * AppSizes.buttonHeight,
                ),

                const Spacer(flex: 1),

                // Link de registro
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.registration);
                    },
                    child: Text(
                      '¿No tienes cuenta? Regístrate',
                      style: AppFonts.bodyMedium.copyWith(
                        color: AppColors.secondary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
