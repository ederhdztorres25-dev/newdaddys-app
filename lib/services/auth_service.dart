import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Servicio de autenticación con Firebase Auth
class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Estado de autenticación real
  bool get isAuthenticated => _auth.currentUser != null;

  // Usuario actual
  User? get currentUser => _auth.currentUser;

  AuthService() {
    // Escuchar cambios en el estado de autenticación
    _auth.authStateChanges().listen((User? user) {
      notifyListeners();
    });
  }

  /// Registro con email y contraseña
  Future<AuthResult> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      print('AuthService: Iniciando registro con email: $email');
      final UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Enviar email de verificación
      await result.user?.sendEmailVerification();

      print('AuthService: Registro exitoso, email de verificación enviado');
      return AuthResult.success(
        message: 'Registro exitoso. Verifica tu email.',
      );
    } on FirebaseAuthException catch (e) {
      print('AuthService: Error en registro: ${e.code} - ${e.message}');
      String errorMessage = _getErrorMessage(e.code);
      return AuthResult.error(errorMessage);
    } catch (e) {
      print('AuthService: Error inesperado en registro: $e');
      return AuthResult.error('Error inesperado: $e');
    }
  }

  /// Login con email y contraseña
  Future<AuthResult> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      print('AuthService: Iniciando login con email: $email');
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      print('AuthService: Login exitoso');
      return AuthResult.success(message: 'Login exitoso');
    } on FirebaseAuthException catch (e) {
      print('AuthService: Error en login: ${e.code} - ${e.message}');
      String errorMessage = _getErrorMessage(e.code);
      return AuthResult.error(errorMessage);
    } catch (e) {
      print('AuthService: Error inesperado en login: $e');
      return AuthResult.error('Error inesperado: $e');
    }
  }

  /// Login con Google
  Future<AuthResult> signInWithGoogle() async {
    try {
      print('AuthService: Iniciando login con Google');

      // Inicializar Google Sign-In
      final GoogleSignIn googleSignIn = GoogleSignIn();

      // Verificar si el usuario ya está logueado con Google
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        print('AuthService: Usuario canceló el login con Google');
        return AuthResult.error('Login cancelado por el usuario');
      }

      // Obtener los detalles de autenticación
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Crear credenciales para Firebase
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Autenticar con Firebase
      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );

      print(
        'AuthService: Login con Google exitoso para: ${userCredential.user?.email}',
      );
      return AuthResult.success(message: 'Login con Google exitoso');
    } on FirebaseAuthException catch (e) {
      print(
        'AuthService: Error de Firebase en login con Google: ${e.code} - ${e.message}',
      );
      String errorMessage = _getErrorMessage(e.code);
      return AuthResult.error(errorMessage);
    } catch (e) {
      print('AuthService: Error inesperado en login con Google: $e');
      return AuthResult.error('Error en login con Google: $e');
    }
  }

  /// Verificar email
  Future<AuthResult> checkEmailVerification() async {
    try {
      await _auth.currentUser?.reload();
      final user = _auth.currentUser;

      if (user?.emailVerified == true) {
        return AuthResult.success(message: 'Email verificado');
      } else {
        return AuthResult.error('Email no verificado');
      }
    } catch (e) {
      return AuthResult.error('Error al verificar email: $e');
    }
  }

  /// Reenviar verificación de email
  Future<AuthResult> resendEmailVerification() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
      return AuthResult.success(message: 'Email de verificación reenviado');
    } catch (e) {
      return AuthResult.error('Error al reenviar email: $e');
    }
  }

  /// Cerrar sesión
  Future<void> signOut() async {
    try {
      print('AuthService: Iniciando cierre de sesión');

      // Cerrar sesión de Firebase
      await _auth.signOut();

      // Cerrar sesión de Google también
      final GoogleSignIn googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();

      print('AuthService: Cierre de sesión exitoso (Firebase + Google)');
    } catch (e) {
      print('AuthService: Error en cierre de sesión: $e');
    }
  }

  /// Eliminar cuenta
  Future<AuthResult> deleteAccount() async {
    try {
      await _auth.currentUser?.delete();
      return AuthResult.success(message: 'Cuenta eliminada');
    } catch (e) {
      return AuthResult.error('Error al eliminar cuenta: $e');
    }
  }

  /// Convertir códigos de error de Firebase a mensajes legibles
  String _getErrorMessage(String code) {
    switch (code) {
      case 'weak-password':
        return 'La contraseña es muy débil';
      case 'email-already-in-use':
        return 'Este email ya está registrado';
      case 'user-not-found':
        return 'No existe una cuenta con este email';
      case 'wrong-password':
        return 'Contraseña incorrecta';
      case 'invalid-email':
        return 'Email inválido';
      case 'user-disabled':
        return 'Esta cuenta ha sido deshabilitada';
      case 'too-many-requests':
        return 'Demasiados intentos. Intenta más tarde';
      case 'operation-not-allowed':
        return 'Operación no permitida';
      default:
        return 'Error de autenticación: $code';
    }
  }
}

/// Clase para manejar resultados de autenticación
class AuthResult {
  final bool isSuccess;
  final String message;

  AuthResult._(this.isSuccess, this.message);

  factory AuthResult.success({String? message}) {
    return AuthResult._(true, message ?? 'Operación exitosa');
  }

  factory AuthResult.error(String message) {
    return AuthResult._(false, message);
  }
}
