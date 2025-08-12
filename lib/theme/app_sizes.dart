class AppSizes {
  AppSizes._(); // Constructor privado para que no se pueda instanciar

  // Alturas responsivas (basadas en el diseño de 3120px de alto)
  static const double buttonHeight = 0.07; // 220/3120 (igual que los inputs)
  static const double inputHeight = 0.07; // 220/3120
  static const double logoHeight = 0.064; // 200/3120

  // Espaciados fijos
  static const double spacingBetweenFields = 16.0;
  static const double spacingBetweenSections = 24.0;

  // Bordes y esquinas
  static const double borderRadius = 8.0;
  static const double borderWidth = 2.0;

  // Padding general de la pantalla
  static const double horizontalPadding = 0.05; // 5% del ancho
  static const double verticalPadding = 0.03; // 3% del alto
}
