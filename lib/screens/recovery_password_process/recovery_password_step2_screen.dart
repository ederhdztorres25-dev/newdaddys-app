import 'package:flutter/material.dart';
import 'package:newdaddys/theme/app_colors.dart';
import 'package:newdaddys/theme/app_fonts.dart';
import 'package:newdaddys/theme/app_sizes.dart';
import 'package:newdaddys/widgets/back_button.dart';
import 'package:newdaddys/widgets/custom_button.dart';

// Esta es la pantalla donde el usuario ingresa el código de 4 dígitos
// que le enviamos a su correo para verificar su identidad
class RecoveryPasswordStep2Screen extends StatefulWidget {
  const RecoveryPasswordStep2Screen({super.key});

  @override
  State<RecoveryPasswordStep2Screen> createState() =>
      _RecoveryPasswordStep2ScreenState();
}

class _RecoveryPasswordStep2ScreenState
    extends State<RecoveryPasswordStep2Screen> {
  String _verificationCode = '';

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      // La barra superior de la pantalla
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        centerTitle: true,
        leading: const CustomBackButton(),
        title: Text(
          'Recupera tu contraseña',
          style: AppFonts.h2.copyWith(color: AppColors.secondary),
        ),
      ),
      // El contenido principal de la pantalla
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * AppSizes.horizontalPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 0.05),
              Text(
                'Código de verificación',
                style: AppFonts.h1.copyWith(color: AppColors.secondary),
              ),
              SizedBox(height: screenHeight * 0.02),
              Text(
                'Ingresa el código de verificación que enviamos a tu correo ederhdz@outlook.com',
                style: AppFonts.bodyMedium.copyWith(
                  color: AppColors.placeholderText,
                ),
              ),
              SizedBox(height: screenHeight * 0.05),
              // Campo de texto para el código de verificación
              TextField(
                onChanged: (value) {
                  setState(() {
                    _verificationCode = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Ingresa el código de 4 dígitos',
                  hintStyle: AppFonts.bodyMedium.copyWith(
                    color: AppColors.placeholderText,
                  ),
                  filled: true,
                  fillColor: AppColors.primary,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                ),
                style: AppFonts.bodyMedium.copyWith(
                  color: AppColors.secondary,
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                maxLength: 4,
              ),
              const Spacer(),
              CustomButton(
                text: 'Siguiente',
                onPressed: () {
                  print(
                    'El código que ingresó el usuario es: $_verificationCode',
                  );
                  // Aquí iría la lógica para verificar el código y navegar
                },
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
