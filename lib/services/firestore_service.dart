import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:newdaddys/models/user_profile.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'user_profiles';

  /// Crea un perfil básico de usuario
  Future<void> createUserProfile({
    required String userId,
    required String email,
  }) async {
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
  }

  /// Obtiene el perfil de un usuario
  Future<UserProfile?> getUserProfile(String userId) async {
    try {
      final doc = await _firestore.collection(_collection).doc(userId).get();
      if (doc.exists) {
        return UserProfile.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      print('Error getting user profile: $e');
      return null;
    }
  }

  /// Verifica si existe un perfil para el usuario
  Future<bool> profileExists(String userId) async {
    try {
      final doc = await _firestore.collection(_collection).doc(userId).get();
      return doc.exists;
    } catch (e) {
      print('Error checking profile existence: $e');
      return false;
    }
  }

  /// Verifica si el perfil del usuario está completo (tiene todos los campos obligatorios)
  Future<bool> isProfileComplete(String userId) async {
    try {
      final doc = await _firestore.collection(_collection).doc(userId).get();
      if (!doc.exists) return false;

      final data = doc.data() as Map<String, dynamic>?;
      if (data == null) return false;

      // Verificar campos obligatorios para un perfil completo
      final hasUserType =
          data['userType'] != null && data['userType'].toString().isNotEmpty;
      final hasName =
          data['name'] != null && data['name'].toString().isNotEmpty;
      final hasGender =
          data['gender'] != null && data['gender'].toString().isNotEmpty;
      final hasSexualOrientation =
          data['sexualOrientation'] != null &&
          data['sexualOrientation'].toString().isNotEmpty;
      final hasPhotos =
          data['profilePhotos'] != null &&
          (data['profilePhotos'] as List).isNotEmpty;
      final hasPhoneNumber =
          data['phoneNumber'] != null &&
          data['phoneNumber'].toString().isNotEmpty;
      final hasHeight = data['height'] != null;
      final hasComplexion =
          data['complexion'] != null &&
          data['complexion'].toString().isNotEmpty;
      final hasAppearance =
          data['appearance'] != null &&
          data['appearance'].toString().isNotEmpty;
      final hasSmokingHabit =
          data['smokingHabit'] != null &&
          data['smokingHabit'].toString().isNotEmpty;
      final hasDrinkingHabit =
          data['drinkingHabit'] != null &&
          data['drinkingHabit'].toString().isNotEmpty;
      final hasTastes =
          data['tastes'] != null && (data['tastes'] as List).isNotEmpty;
      final hasStory =
          data['story'] != null && data['story'].toString().isNotEmpty;
      final hasSeeking =
          data['seeking'] != null && data['seeking'].toString().isNotEmpty;

      return hasUserType &&
          hasName &&
          hasGender &&
          hasSexualOrientation &&
          hasPhotos &&
          hasPhoneNumber &&
          hasHeight &&
          hasComplexion &&
          hasAppearance &&
          hasSmokingHabit &&
          hasDrinkingHabit &&
          hasTastes &&
          hasStory &&
          hasSeeking;
    } catch (e) {
      print('Error checking profile completion: $e');
      return false;
    }
  }

  /// Actualiza la preferencia de perfil (baby/daddy)
  Future<void> updateProfilePreference({
    required String userId,
    required String userType,
  }) async {
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
    }
  }

  /// Actualiza los datos personales
  Future<void> updatePersonalDetails({
    required String userId,
    String? name,
    String? gender,
    String? sexualOrientation,
  }) async {
    final updates = <String, dynamic>{
      'updatedAt': Timestamp.fromDate(DateTime.now()),
    };

    if (name != null) updates['name'] = name;
    if (gender != null) updates['gender'] = gender;
    if (sexualOrientation != null)
      updates['sexualOrientation'] = sexualOrientation;

    await _firestore.collection(_collection).doc(userId).update(updates);
  }

  /// Actualiza las fotos del perfil
  Future<void> updatePhotos({
    required String userId,
    required List<String> photoUrls,
  }) async {
    await _firestore.collection(_collection).doc(userId).update({
      'profilePhotos': photoUrls,
      'updatedAt': Timestamp.fromDate(DateTime.now()),
    });
  }

  /// Actualiza el número de teléfono
  Future<void> updatePhoneNumber({
    required String userId,
    required String phoneNumber,
  }) async {
    await _firestore.collection(_collection).doc(userId).update({
      'phoneNumber': phoneNumber,
      'updatedAt': Timestamp.fromDate(DateTime.now()),
    });
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
  }

  /// Actualiza todo el perfil de usuario
  Future<void> updateUserProfile({
    required String userId,
    required UserProfile profile,
  }) async {
    final updatedProfile = profile.copyWith(updatedAt: DateTime.now());

    await _firestore
        .collection(_collection)
        .doc(userId)
        .set(updatedProfile.toFirestore());
  }

  /// Elimina el perfil de usuario
  Future<void> deleteUserProfile(String userId) async {
    await _firestore.collection(_collection).doc(userId).delete();
  }
}
