import 'package:flutter/material.dart';
import 'package:newdaddys/theme/app_colors.dart';
import 'package:newdaddys/theme/app_fonts.dart';
import 'package:newdaddys/theme/app_sizes.dart';
import 'package:newdaddys/widgets/custom_app_bar.dart';
import 'package:newdaddys/widgets/custom_button.dart';
import 'package:newdaddys/routes/app_routes.dart';

class PhoneNumberScreen extends StatelessWidget {
  const PhoneNumberScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: const CustomAppBar(
        title: 'Crea tu perfil',
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * AppSizes.horizontalPadding,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * 0.05),
                Text('Teléfono', style: AppFonts.h2),
                SizedBox(height: screenHeight * 0.01),
                Text(
                  'Agrega un número de teléfono para proteger tu cuenta',
                  style: AppFonts.bodyMedium
                      .copyWith(color: AppColors.placeholderText),
                ),
                SizedBox(height: screenHeight * 0.05),

                // Phone number input
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Country Code Picker
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 18),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(12),
                        border:
                            Border.all(color: AppColors.borderColor, width: 2),
                      ),
                      child: Text(
                        '🇲🇽 + 52',
                        style: AppFonts.bodyMedium,
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Phone Number Field
                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.phone,
                        style: AppFonts.bodyMedium,
                        decoration: InputDecoration(
                          hintText: 'Número telefónico',
                          hintStyle: AppFonts.bodyMedium
                              .copyWith(color: AppColors.placeholderText),
                          filled: true,
                          fillColor: AppColors.primary,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                                color: AppColors.borderColor, width: 2),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                                color: AppColors.borderColor, width: 2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                                color: AppColors.secondary, width: 2),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 18),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.5),
                // Next Button
                CustomButton(
                  text: 'Siguiente',
                  onPressed: () {
                    Navigator.pushNamed(
                        context, AppRoutes.physicalCharacteristics);
                  },
                  height: screenHeight * AppSizes.buttonHeight,
                ),
                SizedBox(height: screenHeight * 0.05),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
