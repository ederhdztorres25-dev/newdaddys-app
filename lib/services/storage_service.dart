import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  /// Selecciona una imagen de la galería o cámara
  Future<File?> pickImage({bool fromCamera = false}) async {
    try {
      print('Iniciando selección de imagen...');

      // Seleccionar imagen directamente
      final XFile? image = await _picker.pickImage(
        source: fromCamera ? ImageSource.camera : ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 90,
      );

      if (image == null) {
        print('No se seleccionó imagen');
        return null;
      }

      print('Imagen seleccionada: ${image.path}');
      return File(image.path);
    } catch (e) {
      print('Error al seleccionar imagen: $e');
      throw Exception('Error al seleccionar imagen: $e');
    }
  }

  /// Recorta la imagen a proporción 4:5
  Future<File?> cropImage(File imageFile) async {
    try {
      print('Iniciando recorte de imagen...');

      final croppedFile = await ImageCropper().cropImage(
        sourcePath: imageFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 4, ratioY: 5),
        compressQuality: 85,
        maxWidth: 1080,
        maxHeight: 1350,
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
        print('Recorte cancelado');
        return null;
      }

      print('Imagen recortada: ${croppedFile.path}');
      return File(croppedFile.path);
    } catch (e) {
      print('Error al recortar imagen: $e');
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
      print('Iniciando subida de imagen...');

      // Crear referencia al archivo en Storage
      final storageRef = _storage
          .ref()
          .child('profile_photos')
          .child(userId)
          .child('photo_$photoIndex.jpg');

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

      print('Imagen subida exitosamente: $downloadUrl');
      return downloadUrl;
    } catch (e) {
      print('Error al subir imagen: $e');
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
      print('Iniciando proceso completo de foto...');

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

      print('Proceso completo exitoso');
      return downloadUrl;
    } catch (e) {
      print('Error en el proceso de foto: $e');
      throw Exception('Error en el proceso de foto: $e');
    }
  }
}
