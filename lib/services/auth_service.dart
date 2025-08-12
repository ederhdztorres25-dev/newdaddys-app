import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Resultado de una operación de autenticación
class AuthResult {
  final bool isSuccess;
  final String message;

  const AuthResult._(this.isSuccess, this.message);

  factory AuthResult.success({String? message}) {
    return AuthResult._(true, message ?? 'Operación exitosa');
  }

  factory AuthResult.error(String message) {
    return AuthResult._(false, message);
  }
}

/// Servicio de autenticación con Firebase Auth
/// Maneja login, registro, cierre de sesión y estado de autenticación
class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // ==================== GETTERS ====================

  /// Verifica si el usuario está autenticado
  bool get isAuthenticated => _auth.currentUser != null;

  /// Obtiene el usuario actual
  User? get currentUser => _auth.currentUser;

  /// Obtiene el email del usuario actual
  String? get userEmail => _auth.currentUser?.email;

  // ==================== CONSTRUCTOR ====================

  AuthService() {
    _setupAuthStateListener();
  }

  // ==================== CONFIGURACIÓN ====================

  /// Configura el listener para cambios en el estado de autenticación
  void _setupAuthStateListener() {
    _auth.authStateChanges().listen((User? user) {
      notifyListeners();
    });
  }

  // ==================== REGISTRO ====================

  /// Registra un nuevo usuario con email y contraseña
  Future<AuthResult> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      _log('Iniciando registro con email: $email');

      final UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Enviar email de verificación automáticamente
      await result.user?.sendEmailVerification();

      _log('Registro exitoso, email de verificación enviado');
      return AuthResult.success(
        message: 'Registro exitoso. Verifica tu email.',
      );
    } on FirebaseAuthException catch (e) {
      _log('Error en registro: ${e.code} - ${e.message}');
      return AuthResult.error(_getErrorMessage(e.code));
    } catch (e) {
      _log('Error inesperado en registro: $e');
      return AuthResult.error('Error inesperado: $e');
    }
  }

  // ==================== LOGIN ====================

  /// Inicia sesión con email y contraseña
  Future<AuthResult> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      _log('Iniciando login con email: $email');

      await _auth.signInWithEmailAndPassword(email: email, password: password);

      _log('Login exitoso');
      return AuthResult.success(message: 'Login exitoso');
    } on FirebaseAuthException catch (e) {
      _log('Error en login: ${e.code} - ${e.message}');
      return AuthResult.error(_getErrorMessage(e.code));
    } catch (e) {
      _log('Error inesperado en login: $e');
      return AuthResult.error('Error inesperado: $e');
    }
  }

  /// Inicia sesión con Google
  Future<AuthResult> signInWithGoogle() async {
    try {
      _log('Iniciando login con Google');

      // Obtener cuenta de Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        _log('Usuario canceló el login con Google');
        return AuthResult.error('Login cancelado por el usuario');
      }

      // Obtener credenciales de Google
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

      _log('Login con Google exitoso para: ${userCredential.user?.email}');
      return AuthResult.success(message: 'Login con Google exitoso');
    } on FirebaseAuthException catch (e) {
      _log('Error de Firebase en login con Google: ${e.code} - ${e.message}');
      return AuthResult.error(_getErrorMessage(e.code));
    } catch (e) {
      _log('Error inesperado en login con Google: $e');
      return AuthResult.error('Error en login con Google: $e');
    }
  }

  // ==================== VERIFICACIÓN DE EMAIL ====================

  /// Verifica si el email del usuario actual está verificado
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

  /// Reenvía el email de verificación
  Future<AuthResult> resendEmailVerification() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
      return AuthResult.success(message: 'Email de verificación reenviado');
    } catch (e) {
      return AuthResult.error('Error al reenviar email: $e');
    }
  }

  // ==================== CERRAR SESIÓN ====================

  /// Cierra la sesión del usuario (Firebase + Google)
  Future<void> signOut() async {
    try {
      _log('Iniciando cierre de sesión');

      // Cerrar sesión de Firebase
      await _auth.signOut();

      // Cerrar sesión de Google también
      await _googleSignIn.signOut();

      _log('Cierre de sesión exitoso (Firebase + Google)');
    } catch (e) {
      _log('Error en cierre de sesión: $e');
    }
  }

  // ==================== ELIMINAR CUENTA ====================

  /// Elimina la cuenta del usuario actual
  Future<AuthResult> deleteAccount() async {
    try {
      await _auth.currentUser?.delete();
      return AuthResult.success(message: 'Cuenta eliminada');
    } catch (e) {
      return AuthResult.error('Error al eliminar cuenta: $e');
    }
  }

  // ==================== UTILIDADES ====================

  /// Convierte códigos de error de Firebase a mensajes legibles
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

  /// Log para debugging (solo en modo debug)
  void _log(String message) {
    if (kDebugMode) {
      print('AuthService: $message');
    }
  }
}
