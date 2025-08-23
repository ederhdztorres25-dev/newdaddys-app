/// Constantes para las opciones de registro
class RegistrationOptions {
  // Opciones de tipo de usuario
  static const List<String> userTypes = ['baby', 'daddy/mommy'];
  static const List<String> userTypeLabels = [
    'Ser suggar baby',
    'Ser suggar daddy / suggar mommy',
  ];

  // Opciones de género
  static const List<String> genderOptions = ['Hombre', 'Mujer', 'No binario'];

  // Opciones de orientación sexual
  static const List<String> sexualOrientationOptions = [
    'Heterosexual',
    'Homosexual',
    'Lesbiana',
    'Bisexual',
  ];

  // Opciones de complexión
  static const List<String> complexionOptions = [
    'Delgado',
    'Promedio',
    'Musculoso',
    'Gordito',
    'Atlético',
  ];

  // Opciones de apariencia
  static const List<String> appearanceOptions = [
    'Muy atractivo',
    'Atractivo',
    'Promedio',
    'Poco atractivo',
  ];

  // Opciones de hábitos de bebida
  static const List<String> drinkingOptions = ['Sí', 'No', 'De vez en cuando'];

  // Opciones de gustos
  static const List<String> tastesOptions = [
    'Viajes',
    'Música',
    'Cine',
    'Comida',
    'Arte',
    'Deportes',
  ];

  // Configuración de altura
  static const double minHeight = 140.0;
  static const double maxHeight = 220.0;
  static const double defaultHeight = 170.0;
  static const int heightDivisions = 80;

  // Configuración de fotos
  static const int maxPhotos = 6;

  // Configuración de texto
  static const int maxStoryLength = 500;
  static const int maxSeekingLength = 500;

  // Mensajes de validación
  static const Map<String, String> validationMessages = {
    'name': 'Por favor ingresa tu nombre',
    'gender': 'Por favor selecciona tu género',
    'sexualOrientation': 'Por favor selecciona tu orientación sexual',
    'phoneNumber': 'Por favor ingresa tu número de teléfono',
    'complexion': 'Por favor selecciona tu complexión',
    'appearance': 'Por favor selecciona tu apariencia',
    'smokingHabit': 'Por favor indica si fumas',
    'drinkingHabit': 'Por favor indica si bebes alcohol',
    'tastes': 'Por favor selecciona al menos un gusto',
    'userType': 'Por favor selecciona qué estás buscando',
  };

  // Mensajes de éxito
  static const Map<String, String> successMessages = {
    'profilePreference': 'Preferencia guardada exitosamente',
    'personalDetails': 'Datos personales guardados exitosamente',
    'photos': 'Fotos guardadas exitosamente',
    'phoneNumber': 'Número de teléfono guardado exitosamente',
    'physicalCharacteristics': 'Características físicas guardadas exitosamente',
  };
}
