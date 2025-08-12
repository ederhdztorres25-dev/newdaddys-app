import 'package:flutter/material.dart';
import 'package:newdaddys/routes/app_routes.dart';
import 'package:newdaddys/theme/app_colors.dart';
import 'package:newdaddys/theme/app_fonts.dart';
import 'package:newdaddys/theme/app_sizes.dart';
import 'package:newdaddys/widgets/back_button.dart';
import 'package:newdaddys/widgets/custom_text_field.dart';
import 'package:newdaddys/widgets/custom_button.dart';

class RecoveryPasswordStep1Screen extends StatelessWidget {
  const RecoveryPasswordStep1Screen({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
        toolbarHeight: screenHeight * 0.07,
        title: const Text(
          'Recupera tu contraseña',
          style: AppFonts.h2,
        ),
        leading: const CustomBackButton(),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * AppSizes.horizontalPadding,
            vertical: screenHeight * AppSizes.verticalPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Ingresa tu correo', style: AppFonts.bodyMedium),
              SizedBox(height: screenHeight * AppSizes.verticalPadding),
              // Campo de Email
              SizedBox(
                height: screenHeight * AppSizes.inputHeight,
                child: const CustomTextField(
                  hintText: 'Email',
                  prefixIcon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                ),
              ),

              // Empuja el botón hacia abajo
              const Spacer(),

              // Botón de siguiente
              CustomButton(
                text: 'Siguiente',
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.recoveryPasswordStep2);
                },
                height: screenHeight * AppSizes.buttonHeight,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
