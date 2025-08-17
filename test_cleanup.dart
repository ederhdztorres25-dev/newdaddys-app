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

  await testCleanup();
}

Future<void> testCleanup() async {
  final auth = FirebaseAuth.instance;
  final firestore = FirestoreService();

  const email = 'ederhdztorres25_test@outlook.com';
  const password = 'Test123456!';

  try {
    print('\n🧹 Iniciando limpieza de datos de prueba...');
    print('📧 Email: $email');

    // Intentar hacer login para obtener el usuario
    try {
      final userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        final userId = userCredential.user!.uid;
        print('🆔 User ID encontrado: $userId');

        // Borrar perfil de Firestore
        await firestore.deleteUserProfile(userId);
        print('✅ Perfil eliminado de Firestore');

        // Borrar usuario de Authentication
        await userCredential.user!.delete();
        print('✅ Usuario eliminado de Authentication');

        print('\n🎉 ¡Limpieza completada exitosamente!');
        print('📱 Ahora puedes probar el registro desde la UI');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('ℹ️ Usuario no encontrado en Authentication');

        // Intentar borrar solo el documento de Firestore
        const userId = 'RYsn5xOVWHUGLb4Ou9IYj4bRwRw2';
        try {
          await firestore.deleteUserProfile(userId);
          print('✅ Perfil eliminado de Firestore');
        } catch (e) {
          print('ℹ️ Perfil no encontrado en Firestore');
        }
      } else {
        print('❌ Error de autenticación: ${e.code}');
      }
    }
  } catch (e) {
    print('\n❌ Error en la limpieza: $e');
  }
}
