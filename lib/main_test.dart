import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:newdaddys/firebase_options.dart';

// Página de prueba ultra simple
class TestScreen extends StatelessWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: const Center(
        child: Text(
          '¡APP FUNCIONANDO!',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

void main() async {
  print('🚀 Iniciando aplicación de prueba...');

  try {
    WidgetsFlutterBinding.ensureInitialized();
    print('✅ WidgetsFlutterBinding inicializado');

    print('🔍 Verificando Firebase apps antes: ${Firebase.apps.length}');

    // Intentar obtener la app existente primero
    try {
      final existingApp = Firebase.app();
      print('🔍 App existente encontrada: ${existingApp.name}');
    } catch (e) {
      print('🔍 No hay app existente: $e');
    }

    // Inicializar Firebase con la configuración corregida
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('✅ Firebase inicializado correctamente');

    print('🔍 Verificando Firebase apps después: ${Firebase.apps.length}');
  } catch (e) {
    print('❌ Error al inicializar Firebase: $e');
    print('🔍 Tipo de error: ${e.runtimeType}');
    print('🔍 Mensaje: ${e.toString()}');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const TestScreen(),
    );
  }
}
