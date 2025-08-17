import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:newdaddys/firebase_options.dart';
import 'package:newdaddys/services/firestore_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('✅ Firebase inicializado correctamente');
  } catch (e) {
    print('⚠️ Firebase ya inicializado: $e');
  }

  await testProfileUpdate();
}

Future<void> testProfileUpdate() async {
  final firestore = FirestoreService();

  // ID del usuario que creamos en la prueba anterior
  const userId = 'RYsn5xOVWHUGLb4Ou9IYj4bRwRw2';

  try {
    print('\n🚀 Iniciando actualización de perfil de prueba...');
    print('🆔 User ID: $userId');

    // Datos de prueba basados en la UI
    await firestore.updateProfilePreference(userId: userId, userType: 'baby');
    print('✅ Preferencia de perfil actualizada: baby');

    await firestore.updatePersonalDetails(
      userId: userId,
      name: 'Eder Test',
      gender: 'Hombre',
      sexualOrientation: 'Heterosexual',
    );
    print('✅ Datos personales actualizados');

    await firestore.updatePhoneNumber(
      userId: userId,
      phoneNumber: '+52 555 123 4567',
    );
    print('✅ Número de teléfono actualizado');

    await firestore.updatePhysicalCharacteristics(
      userId: userId,
      height: 175.0,
      complexion: 'Atlético',
      appearance: 'Muy atractivo',
      smokingHabit: 'No',
      drinkingHabit: 'De vez en cuando',
      tastes: ['Viajes', 'Música', 'Deportes'],
      story:
          'Soy una persona aventurera que disfruta viajar y conocer nuevas culturas. Me encanta la música y mantenerme activo con deportes.',
      seeking:
          'Busco una relación significativa con alguien que comparta mis valores y pasiones por la vida.',
    );
    print('✅ Características físicas actualizadas');

    // Verificar el perfil actualizado
    final profile = await firestore.getUserProfile(userId);
    if (profile != null) {
      print('\n📋 Perfil actualizado:');
      print('   - ID: ${profile.id}');
      print('   - Email: ${profile.email}');
      print('   - Tipo: ${profile.userType}');
      print('   - Nombre: ${profile.name}');
      print('   - Género: ${profile.gender}');
      print('   - Orientación: ${profile.sexualOrientation}');
      print('   - Teléfono: ${profile.phoneNumber}');
      print('   - Altura: ${profile.height} cm');
      print('   - Complexión: ${profile.complexion}');
      print('   - Apariencia: ${profile.appearance}');
      print('   - Fuma: ${profile.smokingHabit}');
      print('   - Bebe: ${profile.drinkingHabit}');
      print('   - Gustos: ${profile.tastes}');
      print('   - Historia: ${profile.story}');
      print('   - Busca: ${profile.seeking}');
      print('   - Actualizado: ${profile.updatedAt}');
    }

    print('\n🎉 ¡Actualización de perfil completada exitosamente!');
    print('📱 Revisa Firebase Console para ver los datos actualizados');
  } catch (e) {
    print('\n❌ Error en la actualización: $e');
  }
}
