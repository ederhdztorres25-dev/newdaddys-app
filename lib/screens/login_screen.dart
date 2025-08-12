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

/// Pantalla de inicio de sesión
/// Permite login con email/contraseña y Google
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

  // ==================== MÉTODOS DE AUTENTICACIÓN ====================

  /// Maneja el inicio de sesión con email y contraseña
  Future<void> _handleEmailLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final result = await authService.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (!result.isSuccess && mounted) {
        _showErrorDialog(result.message);
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

      if (!result.isSuccess && mounted) {
        _showErrorDialog(result.message);
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

  // ==================== VALIDACIONES ====================

  /// Valida el formato del email
  String? _validateEmail(String? value) {
    if (value?.isEmpty ?? true) {
      return 'El email es requerido';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value!)) {
      return 'Formato de email inválido';
    }
    return null;
  }

  /// Valida la contraseña
  String? _validatePassword(String? value) {
    if (value?.isEmpty ?? true) {
      return 'La contraseña es requerida';
    }
    if (value!.length < 6) {
      return 'La contraseña debe tener al menos 6 caracteres';
    }
    return null;
  }

  // ==================== UI HELPERS ====================

  /// Muestra un diálogo de error
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
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
              style: AppFonts.bodyMedium.copyWith(color: AppColors.secondary),
            ),
          ),
        ],
      ),
    );
  }

  // ==================== WIDGETS ====================

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
                _buildLogo(screenHeight),
                const Spacer(flex: 1),
                _buildWelcomeTitle(),
                const Spacer(flex: 1),
                _buildEmailField(screenHeight),
                const Spacer(flex: 1),
                _buildPasswordField(screenHeight),
                const Spacer(flex: 1),
                _buildForgotPasswordLink(),
                const Spacer(flex: 1),
                _buildLoginButton(screenHeight),
                const Spacer(flex: 2),
                _buildSeparator(),
                const Spacer(flex: 1),
                _buildGoogleButton(screenHeight),
                const Spacer(flex: 1),
                _buildRegisterLink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Construye el logo de la aplicación
  Widget _buildLogo(double screenHeight) {
    return Image.asset(
      'assets/images/logo.png',
      height: screenHeight * AppSizes.logoHeight,
      color: AppColors.secondary,
    );
  }

  /// Construye el título de bienvenida
  Widget _buildWelcomeTitle() {
    return Text(
      'Bienvenido',
      style: AppFonts.h1.copyWith(color: AppColors.secondary),
    );
  }

  /// Construye el campo de email
  Widget _buildEmailField(double screenHeight) {
    return SizedBox(
      height: screenHeight * AppSizes.inputHeight,
      child: CustomTextField(
        controller: _emailController,
        hintText: 'Email',
        prefixIcon: Icons.email,
        keyboardType: TextInputType.emailAddress,
        validator: _validateEmail,
      ),
    );
  }

  /// Construye el campo de contraseña
  Widget _buildPasswordField(double screenHeight) {
    return SizedBox(
      height: screenHeight * AppSizes.inputHeight,
      child: CustomTextField(
        controller: _passwordController,
        hintText: 'Password',
        prefixIcon: Icons.lock,
        isPassword: true,
        validator: _validatePassword,
      ),
    );
  }

  /// Construye el enlace de recuperación de contraseña
  Widget _buildForgotPasswordLink() {
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(context, AppRoutes.recoveryPasswordStep1),
        child: Text(
          '¿Olvidaste tu contraseña?',
          style: AppFonts.bodyMedium.copyWith(color: AppColors.secondary),
        ),
      ),
    );
  }

  /// Construye el botón principal de login
  Widget _buildLoginButton(double screenHeight) {
    return CustomButton(
      text: _isLoading ? 'Iniciando sesión...' : 'Iniciar sesión',
      onPressed: _isLoading ? null : _handleEmailLogin,
      height: screenHeight * AppSizes.buttonHeight,
    );
  }

  /// Construye el separador entre métodos de login
  Widget _buildSeparator() {
    return Center(
      child: Text(
        'O continua con',
        style: TextStyle(
          fontSize: AppFonts.bodyMedium.fontSize,
          fontWeight: AppFonts.bodyMedium.fontWeight,
          color: AppColors.placeholderText,
        ),
      ),
    );
  }

  /// Construye el botón de login con Google
  Widget _buildGoogleButton(double screenHeight) {
    return SocialButton(
      text: 'Continuar con Google',
      icon: Icon(
        Icons.account_circle,
        color: AppColors.placeholderText,
      ),
      onPressed: _isLoading ? null : _handleGoogleLogin,
      height: screenHeight * AppSizes.buttonHeight,
    );
  }

  /// Construye el enlace de registro
  Widget _buildRegisterLink() {
    return Center(
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(context, AppRoutes.registration),
        child: Text(
          '¿No tienes cuenta? Regístrate',
          style: AppFonts.bodyMedium.copyWith(color: AppColors.secondary),
        ),
      ),
    );
  }
}
