import 'package:cloud_firestore/cloud_firestore.dart';
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

  /// Actualiza la preferencia de perfil (baby/daddy)
  Future<void> updateProfilePreference({
    required String userId,
    required String userType,
  }) async {
    await _firestore.collection(_collection).doc(userId).update({
      'userType': userType,
      'updatedAt': Timestamp.fromDate(DateTime.now()),
    });
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
