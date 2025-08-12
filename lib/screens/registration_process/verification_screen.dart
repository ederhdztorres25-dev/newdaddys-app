import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:newdaddys/theme/app_colors.dart';
import 'package:newdaddys/theme/app_fonts.dart';
import 'package:newdaddys/theme/app_sizes.dart';
import 'package:newdaddys/widgets/custom_app_bar.dart';
import 'package:newdaddys/widgets/custom_button.dart';

import 'package:newdaddys/routes/app_routes.dart';
import 'package:newdaddys/services/auth_service.dart';

/// Pantalla de verificación de email
/// Aquí el usuario ingresa el código de verificación y confirma su email
class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  bool _isLoading = false;
  bool _isVerified = false;
  String _verificationCode = '';

  /// Verifica si el email ya fue verificado
  Future<void> _handleEmailVerification() async {
    setState(() => _isLoading = true);

    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final result = await authService.checkEmailVerification();

      if (result.isSuccess) {
        setState(() => _isVerified = true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result.message)),
        );
        // Continuar al siguiente paso del registro
        Navigator.pushNamed(context, AppRoutes.profilePreference);
      } else {
        _showErrorDialog(
            'Email aún no verificado. Revisa tu correo y haz clic en el enlace de verificación.');
      }
    } catch (e) {
      _showErrorDialog('Error inesperado: ${e.toString()}');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  /// Reenvía el email de verificación
  Future<void> _resendVerificationEmail() async {
    setState(() => _isLoading = true);

    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final result = await authService.resendEmailVerification();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result.message)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al reenviar: ${e.toString()}'),
          backgroundColor: AppColors.danger,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Verificación Pendiente'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _resendVerificationEmail();
            },
            child: const Text('Reenviar'),
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
      appBar: const CustomAppBar(
        title: 'Crea tu perfil',
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * AppSizes.horizontalPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 0.05),
              Text('Verifica tu email',
                  style:
                      AppFonts.bodyMedium.copyWith(color: AppColors.secondary)),
              SizedBox(height: screenHeight * 0.02),
              Text(
                'Revisa tu correo y haz clic en el enlace de verificación que te enviamos. Luego presiona "Verificar" para continuar.',
                style: AppFonts.bodyMedium
                    .copyWith(color: AppColors.placeholderText),
              ),
              SizedBox(height: screenHeight * 0.05),
              // Mensaje de estado
              if (_isVerified)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green),
                      const SizedBox(width: 8),
                      Text(
                        '¡Email verificado exitosamente!',
                        style:
                            AppFonts.bodyMedium.copyWith(color: Colors.green),
                      ),
                    ],
                  ),
                ),
              const Spacer(),
              // Botón de reenviar email
              OutlinedButton(
                onPressed: _isLoading ? null : _resendVerificationEmail,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.secondary),
                  minimumSize: Size(
                      double.infinity, screenHeight * AppSizes.buttonHeight),
                ),
                child: Text(
                  _isLoading ? 'Enviando...' : 'Reenviar email de verificación',
                  style:
                      AppFonts.bodyMedium.copyWith(color: AppColors.secondary),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              CustomButton(
                text: _isLoading ? 'Verificando...' : 'Verificar y Continuar',
                onPressed: _isLoading ? null : _handleEmailVerification,
                height: screenHeight * AppSizes.buttonHeight,
              ),
              SizedBox(height: screenHeight * 0.05),
            ],
          ),
        ),
      ),
    );
  }
}
