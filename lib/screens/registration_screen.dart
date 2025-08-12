import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:newdaddys/theme/app_colors.dart';
import 'package:newdaddys/theme/app_fonts.dart';
import 'package:newdaddys/theme/app_sizes.dart';
import 'package:newdaddys/widgets/custom_text_field.dart';
import 'package:newdaddys/widgets/custom_button.dart';
import 'package:newdaddys/widgets/social_button.dart';

import 'package:newdaddys/routes/app_routes.dart';
import 'package:newdaddys/services/auth_service.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  /// Maneja el registro de usuario con email y contraseña
  Future<void> _handleRegistration() async {
    if (!_formKey.currentState!.validate()) return;

    if (_passwordController.text != _confirmPasswordController.text) {
      _showErrorDialog('Las contraseñas no coinciden');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final result = await authService.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (result.isSuccess) {
        // Navegar a pantalla de verificación
        Navigator.pushNamed(context, AppRoutes.verification);
      } else {
        _showErrorDialog(result.message);
      }
    } catch (e) {
      _showErrorDialog('Error inesperado: ${e.toString()}');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  /// Maneja el registro con Google
  Future<void> _handleGoogleRegistration() async {
    setState(() => _isLoading = true);

    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final result = await authService.signInWithGoogle();

      if (result.isSuccess) {
        // El AuthWrapper se encargará de mostrar la pantalla correcta
        Navigator.pushReplacementNamed(context, '/');
      } else {
        _showErrorDialog(result.message);
      }
    } catch (e) {
      _showErrorDialog('Error inesperado: ${e.toString()}');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  /// Prueba de registro con email específico
  Future<void> _testRegistration() async {
    setState(() => _isLoading = true);

    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final result = await authService.createUserWithEmailAndPassword(
        email: 'ederhdztorres25@outlook.com',
        password: 'TestPassword123!',
      );

      if (result.isSuccess) {
        _showSuccessDialog(
          'Registro exitoso. Revisa tu email: ederhdztorres25@outlook.com',
        );
      } else {
        _showErrorDialog(result.message);
      }
    } catch (e) {
      _showErrorDialog('Error inesperado: ${e.toString()}');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Error'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Éxito'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
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

                // Título de registro
                Text(
                  'Regístrate',
                  style: AppFonts.h1.copyWith(color: AppColors.secondary),
                ),
                const Spacer(flex: 1),

                // Campo de Email
                SizedBox(
                  height: screenHeight * AppSizes.inputHeight,
                  child: CustomTextField(
                    hintText: 'Email',
                    prefixIcon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                    validator: (value) {
                      if (value?.isEmpty ?? true) return 'Email requerido';
                      if (!RegExp(
                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                      ).hasMatch(value!)) {
                        return 'Email inválido';
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
                    hintText: 'Contraseña',
                    prefixIcon: Icons.lock,
                    isPassword: true,
                    controller: _passwordController,
                    validator: (value) {
                      if (value?.isEmpty ?? true) return 'Contraseña requerida';
                      if (value!.length < 6) return 'Mínimo 6 caracteres';
                      return null;
                    },
                  ),
                ),
                const Spacer(flex: 1),

                // Campo de Confirmar Contraseña
                SizedBox(
                  height: screenHeight * AppSizes.inputHeight,
                  child: CustomTextField(
                    hintText: 'Confirma tu contraseña',
                    prefixIcon: Icons.lock,
                    isPassword: true,
                    controller: _confirmPasswordController,
                    validator: (value) {
                      if (value?.isEmpty ?? true)
                        return 'Confirma tu contraseña';
                      return null;
                    },
                  ),
                ),
                const Spacer(flex: 2),

                // Botón principal de registro
                CustomButton(
                  text: _isLoading ? 'Registrando...' : 'Regístrate',
                  onPressed: _isLoading ? null : _handleRegistration,
                  height: screenHeight * AppSizes.buttonHeight,
                ),
                const Spacer(flex: 1),

                const Spacer(flex: 1),

                const Spacer(flex: 1),

                // Separador de métodos de registro
                Center(
                  child: Text(
                    'O regístrate con',
                    style: TextStyle(
                      fontSize: AppFonts.bodyMedium.fontSize,
                      fontWeight: AppFonts.bodyMedium.fontWeight,
                      color: AppColors.placeholderText,
                    ),
                  ),
                ),
                const Spacer(flex: 1),

                // Botón de registro con Google
                SocialButton(
                  text: 'Continuar con Google',
                  icon: Icon(
                    Icons.account_circle,
                    color: AppColors.placeholderText,
                  ),
                  onPressed: _isLoading ? null : _handleGoogleRegistration,
                  height: screenHeight * AppSizes.buttonHeight,
                ),

                const Spacer(flex: 1),

                // Botón de prueba de registro
                CustomButton(
                  text: _isLoading ? 'Procesando...' : 'Prueba de Registro',
                  onPressed: _isLoading ? null : _testRegistration,
                  height: screenHeight * AppSizes.buttonHeight,
                ),

                const Spacer(flex: 1),

                // Link de inicio de sesión
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context); // Volver a la pantalla de login
                    },
                    child: Text(
                      '¿Ya tienes cuenta? Inicia sesión',
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
