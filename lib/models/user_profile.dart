import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String id;
  final String email;
  final String?
  userType; // 'baby' o 'daddy/mommy' - desde Profile Preference Screen
  final String? name; // desde Personal Details Screen
  final String?
  gender; // 'Hombre', 'Mujer', 'No binario' - desde Personal Details Screen
  final String?
  sexualOrientation; // 'Heterosexual', 'Homosexual', 'Lesbiana', 'Bisexual' - desde Personal Details Screen
  final List<String>?
  profilePhotos; // URLs de las fotos - desde Photo Upload Screen
  final String? phoneNumber; // desde Phone Number Screen
  final double? height; // en cm - desde Physical Characteristics Screen
  final String?
  complexion; // 'Delgado', 'Promedio', 'Musculoso', 'Gordito', 'Atlético' - desde Physical Characteristics Screen
  final String?
  appearance; // 'Muy atractivo', 'Atractivo', 'Promedio', 'Poco atractivo' - desde Physical Characteristics Screen
  final String?
  smokingHabit; // 'Sí', 'No' - desde Physical Characteristics Screen
  final String?
  drinkingHabit; // 'Sí', 'No', 'De vez en cuando' - desde Physical Characteristics Screen
  final List<String>?
  tastes; // ['Viajes', 'Música', 'Cine', 'Comida', 'Arte', 'Deportes'] - desde Physical Characteristics Screen
  final String? story; // biografía - desde Physical Characteristics Screen
  final String? seeking; // qué busca - desde Physical Characteristics Screen
  final DateTime createdAt;
  final DateTime updatedAt;

  UserProfile({
    required this.id,
    required this.email,
    this.userType,
    this.name,
    this.gender,
    this.sexualOrientation,
    this.profilePhotos,
    this.phoneNumber,
    this.height,
    this.complexion,
    this.appearance,
    this.smokingHabit,
    this.drinkingHabit,
    this.tastes,
    this.story,
    this.seeking,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserProfile.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserProfile(
      id: doc.id,
      email: data['email'] ?? '',
      userType: data['userType'],
      name: data['name'],
      gender: data['gender'],
      sexualOrientation: data['sexualOrientation'],
      profilePhotos:
          data['profilePhotos'] != null
              ? List<String>.from(data['profilePhotos'])
              : null,
      phoneNumber: data['phoneNumber'],
      height: data['height']?.toDouble(),
      complexion: data['complexion'],
      appearance: data['appearance'],
      smokingHabit: data['smokingHabit'],
      drinkingHabit: data['drinkingHabit'],
      tastes: data['tastes'] != null ? List<String>.from(data['tastes']) : null,
      story: data['story'],
      seeking: data['seeking'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'userType': userType,
      'name': name,
      'gender': gender,
      'sexualOrientation': sexualOrientation,
      'profilePhotos': profilePhotos,
      'phoneNumber': phoneNumber,
      'height': height,
      'complexion': complexion,
      'appearance': appearance,
      'smokingHabit': smokingHabit,
      'drinkingHabit': drinkingHabit,
      'tastes': tastes,
      'story': story,
      'seeking': seeking,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  UserProfile copyWith({
    String? id,
    String? email,
    String? userType,
    String? name,
    String? gender,
    String? sexualOrientation,
    List<String>? profilePhotos,
    String? phoneNumber,
    double? height,
    String? complexion,
    String? appearance,
    String? smokingHabit,
    String? drinkingHabit,
    List<String>? tastes,
    String? story,
    String? seeking,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      email: email ?? this.email,
      userType: userType ?? this.userType,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      sexualOrientation: sexualOrientation ?? this.sexualOrientation,
      profilePhotos: profilePhotos ?? this.profilePhotos,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      height: height ?? this.height,
      complexion: complexion ?? this.complexion,
      appearance: appearance ?? this.appearance,
      smokingHabit: smokingHabit ?? this.smokingHabit,
      drinkingHabit: drinkingHabit ?? this.drinkingHabit,
      tastes: tastes ?? this.tastes,
      story: story ?? this.story,
      seeking: seeking ?? this.seeking,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
