import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:newdaddys/services/firestore_service.dart';
import 'package:newdaddys/utils/logger.dart';
import 'package:newdaddys/utils/validation_utils.dart';

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
  final FirestoreService _firestore = FirestoreService();

  // ==================== GETTERS ====================

  /// Verifica si el usuario está autenticado
  bool get isAuthenticated => _auth.currentUser != null;

  /// Obtiene el usuario actual
  User? get currentUser => _auth.currentUser;

  /// Obtiene el email del usuario actual
  String? get userEmail => _auth.currentUser?.email;

  /// Verifica si el perfil del usuario está completo
  Future<bool> isProfileComplete() async {
    if (!isAuthenticated) return false;
    return await _firestore.isProfileComplete(_auth.currentUser!.uid);
  }

  // ==================== CONSTRUCTOR ====================

  AuthService() {
    _setupAuthStateListener();
  }

  // ==================== CONFIGURACIÓN ====================

  /// Configura el listener para cambios en el estado de autenticación
  void _setupAuthStateListener() {
    _auth.authStateChanges().listen((User? user) {
      Logger.debug('Estado de autenticación cambiado: ${user?.email ?? 'No autenticado'}', tag: 'AuthService');
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
      Logger.process('Iniciando registro con email: $email', tag: 'AuthService');

      // Validar email
      if (!ValidationUtils.isValidEmail(email)) {
        return AuthResult.error(ValidationUtils.getInvalidEmailMessage());
      }

      // Validar contraseña
      if (!ValidationUtils.isValidPassword(password)) {
        return AuthResult.error(ValidationUtils.getWeakPasswordMessage());
      }

      final UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Enviar email de verificación automáticamente
      await result.user?.sendEmailVerification();

      // NO crear perfil automáticamente - el usuario debe completar el proceso de registro
      // El perfil se creará en la primera pantalla del proceso de registro

      Logger.success('Registro exitoso, email de verificación enviado', tag: 'AuthService');
      return AuthResult.success(
        message: 'Registro exitoso. Verifica tu email y completa tu perfil.',
      );
    } on FirebaseAuthException catch (e) {
      Logger.error('Error en registro: ${e.code}', tag: 'AuthService', error: e.message);
      return AuthResult.error(_getErrorMessage(e.code));
    } catch (e) {
      Logger.error('Error inesperado en registro', tag: 'AuthService', error: e);
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
      Logger.process('Iniciando login con email: $email', tag: 'AuthService');

      // Validar email
      if (!ValidationUtils.isValidEmail(email)) {
        return AuthResult.error(ValidationUtils.getInvalidEmailMessage());
      }

      await _auth.signInWithEmailAndPassword(email: email, password: password);

      Logger.success('Login exitoso', tag: 'AuthService');
      return AuthResult.success(message: 'Login exitoso');
    } on FirebaseAuthException catch (e) {
      Logger.error('Error en login: ${e.code}', tag: 'AuthService', error: e.message);
      return AuthResult.error(_getErrorMessage(e.code));
    } catch (e) {
      Logger.error('Error inesperado en login', tag: 'AuthService', error: e);
      return AuthResult.error('Error inesperado: $e');
    }
  }

  /// Inicia sesión con Google
  Future<AuthResult> signInWithGoogle() async {
    try {
      Logger.process('Iniciando login con Google', tag: 'AuthService');

      // Obtener cuenta de Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        Logger.info('Usuario canceló el login con Google', tag: 'AuthService');
        return AuthResult.error('Login cancelado por el usuario');
      }

      // Obtener credenciales de Google
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Crear credenciales para Firebase
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Autenticar con Firebase
      final UserCredential userCredential = await _auth.signInWithCredential(credential);

      // NO crear perfil automáticamente - el usuario debe completar el proceso de registro
      // El perfil se creará en la primera pantalla del proceso de registro

      Logger.success('Login con Google exitoso para: ${userCredential.user?.email}', tag: 'AuthService');
      return AuthResult.success(message: 'Login con Google exitoso');
    } on FirebaseAuthException catch (e) {
      Logger.error('Error de Firebase en login con Google: ${e.code}', tag: 'AuthService', error: e.message);
      return AuthResult.error(_getErrorMessage(e.code));
    } catch (e) {
      Logger.error('Error inesperado en login con Google', tag: 'AuthService', error: e);
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
        Logger.success('Email verificado', tag: 'AuthService');
        return AuthResult.success(message: 'Email verificado');
      } else {
        Logger.warning('Email no verificado', tag: 'AuthService');
        return AuthResult.error('Email no verificado');
      }
    } catch (e) {
      Logger.error('Error al verificar email', tag: 'AuthService', error: e);
      return AuthResult.error('Error al verificar email: $e');
    }
  }

  /// Reenvía el email de verificación
  Future<AuthResult> resendEmailVerification() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
      Logger.success('Email de verificación reenviado', tag: 'AuthService');
      return AuthResult.success(message: 'Email de verificación reenviado');
    } catch (e) {
      Logger.error('Error al reenviar email', tag: 'AuthService', error: e);
      return AuthResult.error('Error al reenviar email: $e');
    }
  }

  // ==================== CERRAR SESIÓN ====================

  /// Cierra la sesión del usuario (Firebase + Google)
  Future<void> signOut() async {
    try {
      Logger.process('Iniciando cierre de sesión', tag: 'AuthService');

      // Cerrar sesión de Firebase
      await _auth.signOut();

      // Cerrar sesión de Google también
      await _googleSignIn.signOut();

      Logger.success('Cierre de sesión exitoso (Firebase + Google)', tag: 'AuthService');
    } catch (e) {
      Logger.error('Error en cierre de sesión', tag: 'AuthService', error: e);
    }
  }

  // ==================== ELIMINAR CUENTA ====================

  /// Elimina la cuenta del usuario actual
  Future<AuthResult> deleteAccount() async {
    try {
      await _auth.currentUser?.delete();
      Logger.success('Cuenta eliminada', tag: 'AuthService');
      return AuthResult.success(message: 'Cuenta eliminada');
    } catch (e) {
      Logger.error('Error al eliminar cuenta', tag: 'AuthService', error: e);
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
}
