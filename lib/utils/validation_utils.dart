/// Utilidades de validación centralizadas
class ValidationUtils {
  // Constructor privado para evitar instanciación
  ValidationUtils._();

  /// Valida si un email tiene formato correcto
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  /// Valida si una contraseña cumple con los requisitos mínimos
  static bool isValidPassword(String password) {
    return password.length >= 6;
  }

  /// Valida si un número de teléfono tiene formato correcto
  static bool isValidPhoneNumber(String phone) {
    // Formato básico: +XX XXX XXX XXXX o XXX XXX XXXX
    final phoneRegex = RegExp(r'^(\+\d{1,3}[- ]?)?\d{3}[- ]?\d{3}[- ]?\d{4}$');
    return phoneRegex.hasMatch(phone);
  }

  /// Valida si una lista de fotos cumple con los requisitos
  static bool isValidPhotoList(List<String> photos) {
    return photos.isNotEmpty && photos.length <= 6;
  }

  /// Valida si un campo requerido no está vacío
  static bool isNotEmpty(String? value) {
    return value != null && value.trim().isNotEmpty;
  }

  /// Valida si un valor numérico está en un rango válido
  static bool isInRange(double value, double min, double max) {
    return value >= min && value <= max;
  }

  /// Obtiene mensaje de error para campo requerido
  static String getRequiredFieldMessage(String fieldName) {
    return 'El campo $fieldName es obligatorio';
  }

  /// Obtiene mensaje de error para email inválido
  static String getInvalidEmailMessage() {
    return 'Por favor ingresa un email válido';
  }

  /// Obtiene mensaje de error para contraseña débil
  static String getWeakPasswordMessage() {
    return 'La contraseña debe tener al menos 6 caracteres';
  }

  /// Obtiene mensaje de error para teléfono inválido
  static String getInvalidPhoneMessage() {
    return 'Por favor ingresa un número de teléfono válido';
  }
}
