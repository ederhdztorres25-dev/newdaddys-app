import 'package:flutter/material.dart';
import 'package:newdaddys/theme/app_colors.dart';
import 'package:newdaddys/theme/app_fonts.dart';
import 'package:newdaddys/theme/app_sizes.dart';
import 'package:newdaddys/widgets/custom_app_bar.dart';
import 'package:newdaddys/widgets/custom_button.dart';
import 'dart:io';
import 'package:newdaddys/routes/app_routes.dart';
import 'package:newdaddys/mixins/registration_screen_mixin.dart';
import 'package:newdaddys/constants/registration_options.dart';
import 'package:newdaddys/services/storage_service.dart';

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

  // Lista para almacenar las URLs de las fotos subidas
  final List<String> _photoUrls = [];

  // Servicio de Storage
  final StorageService _storageService = StorageService();

  // Función para seleccionar y subir una imagen
  Future<void> _pickImage(int index) async {
    try {
      await executeWithLoading(() async {
        final user = getCurrentUser()!;

        // Mostrar diálogo para elegir fuente de imagen
        final bool? fromCamera = await _showImageSourceDialog();
        if (fromCamera == null) return; // Usuario canceló

        // Seleccionar, recortar y subir foto
        final String? photoUrl = await _storageService.selectCropAndUploadPhoto(
          userId: user.uid,
          photoIndex: index,
          fromCamera: fromCamera,
        );

        if (photoUrl != null) {
          setState(() {
            // Guardar la URL en la lista
            while (_photoUrls.length <= index) {
              _photoUrls.add('');
            }
            _photoUrls[index] = photoUrl;
          });

          showSuccessDialog('Foto subida exitosamente');
        }
      });
    } catch (e) {
      showErrorDialog('Error al subir foto: ${e.toString()}');
    }
  }

  // Diálogo para elegir fuente de imagen
  Future<bool?> _showImageSourceDialog() async {
    return showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: AppColors.primary,
            title: Text(
              'Seleccionar foto',
              style: AppFonts.h3.copyWith(color: Colors.white),
            ),
            content: Text(
              '¿De dónde quieres tomar la foto?',
              style: AppFonts.bodyMedium.copyWith(color: Colors.white),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false), // Galería
                child: Text(
                  'Galería',
                  style: AppFonts.bodyMedium.copyWith(color: Colors.white),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true), // Cámara
                child: Text(
                  'Cámara',
                  style: AppFonts.bodyMedium.copyWith(
                    color: AppColors.secondary,
                  ),
                ),
              ),
            ],
          ),
    );
  }

  Future<void> _saveAndContinue() async {
    // Validar que al menos se haya subido una foto
    if (_photoUrls.isEmpty || _photoUrls.every((url) => url.isEmpty)) {
      showErrorDialog('Por favor sube al menos una foto de perfil');
      return;
    }

    await executeWithLoading(() async {
      final user = getCurrentUser()!;

      // Filtrar URLs vacías
      final photoUrls = _photoUrls.where((url) => url.isNotEmpty).toList();

      // Guardar URLs en Firestore
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
              _PhotoGrid(
                images: _images,
                photoUrls: _photoUrls,
                onPickImage: _pickImage,
              ),

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
  final List<String> photoUrls;
  final Function(int) onPickImage;

  const _PhotoGrid({
    required this.images,
    required this.photoUrls,
    required this.onPickImage,
  });

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
    final bool hasPhoto =
        index < photoUrls.length && photoUrls[index].isNotEmpty;

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
        child: Stack(
          children: [
            // Imagen o placeholder
            hasPhoto
                ? ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    photoUrls[index],
                    fit: BoxFit.cover,
                    width: width,
                    height: height,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value:
                              loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                          color: AppColors.secondary,
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Icon(
                          Icons.error,
                          color: AppColors.placeholderText,
                          size: 40,
                        ),
                      );
                    },
                  ),
                )
                : const Center(
                  child: Icon(
                    Icons.add,
                    color: AppColors.placeholderText,
                    size: 40,
                  ),
                ),

            // Overlay para cambiar foto (si ya hay una foto)
            if (hasPhoto)
              Positioned(
                bottom: 4,
                right: 4,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.edit, color: Colors.white, size: 16),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
