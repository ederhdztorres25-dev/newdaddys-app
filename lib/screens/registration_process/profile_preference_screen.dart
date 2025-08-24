import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:newdaddys/theme/app_colors.dart';
import 'package:newdaddys/theme/app_fonts.dart';
import 'package:newdaddys/theme/app_sizes.dart';
import 'package:newdaddys/widgets/custom_app_bar.dart';
import 'package:newdaddys/widgets/custom_button.dart';
import 'package:newdaddys/widgets/selection_button.dart';
import 'package:newdaddys/routes/app_routes.dart';
import 'package:newdaddys/mixins/registration_screen_mixin.dart';
import 'package:newdaddys/constants/registration_options.dart';
import 'package:newdaddys/services/auth_service.dart';

class ProfilePreferenceScreen extends StatefulWidget {
  const ProfilePreferenceScreen({super.key});

  @override
  _ProfilePreferenceScreenState createState() =>
      _ProfilePreferenceScreenState();
}

class _ProfilePreferenceScreenState extends State<ProfilePreferenceScreen>
    with RegistrationScreenMixin {
  int? _selectedIndex; // 0 for baby, 1 for daddy/mommy

  void _onSelection(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _saveAndContinue() async {
    if (!validateRequiredSelection(
      _selectedIndex != null ? 'selección' : null,
      'qué estás buscando',
    )) {
      return;
    }

    await executeWithLoading(() async {
      final user = getCurrentUser()!;
      final userType = RegistrationOptions.userTypes[_selectedIndex!];

      await firestore.updateProfilePreference(
        userId: user.uid,
        userType: userType,
      );

      navigateToNext(AppRoutes.personalDetails);
    });
  }

  Future<void> _handleBackPressed() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    await authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBar(
        title: 'Crea tu perfil',
        onBackPressed: _handleBackPressed,
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
              Text(
                '¿Qué estás buscando?',
                style: AppFonts.bodyMedium.copyWith(color: AppColors.secondary),
              ),
              SizedBox(height: screenHeight * 0.05),
              SelectionButton(
                text: 'Ser suggar baby',
                isSelected: _selectedIndex == 0,
                onTap: () => _onSelection(0),
                height: screenHeight * AppSizes.buttonHeight,
              ),
              SizedBox(height: screenHeight * 0.02),
              SelectionButton(
                text: 'Ser suggar daddy / suggar mommy',
                isSelected: _selectedIndex == 1,
                onTap: () => _onSelection(1),
                height: screenHeight * AppSizes.buttonHeight,
              ),
              const Spacer(),
              CustomButton(
                text: isLoading ? 'Guardando...' : 'Siguiente',
                onPressed:
                    _selectedIndex != null && !isLoading
                        ? _saveAndContinue
                        : null, // Disable button if nothing is selected or loading
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
