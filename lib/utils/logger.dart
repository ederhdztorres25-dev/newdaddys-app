import 'package:flutter/foundation.dart';

/// Sistema de logging centralizado para la aplicación
class Logger {
  // Constructor privado para evitar instanciación
  Logger._();

  /// Log de información (solo en debug)
  static void info(String message, {String? tag}) {
    if (kDebugMode) {
      final tagText = tag != null ? '[$tag]' : '';
      print('ℹ️ $tagText $message');
    }
  }

  /// Log de éxito (solo en debug)
  static void success(String message, {String? tag}) {
    if (kDebugMode) {
      final tagText = tag != null ? '[$tag]' : '';
      print('✅ $tagText $message');
    }
  }

  /// Log de advertencia (solo en debug)
  static void warning(String message, {String? tag}) {
    if (kDebugMode) {
      final tagText = tag != null ? '[$tag]' : '';
      print('⚠️ $tagText $message');
    }
  }

  /// Log de error (solo en debug)
  static void error(String message, {String? tag, Object? error}) {
    if (kDebugMode) {
      final tagText = tag != null ? '[$tag]' : '';
      final errorText = error != null ? ' - Error: $error' : '';
      print('❌ $tagText $message$errorText');
    }
  }

  /// Log de debug (solo en debug)
  static void debug(String message, {String? tag}) {
    if (kDebugMode) {
      final tagText = tag != null ? '[$tag]' : '';
      print('🔍 $tagText $message');
    }
  }

  /// Log de proceso (solo en debug)
  static void process(String message, {String? tag}) {
    if (kDebugMode) {
      final tagText = tag != null ? '[$tag]' : '';
      print('⚙️ $tagText $message');
    }
  }
}
