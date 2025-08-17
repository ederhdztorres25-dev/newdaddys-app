import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:newdaddys/theme/app_colors.dart';
import 'package:newdaddys/theme/app_fonts.dart';
import 'package:newdaddys/theme/app_sizes.dart';
import 'package:newdaddys/widgets/custom_app_bar.dart';
import 'package:newdaddys/widgets/custom_button.dart';
import 'package:newdaddys/widgets/selection_button.dart';
import 'package:newdaddys/routes/app_routes.dart';
import 'package:newdaddys/services/firestore_service.dart';

class ProfilePreferenceScreen extends StatefulWidget {
  const ProfilePreferenceScreen({super.key});

  @override
  _ProfilePreferenceScreenState createState() =>
      _ProfilePreferenceScreenState();
}

class _ProfilePreferenceScreenState extends State<ProfilePreferenceScreen> {
  int? _selectedIndex; // 0 for baby, 1 for daddy/mommy
  bool _isLoading = false;
  final FirestoreService _firestore = FirestoreService();

  void _onSelection(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _saveAndContinue() async {
    if (_selectedIndex == null) return;

    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        _showErrorDialog('Usuario no autenticado');
        return;
      }

      // Convertir índice a userType
      final userType = _selectedIndex == 0 ? 'baby' : 'daddy/mommy';

      // Guardar en Firestore
      await _firestore.updateProfilePreference(
        userId: user.uid,
        userType: userType,
      );

      // Navegar a la siguiente pantalla
      if (mounted) {
        Navigator.pushNamed(context, AppRoutes.personalDetails);
      }
    } catch (e) {
      _showErrorDialog('Error al guardar: ${e.toString()}');
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
                onPressed: () => Navigator.pop(context),
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
      appBar: const CustomAppBar(title: 'Crea tu perfil'),
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
                text: _isLoading ? 'Guardando...' : 'Siguiente',
                onPressed:
                    _selectedIndex != null && !_isLoading
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
