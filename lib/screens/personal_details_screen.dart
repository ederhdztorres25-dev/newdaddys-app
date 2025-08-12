import 'package:flutter/material.dart';
import 'package:newdaddys/theme/app_colors.dart';
import 'package:newdaddys/theme/app_fonts.dart';
import 'package:newdaddys/theme/app_sizes.dart';
import 'package:newdaddys/widgets/custom_app_bar.dart';
import 'package:newdaddys/widgets/custom_button.dart';
import 'package:newdaddys/widgets/custom_text_field.dart';
import 'package:newdaddys/widgets/selection_button.dart';
import 'package:newdaddys/routes/app_routes.dart';

class PersonalDetailsScreen extends StatefulWidget {
  const PersonalDetailsScreen({super.key});

  @override
  _PersonalDetailsScreenState createState() => _PersonalDetailsScreenState();
}

class _PersonalDetailsScreenState extends State<PersonalDetailsScreen> {
  String? _gender;
  String? _sexualOrientation;

  final List<String> _genderOptions = ['Hombre', 'Mujer', 'No binario'];
  final List<String> _orientationOptions = [
    'Heterosexual',
    'Homosexual',
    'Lesbiana',
    'Bisexual'
  ];

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
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * 0.05),
                Text('Cuéntanos sobre tí',
                    style: AppFonts.bodyMedium
                        .copyWith(color: AppColors.secondary)),
                SizedBox(height: screenHeight * 0.05),

                // Name Field
                _buildSectionTitle('Tu nombre', screenHeight),
                const CustomTextField(
                  hintText: '¿Cómo te llamas?',
                  prefixIcon: Icons.search,
                ),
                SizedBox(height: screenHeight * 0.05),

                // Gender Selection
                _buildSectionTitle('Tu género', screenHeight),
                _buildGenderSelection(screenWidth, screenHeight),
                SizedBox(height: screenHeight * 0.05),

                // Sexual Orientation Selection
                _buildSectionTitle('Tu orientación sexual', screenHeight),
                _buildOrientationGrid(screenWidth, screenHeight),

                SizedBox(height: screenHeight * 0.1),

                // Next Button
                CustomButton(
                  text: 'Siguiente',
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.photoUpload);
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

  Widget _buildSectionTitle(String title, double screenHeight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppFonts.bodyMedium.copyWith(color: AppColors.secondary),
        ),
        SizedBox(height: screenHeight * 0.02),
      ],
    );
  }

  Widget _buildGenderSelection(double screenWidth, double screenHeight) {
    return Wrap(
      spacing: 10.0,
      runSpacing: 10.0,
      children: _genderOptions.map((option) {
        return SizedBox(
          width: (screenWidth * 0.84 - 20) / 3,
          child: SelectionButton(
            text: option,
            isSelected: _gender == option,
            onTap: () => setState(() => _gender = option),
            height: screenHeight * AppSizes.buttonHeight,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildOrientationGrid(double screenWidth, double screenHeight) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: (screenWidth * 0.84 - 10) / 2,
              child: SelectionButton(
                text: _orientationOptions[0],
                isSelected: _sexualOrientation == _orientationOptions[0],
                onTap: () =>
                    setState(() => _sexualOrientation = _orientationOptions[0]),
                height: screenHeight * AppSizes.buttonHeight,
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: (screenWidth * 0.84 - 10) / 2,
              child: SelectionButton(
                text: _orientationOptions[1],
                isSelected: _sexualOrientation == _orientationOptions[1],
                onTap: () =>
                    setState(() => _sexualOrientation = _orientationOptions[1]),
                height: screenHeight * AppSizes.buttonHeight,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            SizedBox(
              width: (screenWidth * 0.84 - 10) / 2,
              child: SelectionButton(
                text: _orientationOptions[2],
                isSelected: _sexualOrientation == _orientationOptions[2],
                onTap: () =>
                    setState(() => _sexualOrientation = _orientationOptions[2]),
                height: screenHeight * AppSizes.buttonHeight,
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: (screenWidth * 0.84 - 10) / 2,
              child: SelectionButton(
                text: _orientationOptions[3],
                isSelected: _sexualOrientation == _orientationOptions[3],
                onTap: () =>
                    setState(() => _sexualOrientation = _orientationOptions[3]),
                height: screenHeight * AppSizes.buttonHeight,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
