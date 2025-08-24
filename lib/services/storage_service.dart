import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:newdaddys/constants/app_constants.dart';
import 'package:newdaddys/utils/logger.dart';

/// Servicio para manejo de imágenes y almacenamiento en Firebase Storage
class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  /// Selecciona una imagen de la galería o cámara
  Future<File?> pickImage({bool fromCamera = false}) async {
    try {
      Logger.process('Iniciando selección de imagen', tag: 'StorageService');

      final XFile? image = await _picker.pickImage(
        source: fromCamera ? ImageSource.camera : ImageSource.gallery,
        maxWidth: AppConstants.maxImageWidth.toDouble(),
        maxHeight: AppConstants.maxImageHeight.toDouble(),
        imageQuality: AppConstants.imageQuality,
      );

      if (image == null) {
        Logger.info('Selección de imagen cancelada', tag: 'StorageService');
        return null;
      }

      Logger.success('Imagen seleccionada: ${image.path}', tag: 'StorageService');
      return File(image.path);
    } catch (e) {
      Logger.error('Error al seleccionar imagen', tag: 'StorageService', error: e);
      throw Exception('Error al seleccionar imagen: $e');
    }
  }

  /// Recorta la imagen a proporción 4:5
  Future<File?> cropImage(File imageFile) async {
    try {
      Logger.process('Iniciando recorte de imagen', tag: 'StorageService');

      final croppedFile = await ImageCropper().cropImage(
        sourcePath: imageFile.path,
        aspectRatio: const CropAspectRatio(
          ratioX: AppConstants.cropAspectRatioX,
          ratioY: AppConstants.cropAspectRatioY,
        ),
        compressQuality: AppConstants.cropQuality,
        maxWidth: AppConstants.maxCropWidth,
        maxHeight: AppConstants.maxCropHeight,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Recortar foto',
            toolbarColor: const Color(0xFF1E1E1E),
            toolbarWidgetColor: Colors.white,
            lockAspectRatio: true,
            hideBottomControls: false,
          ),
          IOSUiSettings(
            title: 'Recortar foto',
            aspectRatioLockEnabled: true,
            aspectRatioPickerButtonHidden: true,
            resetAspectRatioEnabled: false,
          ),
        ],
      );

      if (croppedFile == null) {
        Logger.info('Recorte de imagen cancelado', tag: 'StorageService');
        return null;
      }

      Logger.success('Imagen recortada: ${croppedFile.path}', tag: 'StorageService');
      return File(croppedFile.path);
    } catch (e) {
      Logger.error('Error al recortar imagen', tag: 'StorageService', error: e);
      throw Exception('Error al recortar imagen: $e');
    }
  }

  /// Sube una imagen a Firebase Storage
  Future<String> uploadProfilePhoto(
    File imageFile,
    String userId,
    int photoIndex,
  ) async {
    try {
      Logger.process('Iniciando subida de imagen', tag: 'StorageService');

      // Crear referencia al archivo en Storage
      final storageRef = _storage
          .ref()
          .child(AppConstants.profilePhotosPath)
          .child(userId)
          .child('${AppConstants.photoFileName}$photoIndex${AppConstants.photoExtension}');

      // Subir archivo
      final uploadTask = storageRef.putFile(
        imageFile,
        SettableMetadata(
          contentType: 'image/jpeg',
          customMetadata: {
            'userId': userId,
            'photoIndex': photoIndex.toString(),
            'uploadedAt': DateTime.now().toIso8601String(),
          },
        ),
      );

      // Esperar a que termine la subida
      final snapshot = await uploadTask;

      // Obtener URL de descarga
      final downloadUrl = await snapshot.ref.getDownloadURL();

      Logger.success('Imagen subida exitosamente: $downloadUrl', tag: 'StorageService');
      return downloadUrl;
    } catch (e) {
      Logger.error('Error al subir imagen', tag: 'StorageService', error: e);
      throw Exception('Error al subir imagen: $e');
    }
  }

  /// Proceso completo: seleccionar, recortar y subir foto
  Future<String?> selectCropAndUploadPhoto({
    required String userId,
    required int photoIndex,
    bool fromCamera = false,
  }) async {
    try {
      Logger.process('Iniciando proceso completo de foto', tag: 'StorageService');

      // 1. Seleccionar imagen
      final File? selectedImage = await pickImage(fromCamera: fromCamera);
      if (selectedImage == null) return null;

      // 2. Recortar imagen
      final File? croppedImage = await cropImage(selectedImage);
      if (croppedImage == null) return null;

      // 3. Subir a Firebase Storage
      final String downloadUrl = await uploadProfilePhoto(
        croppedImage,
        userId,
        photoIndex,
      );

      Logger.success('Proceso completo exitoso', tag: 'StorageService');
      return downloadUrl;
    } catch (e) {
      Logger.error('Error en el proceso de foto', tag: 'StorageService', error: e);
      throw Exception('Error en el proceso de foto: $e');
    }
  }

  /// Elimina una foto del perfil de Firebase Storage
  Future<void> deleteProfilePhoto(String userId, int photoIndex) async {
    try {
      Logger.process('Eliminando foto del perfil', tag: 'StorageService');

      final storageRef = _storage
          .ref()
          .child(AppConstants.profilePhotosPath)
          .child(userId)
          .child('${AppConstants.photoFileName}$photoIndex${AppConstants.photoExtension}');

      await storageRef.delete();

      Logger.success('Foto eliminada exitosamente', tag: 'StorageService');
    } catch (e) {
      Logger.error('Error al eliminar foto', tag: 'StorageService', error: e);
      throw Exception('Error al eliminar foto: $e');
    }
  }
}
