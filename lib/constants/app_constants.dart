/// Constantes centralizadas de la aplicación
class AppConstants {
  // Constructor privado para evitar instanciación
  AppConstants._();

  // ==================== FIREBASE ====================
  static const String userProfilesCollection = 'user_profiles';
  static const String profilePhotosPath = 'profile_photos';
  static const String photoFileName = 'photo_';
  static const String photoExtension = '.jpg';

  // ==================== IMAGENES ====================
  static const int maxImageWidth = 1920;
  static const int maxImageHeight = 1920;
  static const int imageQuality = 90;
  static const int cropQuality = 85;
  static const int maxCropWidth = 1080;
  static const int maxCropHeight = 1350;
  static const double cropAspectRatioX = 4.0;
  static const double cropAspectRatioY = 5.0;

  // ==================== UI ====================
  static const int snackBarDuration = 5;
  static const int loadingTimeout = 30; // segundos

  // ==================== VALIDACIONES ====================
  static const int minPasswordLength = 6;
  static const int maxPhotos = 6;
  static const int minPhotos = 1;

  // ==================== MENSAJES ====================
  static const String genericError = 'Ha ocurrido un error inesperado';
  static const String networkError = 'Error de conexión. Verifica tu internet';
  static const String permissionDenied = 'Permiso denegado';
  static const String operationCancelled = 'Operación cancelada';
}
