import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  await testUserRegistration();
}

Future<void> testUserRegistration() async {
  final auth = FirebaseAuth.instance;
  final firestore = FirestoreService();

  const email = 'ederhdztorres25_test@outlook.com';
  const password = 'Test123456!';

  try {
    print('\n🚀 Iniciando registro de prueba...');
    print('📧 Email: $email');
    print('🔒 Contraseña: $password');

    // Crear usuario
    final userCredential = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    print('✅ Usuario creado exitosamente');
    print('🆔 User ID: ${userCredential.user?.uid}');
    print('📧 Email: ${userCredential.user?.email}');

    // Enviar email de verificación
    await userCredential.user?.sendEmailVerification();
    print('📬 Email de verificación enviado');

    // Crear perfil en Firestore
    if (userCredential.user != null) {
      final exists = await firestore.profileExists(userCredential.user!.uid);
      print('🔍 Perfil existe: $exists');

      if (!exists) {
        await firestore.createUserProfile(
          userId: userCredential.user!.uid,
          email: email,
        );
        print('✅ Perfil creado en Firestore');
      } else {
        print('ℹ️ Perfil ya existe en Firestore');
      }

      // Verificar que el perfil se creó correctamente
      final profile = await firestore.getUserProfile(userCredential.user!.uid);
      if (profile != null) {
        print('📋 Perfil recuperado:');
        print('   - ID: ${profile.id}');
        print('   - Email: ${profile.email}');
        print('   - Creado: ${profile.createdAt}');
        print('   - Actualizado: ${profile.updatedAt}');
      } else {
        print('❌ Error: No se pudo recuperar el perfil');
      }
    }

    print('\n🎉 ¡Registro de prueba completado exitosamente!');
    print('📱 Revisa Firebase Console para verificar los datos');
  } catch (e) {
    print('\n❌ Error en el registro: $e');

    if (e is FirebaseAuthException) {
      print('🔍 Código de error: ${e.code}');
      print('📝 Mensaje: ${e.message}');
    }
  }
}
