import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:newdaddys/services/firestore_service.dart';

mixin RegistrationScreenMixin<T extends StatefulWidget> on State<T> {
  bool _isLoading = false;
  final FirestoreService _firestore = FirestoreService();

  bool get isLoading => _isLoading;
  FirestoreService get firestore => _firestore;

  /// Muestra un diálogo de error
  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Error'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  /// Muestra un diálogo de éxito
  void showSuccessDialog(String message, {VoidCallback? onDismiss}) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Éxito'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  onDismiss?.call();
                },
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  /// Obtiene el usuario actual autenticado
  User? getCurrentUser() {
    return FirebaseAuth.instance.currentUser;
  }

  /// Valida que el usuario esté autenticado
  bool validateUserAuthentication() {
    final user = getCurrentUser();
    if (user == null) {
      showErrorDialog('Usuario no autenticado');
      return false;
    }
    return true;
  }

  /// Ejecuta una operación con loading state
  Future<void> executeWithLoading(Future<void> Function() operation) async {
    if (!validateUserAuthentication()) return;

    setState(() => _isLoading = true);

    try {
      await operation();
    } catch (e) {
      showErrorDialog('Error: ${e.toString()}');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  /// Navega a la siguiente pantalla
  void navigateToNext(String routeName) {
    if (mounted) {
      Navigator.pushNamed(context, routeName);
    }
  }

  /// Navega al menú principal y limpia el stack
  void navigateToMainMenu() {
    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/mainMenu', // Corregido según AppRoutes
        (route) => false,
      );
    }
  }

  /// Valida que un campo no esté vacío
  bool validateRequiredField(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      showErrorDialog('Por favor ingresa $fieldName');
      return false;
    }
    return true;
  }

  /// Valida que se haya seleccionado una opción
  bool validateRequiredSelection(String? value, String fieldName) {
    if (value == null) {
      showErrorDialog('Por favor selecciona $fieldName');
      return false;
    }
    return true;
  }

  /// Valida que se haya seleccionado al menos una opción de una lista
  bool validateRequiredList(List<String> values, String fieldName) {
    if (values.isEmpty) {
      showErrorDialog('Por favor selecciona al menos un $fieldName');
      return false;
    }
    return true;
  }
}
