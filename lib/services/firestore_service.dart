import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:newdaddys/models/user_profile.dart';
import 'package:newdaddys/constants/app_constants.dart';
import 'package:newdaddys/utils/logger.dart';
import 'package:newdaddys/utils/validation_utils.dart';

/// Servicio para manejo de operaciones con Firestore
class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = AppConstants.userProfilesCollection;

  /// Crea un perfil básico de usuario
  Future<void> createUserProfile({
    required String userId,
    required String email,
  }) async {
    try {
      Logger.process('Creando perfil de usuario', tag: 'FirestoreService');

      final now = DateTime.now();
      final userProfile = UserProfile(
        id: userId,
        email: email,
        createdAt: now,
        updatedAt: now,
      );

      await _firestore
          .collection(_collection)
          .doc(userId)
          .set(userProfile.toFirestore());

      Logger.success('Perfil de usuario creado exitosamente', tag: 'FirestoreService');
    } catch (e) {
      Logger.error('Error al crear perfil de usuario', tag: 'FirestoreService', error: e);
      throw Exception('Error al crear perfil de usuario: $e');
    }
  }

  /// Obtiene el perfil de un usuario
  Future<UserProfile?> getUserProfile(String userId) async {
    try {
      Logger.debug('Obteniendo perfil de usuario: $userId', tag: 'FirestoreService');

      final doc = await _firestore.collection(_collection).doc(userId).get();
      if (doc.exists) {
        final profile = UserProfile.fromFirestore(doc);
        Logger.success('Perfil obtenido exitosamente', tag: 'FirestoreService');
        return profile;
      }
      
      Logger.info('Perfil no encontrado', tag: 'FirestoreService');
      return null;
    } catch (e) {
      Logger.error('Error al obtener perfil de usuario', tag: 'FirestoreService', error: e);
      return null;
    }
  }

  /// Verifica si existe un perfil para el usuario
  Future<bool> profileExists(String userId) async {
    try {
      final doc = await _firestore.collection(_collection).doc(userId).get();
      return doc.exists;
    } catch (e) {
      Logger.error('Error al verificar existencia del perfil', tag: 'FirestoreService', error: e);
      return false;
    }
  }

  /// Verifica si el perfil del usuario está completo
  Future<bool> isProfileComplete(String userId) async {
    try {
      Logger.debug('Verificando completitud del perfil: $userId', tag: 'FirestoreService');

      final doc = await _firestore.collection(_collection).doc(userId).get();
      if (!doc.exists) return false;

      final data = doc.data() as Map<String, dynamic>?;
      if (data == null) return false;

      // Verificar campos obligatorios usando ValidationUtils
      final requiredFields = {
        'userType': data['userType'],
        'name': data['name'],
        'gender': data['gender'],
        'sexualOrientation': data['sexualOrientation'],
        'phoneNumber': data['phoneNumber'],
        'complexion': data['complexion'],
        'appearance': data['appearance'],
        'smokingHabit': data['smokingHabit'],
        'drinkingHabit': data['drinkingHabit'],
        'story': data['story'],
        'seeking': data['seeking'],
      };

      // Verificar que todos los campos requeridos estén presentes y no vacíos
      final hasAllRequiredFields = requiredFields.entries.every((entry) {
        final value = entry.value;
        return value != null && value.toString().isNotEmpty;
      });

      // Verificar campos especiales
      final hasPhotos = data['profilePhotos'] != null &&
          (data['profilePhotos'] as List).isNotEmpty;
      final hasHeight = data['height'] != null;
      final hasTastes = data['tastes'] != null && (data['tastes'] as List).isNotEmpty;

      final isComplete = hasAllRequiredFields && hasPhotos && hasHeight && hasTastes;

      Logger.info('Perfil completo: $isComplete', tag: 'FirestoreService');
      return isComplete;
    } catch (e) {
      Logger.error('Error al verificar completitud del perfil', tag: 'FirestoreService', error: e);
      return false;
    }
  }

  /// Actualiza la preferencia de perfil (baby/daddy)
  Future<void> updateProfilePreference({
    required String userId,
    required String userType,
  }) async {
    try {
      Logger.process('Actualizando preferencia de perfil', tag: 'FirestoreService');

      final now = DateTime.now();
      final updates = {
        'userType': userType,
        'updatedAt': Timestamp.fromDate(now),
      };

      // Verificar si el documento existe
      final docRef = _firestore.collection(_collection).doc(userId);
      final doc = await docRef.get();

      if (doc.exists) {
        // Si existe, hacer update
        await docRef.update(updates);
        Logger.success('Preferencia de perfil actualizada', tag: 'FirestoreService');
      } else {
        // Si no existe, crear el documento con datos básicos
        final user = FirebaseAuth.instance.currentUser;
        final basicProfile = {
          'id': userId,
          'email': user?.email ?? '',
          'userType': userType,
          'createdAt': Timestamp.fromDate(now),
          'updatedAt': Timestamp.fromDate(now),
        };
        await docRef.set(basicProfile);
        Logger.success('Perfil básico creado con preferencia', tag: 'FirestoreService');
      }
    } catch (e) {
      Logger.error('Error al actualizar preferencia de perfil', tag: 'FirestoreService', error: e);
      throw Exception('Error al actualizar preferencia de perfil: $e');
    }
  }

  /// Actualiza los datos personales
  Future<void> updatePersonalDetails({
    required String userId,
    String? name,
    String? gender,
    String? sexualOrientation,
  }) async {
    try {
      Logger.process('Actualizando datos personales', tag: 'FirestoreService');

      final updates = <String, dynamic>{
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      };

      if (name != null) updates['name'] = name;
      if (gender != null) updates['gender'] = gender;
      if (sexualOrientation != null) updates['sexualOrientation'] = sexualOrientation;

      await _firestore.collection(_collection).doc(userId).update(updates);
      Logger.success('Datos personales actualizados', tag: 'FirestoreService');
    } catch (e) {
      Logger.error('Error al actualizar datos personales', tag: 'FirestoreService', error: e);
      throw Exception('Error al actualizar datos personales: $e');
    }
  }

  /// Actualiza las fotos del perfil
  Future<void> updatePhotos({
    required String userId,
    required List<String> photoUrls,
  }) async {
    try {
      Logger.process('Actualizando fotos del perfil', tag: 'FirestoreService');

      // Validar que la lista de fotos sea válida
      if (!ValidationUtils.isValidPhotoList(photoUrls)) {
        throw Exception('Lista de fotos inválida');
      }

      await _firestore.collection(_collection).doc(userId).update({
        'profilePhotos': photoUrls,
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });

      Logger.success('Fotos del perfil actualizadas', tag: 'FirestoreService');
    } catch (e) {
      Logger.error('Error al actualizar fotos del perfil', tag: 'FirestoreService', error: e);
      throw Exception('Error al actualizar fotos del perfil: $e');
    }
  }

  /// Actualiza el número de teléfono
  Future<void> updatePhoneNumber({
    required String userId,
    required String phoneNumber,
  }) async {
    try {
      Logger.process('Actualizando número de teléfono', tag: 'FirestoreService');

      // Validar formato del teléfono
      if (!ValidationUtils.isValidPhoneNumber(phoneNumber)) {
        throw Exception('Formato de teléfono inválido');
      }

      await _firestore.collection(_collection).doc(userId).update({
        'phoneNumber': phoneNumber,
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });

      Logger.success('Número de teléfono actualizado', tag: 'FirestoreService');
    } catch (e) {
      Logger.error('Error al actualizar número de teléfono', tag: 'FirestoreService', error: e);
      throw Exception('Error al actualizar número de teléfono: $e');
    }
  }

  /// Actualiza las características físicas
  Future<void> updatePhysicalCharacteristics({
    required String userId,
    double? height,
    String? complexion,
    String? appearance,
    String? smokingHabit,
    String? drinkingHabit,
    List<String>? tastes,
    String? story,
    String? seeking,
  }) async {
    try {
      Logger.process('Actualizando características físicas', tag: 'FirestoreService');

      final updates = <String, dynamic>{
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      };

      if (height != null) updates['height'] = height;
      if (complexion != null) updates['complexion'] = complexion;
      if (appearance != null) updates['appearance'] = appearance;
      if (smokingHabit != null) updates['smokingHabit'] = smokingHabit;
      if (drinkingHabit != null) updates['drinkingHabit'] = drinkingHabit;
      if (tastes != null) updates['tastes'] = tastes;
      if (story != null) updates['story'] = story;
      if (seeking != null) updates['seeking'] = seeking;

      await _firestore.collection(_collection).doc(userId).update(updates);
      Logger.success('Características físicas actualizadas', tag: 'FirestoreService');
    } catch (e) {
      Logger.error('Error al actualizar características físicas', tag: 'FirestoreService', error: e);
      throw Exception('Error al actualizar características físicas: $e');
    }
  }

  /// Actualiza todo el perfil de usuario
  Future<void> updateUserProfile({
    required String userId,
    required UserProfile profile,
  }) async {
    try {
      Logger.process('Actualizando perfil completo de usuario', tag: 'FirestoreService');

      final updatedProfile = profile.copyWith(updatedAt: DateTime.now());

      await _firestore
          .collection(_collection)
          .doc(userId)
          .set(updatedProfile.toFirestore());

      Logger.success('Perfil completo actualizado', tag: 'FirestoreService');
    } catch (e) {
      Logger.error('Error al actualizar perfil completo', tag: 'FirestoreService', error: e);
      throw Exception('Error al actualizar perfil completo: $e');
    }
  }

  /// Elimina el perfil de usuario
  Future<void> deleteUserProfile(String userId) async {
    try {
      Logger.process('Eliminando perfil de usuario', tag: 'FirestoreService');

      await _firestore.collection(_collection).doc(userId).delete();
      Logger.success('Perfil de usuario eliminado', tag: 'FirestoreService');
    } catch (e) {
      Logger.error('Error al eliminar perfil de usuario', tag: 'FirestoreService', error: e);
      throw Exception('Error al eliminar perfil de usuario: $e');
    }
  }
}
