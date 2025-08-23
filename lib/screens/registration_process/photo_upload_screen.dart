import 'package:flutter/material.dart';
import 'package:newdaddys/theme/app_colors.dart';
import 'package:newdaddys/theme/app_fonts.dart';
import 'package:newdaddys/theme/app_sizes.dart';
import 'package:newdaddys/widgets/custom_app_bar.dart';
import 'package:newdaddys/widgets/custom_button.dart';
import 'dart:io'; // Se necesitará para manejar los archivos de imagen
import 'package:newdaddys/routes/app_routes.dart';
import 'package:newdaddys/mixins/registration_screen_mixin.dart';
import 'package:newdaddys/constants/registration_options.dart';

class PhotoUploadScreen extends StatefulWidget {
  const PhotoUploadScreen({super.key});

  @override
  _PhotoUploadScreenState createState() => _PhotoUploadScreenState();
}

class _PhotoUploadScreenState extends State<PhotoUploadScreen>
    with RegistrationScreenMixin {
  // Lista para almacenar las imágenes seleccionadas (usando File)
  final List<File?> _images = List.generate(
    RegistrationOptions.maxPhotos,
    (_) => null,
  );

  // Función para simular la selección de una imagen
  void _pickImage(int index) {
    // Aquí iría la lógica para abrir la galería con image_picker
    print('Seleccionar imagen para el cuadro $index');
    // setState(() {
    //   _images[index] = pickedFile;
    // });
  }

  Future<void> _saveAndContinue() async {
    // Por ahora, permitir continuar sin fotos (para testing)
    // En producción, podrías requerir al menos una foto

    await executeWithLoading(() async {
      final user = getCurrentUser()!;

      // Simular URLs de fotos (en producción, subirías a Firebase Storage)
      final photoUrls = <String>[];
      for (int i = 0; i < _images.length; i++) {
        if (_images[i] != null) {
          // Aquí subirías la imagen a Firebase Storage y obtendrías la URL
          photoUrls.add('https://example.com/photo_$i.jpg');
        }
      }

      // Guardar en Firestore (por ahora con URLs vacías)
      await firestore.updatePhotos(userId: user.uid, photoUrls: photoUrls);

      // Navegar a la siguiente pantalla
      navigateToNext(AppRoutes.phoneNumber);
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    // Calculamos el tamaño de los cuadros de imagen
    final double totalWidth = screenWidth * 0.84;
    final double spacing = 10.0;
    final double smallSquareSize = (totalWidth - spacing * 2) / 3;
    final double largeSquareSize = smallSquareSize * 2 + spacing;

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
                'Subir fotos',
                style: AppFonts.h2.copyWith(color: AppColors.secondary),
              ),
              SizedBox(height: screenHeight * 0.01),
              Text(
                'Súper, añade fotos para que te conozcan mejor',
                style: AppFonts.bodyMedium.copyWith(
                  color: AppColors.placeholderText,
                ),
              ),
              SizedBox(height: screenHeight * 0.05),

              // Cuadrícula de fotos
              _PhotoGrid(images: _images, onPickImage: _pickImage),

              const Spacer(),

              // Mensaje de advertencia
              Text(
                'Las fotos deben representarte. No se permiten imágenes de otras personas o contenido inapropiado.',
                style: AppFonts.bodySmall.copyWith(
                  color: AppColors.placeholderText,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: screenHeight * 0.03),

              // Botón de siguiente
              CustomButton(
                text: isLoading ? 'Guardando...' : 'Siguiente',
                onPressed: !isLoading ? _saveAndContinue : null,
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

class _PhotoGrid extends StatelessWidget {
  final List<File?> images;
  final Function(int) onPickImage;

  const _PhotoGrid({required this.images, required this.onPickImage});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double totalWidth = screenWidth * 0.84;
    final double spacing = 10.0;
    final double smallSquareSize = (totalWidth - spacing * 2) / 3;
    final double largeSquareSize = smallSquareSize * 2 + spacing;

    return SizedBox(
      height: largeSquareSize + spacing + smallSquareSize,
      child: Column(
        children: [
          Row(
            children: [
              _buildPhotoPlaceholder(0, largeSquareSize, largeSquareSize),
              SizedBox(width: spacing),
              Column(
                children: [
                  _buildPhotoPlaceholder(1, smallSquareSize, smallSquareSize),
                  SizedBox(height: spacing),
                  _buildPhotoPlaceholder(2, smallSquareSize, smallSquareSize),
                ],
              ),
            ],
          ),
          SizedBox(height: spacing),
          Row(
            children: [
              _buildPhotoPlaceholder(3, smallSquareSize, smallSquareSize),
              SizedBox(width: spacing),
              _buildPhotoPlaceholder(4, smallSquareSize, smallSquareSize),
              SizedBox(width: spacing),
              _buildPhotoPlaceholder(5, smallSquareSize, smallSquareSize),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoPlaceholder(int index, double width, double height) {
    return GestureDetector(
      onTap: () => onPickImage(index),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderColor, width: 2),
        ),
        child:
            images[index] == null
                ? const Icon(
                  Icons.add,
                  color: AppColors.placeholderText,
                  size: 40,
                )
                : ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(images[index]!, fit: BoxFit.cover),
                ),
      ),
    );
  }
}
