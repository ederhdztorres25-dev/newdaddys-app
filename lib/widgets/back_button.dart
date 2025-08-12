import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:newdaddys/theme/app_colors.dart';

class CustomBackButton extends StatelessWidget {
  // Constructor simple
  const CustomBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Al tocar el botón, regresamos a la pantalla anterior
      onTap: () => Navigator.pop(context),
      child: Container(
        // Margen a la izquierda para separarlo del borde
        margin: const EdgeInsets.only(left: 16),
        decoration: BoxDecoration(
          // Forma circular
          shape: BoxShape.circle,
          // Borde blanco delgado
          border: Border.all(
            color: AppColors.secondary,
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          // Icono SVG de flecha
          child: SvgPicture.asset(
            'assets/icons/move-left.svg',
            colorFilter: const ColorFilter.mode(
              AppColors.secondary,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}
