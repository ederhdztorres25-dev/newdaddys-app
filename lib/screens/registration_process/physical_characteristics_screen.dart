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

class PhysicalCharacteristicsScreen extends StatefulWidget {
  const PhysicalCharacteristicsScreen({super.key});

  @override
  _PhysicalCharacteristicsScreenState createState() =>
      _PhysicalCharacteristicsScreenState();
}

class _PhysicalCharacteristicsScreenState
    extends State<PhysicalCharacteristicsScreen> {
  // State variables
  double _height = 170;
  String? _complexion;
  String? _appearance;
  String? _smokingHabit;
  String? _drinkingHabit;
  final Set<String> _tastes = {};
  bool _isLoading = false;
  final FirestoreService _firestore = FirestoreService();

  final TextEditingController _storyController = TextEditingController();
  final TextEditingController _seekingController = TextEditingController();

  // Options
  final List<String> _complexionOptions = [
    'Delgado',
    'Promedio',
    'Musculoso',
    'Gordito',
    'Atlético',
  ];
  final List<String> _appearanceOptions = [
    'Muy atractivo',
    'Atractivo',
    'Promedio',
    'Poco atractivo',
  ];
  final List<String> _drinkingOptions = ['Sí', 'No', 'De vez en cuando'];
  final List<String> _tastesOptions = [
    'Viajes',
    'Música',
    'Cine',
    'Comida',
    'Arte',
    'Deportes',
  ];

  @override
  void dispose() {
    _storyController.dispose();
    _seekingController.dispose();
    super.dispose();
  }

  Future<void> _saveAndFinish() async {
    // Validaciones básicas
    if (_complexion == null) {
      _showErrorDialog('Por favor selecciona tu complexión');
      return;
    }

    if (_appearance == null) {
      _showErrorDialog('Por favor selecciona tu apariencia');
      return;
    }

    if (_smokingHabit == null) {
      _showErrorDialog('Por favor indica si fumas');
      return;
    }

    if (_drinkingHabit == null) {
      _showErrorDialog('Por favor indica si bebes alcohol');
      return;
    }

    if (_tastes.isEmpty) {
      _showErrorDialog('Por favor selecciona al menos un gusto');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        _showErrorDialog('Usuario no autenticado');
        return;
      }

      // Guardar en Firestore
      await _firestore.updatePhysicalCharacteristics(
        userId: user.uid,
        height: _height,
        complexion: _complexion,
        appearance: _appearance,
        smokingHabit: _smokingHabit,
        drinkingHabit: _drinkingHabit,
        tastes: _tastes.toList(),
        story:
            _storyController.text.trim().isEmpty
                ? null
                : _storyController.text.trim(),
        seeking:
            _seekingController.text.trim().isEmpty
                ? null
                : _seekingController.text.trim(),
      );

      // Navegar al menú principal
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.mainMenu,
          (route) => false,
        );
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

  void _toggleTaste(String taste) {
    setState(() {
      if (_tastes.contains(taste)) {
        _tastes.remove(taste);
      } else {
        _tastes.add(taste);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    // Unified Spacing
    final double sectionSpacing = screenHeight * 0.03;
    final double titleSpacing = screenHeight * 0.015;
    final double buttonHeight = screenHeight * (220 / 3120);

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: const CustomAppBar(title: 'Crea tu perfil'),
      body: GestureDetector(
        onTap: () {
          // Ocultar el teclado cuando se toca fuera de un campo de texto
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * AppSizes.horizontalPadding,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: sectionSpacing),
                Text('Características físicas', style: AppFonts.h2),
                SizedBox(height: sectionSpacing),
                _buildSection('Altura', _buildHeightSlider(), titleSpacing),
                SizedBox(height: sectionSpacing),
                _buildSection(
                  'Tu historia',
                  _buildTextField(
                    _storyController,
                    'Cuentanos sobre ti ...',
                    500,
                  ),
                  titleSpacing,
                ),
                SizedBox(height: sectionSpacing),
                _buildSection(
                  'Complexión',
                  _buildGrid(
                    options: _complexionOptions,
                    selectedOptions: {_complexion},
                    onSelect: (option) => setState(() => _complexion = option),
                    itemsPerRow: 3,
                    buttonHeight: buttonHeight,
                  ),
                  titleSpacing,
                ),
                SizedBox(height: sectionSpacing),
                _buildSection(
                  'Apariencia',
                  _buildGrid(
                    options: _appearanceOptions,
                    selectedOptions: {_appearance},
                    onSelect: (option) => setState(() => _appearance = option),
                    itemsPerRow: 3,
                    buttonHeight: buttonHeight,
                  ),
                  titleSpacing,
                ),
                SizedBox(height: sectionSpacing),
                _buildSection(
                  'Lo que busco',
                  _buildTextField(
                    _seekingController,
                    'Cuéntanos ¿Qué buscas en la app?',
                    500,
                  ),
                  titleSpacing,
                ),
                SizedBox(height: sectionSpacing),
                Text(
                  'HÁBITOS',
                  style: AppFonts.h3.copyWith(letterSpacing: 1.5),
                ),
                SizedBox(height: sectionSpacing),
                _buildSection(
                  '¿Fumas?',
                  _buildSingleRowSelection(
                    options: const ['Sí', 'No'],
                    selectedOption: _smokingHabit,
                    onSelect:
                        (option) => setState(() => _smokingHabit = option),
                    buttonHeight: buttonHeight,
                  ),
                  titleSpacing,
                ),
                SizedBox(height: sectionSpacing),
                _buildSection(
                  '¿Bebes alcohol?',
                  _buildSingleRowSelection(
                    options: _drinkingOptions,
                    selectedOption: _drinkingHabit,
                    onSelect:
                        (option) => setState(() => _drinkingHabit = option),
                    buttonHeight: buttonHeight,
                  ),
                  titleSpacing,
                ),
                SizedBox(height: sectionSpacing),
                _buildSection(
                  'Tus gustos',
                  _buildGrid(
                    options: _tastesOptions,
                    selectedOptions: _tastes,
                    onSelect: _toggleTaste,
                    itemsPerRow: 2,
                    isMultiSelect: true,
                    buttonHeight: buttonHeight,
                  ),
                  titleSpacing,
                ),
                SizedBox(height: screenHeight * 0.05),
                CustomButton(
                  text: _isLoading ? 'Guardando...' : 'Finalizar',
                  onPressed: !_isLoading ? _saveAndFinish : null,
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

  Widget _buildSection(String title, Widget content, double titleSpacing) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppFonts.bodyMedium),
        SizedBox(height: titleSpacing),
        content,
      ],
    );
  }

  Widget _buildHeightSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text('${_height.round()} cm', style: AppFonts.bodyMedium),
        Slider(
          value: _height,
          min: 140,
          max: 220,
          divisions: 80,
          label: _height.round().toString(),
          onChanged: (double value) => setState(() => _height = value),
          activeColor: AppColors.secondary,
          inactiveColor: AppColors.borderColor,
        ),
      ],
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hintText,
    int maxLength,
  ) {
    return TextField(
      controller: controller,
      maxLength: maxLength,
      maxLines: 4,
      style: AppFonts.bodyMedium.copyWith(color: AppColors.secondary),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: AppFonts.bodyMedium.copyWith(
          color: AppColors.placeholderText,
        ),
        filled: true,
        fillColor: AppColors.primary,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderColor, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderColor, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.secondary, width: 2),
        ),
        counterStyle: AppFonts.bodySmall.copyWith(
          color: AppColors.placeholderText,
        ),
      ),
    );
  }

  Widget _buildGrid({
    required List<String> options,
    required Set<String?> selectedOptions,
    required Function(String) onSelect,
    required int itemsPerRow,
    bool isMultiSelect = false,
    required double buttonHeight,
  }) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double spacing = 10.0;
    final double totalPadding = screenWidth * AppSizes.horizontalPadding * 2;
    final double totalSpacing = spacing * (itemsPerRow - 1);
    final double buttonWidth =
        (screenWidth - totalPadding - totalSpacing) / itemsPerRow;

    return Wrap(
      spacing: spacing,
      runSpacing: spacing,
      children:
          options.map((option) {
            return SizedBox(
              width: buttonWidth,
              child: SelectionButton(
                text: option,
                isSelected: selectedOptions.contains(option),
                onTap: () {
                  FocusScope.of(context).unfocus();
                  onSelect(option);
                },
                height: buttonHeight,
              ),
            );
          }).toList(),
    );
  }

  Widget _buildSingleRowSelection({
    required List<String> options,
    required String? selectedOption,
    required Function(String) onSelect,
    required double buttonHeight,
  }) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double spacing = 10.0;
    final double totalPadding = screenWidth * AppSizes.horizontalPadding * 2;
    final double totalSpacing = spacing * (options.length - 1);
    final double buttonWidth =
        (screenWidth - totalPadding - totalSpacing) / options.length;

    return Row(
      children:
          options
              .map((option) {
                return Expanded(
                  child: SelectionButton(
                    text: option,
                    isSelected: selectedOption == option,
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      onSelect(option);
                    },
                    height: buttonHeight,
                  ),
                );
              })
              .toList()
              .expand((widget) => [widget, SizedBox(width: spacing)])
              .toList()
            ..removeLast(),
    );
  }
}
