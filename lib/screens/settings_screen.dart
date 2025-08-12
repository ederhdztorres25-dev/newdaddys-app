import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:newdaddys/services/auth_service.dart';
import 'package:newdaddys/theme/app_colors.dart';
import 'package:newdaddys/theme/app_fonts.dart';
import 'package:newdaddys/widgets/app_bottom_nav_bar.dart';
import 'package:newdaddys/routes/app_routes.dart';
import 'package:flutter/cupertino.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Ajustes',
          style: AppFonts.h2.copyWith(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Sección CUENTA
              _buildSectionHeader('CUENTA'),
              const SizedBox(height: 16),
              _SettingsListItem(
                icon: Icons.workspace_premium_outlined,
                title: 'Estado de la suscripción',
                subtitle: '¡Mejora a premium!',
                subtitleColor: AppColors.gold,
                trailing: const Icon(Icons.chevron_right, color: Colors.white),
                onTap: () {},
              ),

              const SizedBox(height: 32),

              // Sección PREFERENCIAS
              _buildSectionHeader('PREFERENCIAS'),
              const SizedBox(height: 16),
              _SettingsListItem(
                icon: Icons.notifications_outlined,
                title: 'Notificaciones',
                trailing: const _NotificationToggle(),
                onTap: () {},
              ),
              const SizedBox(height: 16),
              _SettingsListItem(
                icon: Icons.language_outlined,
                title: 'Idioma',
                trailing: _LanguageTrailing(),
                onTap: () {},
              ),

              const SizedBox(height: 32),

              // Sección SOPORTE
              _buildSectionHeader('SOPORTE'),
              const SizedBox(height: 16),
              _SettingsListItem(
                icon: Icons.help_outline,
                title: 'Centro de ayuda',
                trailing: const Icon(Icons.chevron_right, color: Colors.white),
                onTap: () {},
              ),
              const SizedBox(height: 16),
              _SettingsListItem(
                icon: Icons.article_outlined,
                title: 'Términos y condiciones',
                trailing: const Icon(Icons.chevron_right, color: Colors.white),
                onTap: () {},
              ),

              const SizedBox(height: 32),

              // Sección SESIÓN
              _buildSectionHeader('SESIÓN'),
              const SizedBox(height: 16),
              _SessionButton(
                text: 'Cerrar sesión',
                textColor: Colors.white,
                onTap: () async {
                  try {
                    final authService = Provider.of<AuthService>(
                      context,
                      listen: false,
                    );
                    await authService.signOut();
                    if (context.mounted) {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/',
                        (route) => false,
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Error al cerrar sesión: ${e.toString()}',
                          ),
                          backgroundColor: AppColors.danger,
                        ),
                      );
                    }
                  }
                },
              ),
              const SizedBox(height: 16),
              _SessionButton(
                text: 'Borrar mi cuenta',
                textColor: AppColors.danger,
                onTap: () {
                  _showDeleteAccountDialog(context);
                },
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNavBar(selectedIndex: 3),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: AppFonts.bodySmall.copyWith(
        color: AppColors.placeholderText,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: AppColors.primary,
            title: Text(
              'Eliminar cuenta',
              style: AppFonts.h3.copyWith(color: Colors.white),
            ),
            content: Text(
              '¿Estás seguro de que quieres eliminar tu cuenta? Esta acción no se puede deshacer.',
              style: AppFonts.bodyMedium.copyWith(color: Colors.white),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancelar',
                  style: AppFonts.bodyMedium.copyWith(color: Colors.white),
                ),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);

                  try {
                    final authService = Provider.of<AuthService>(
                      context,
                      listen: false,
                    );
                    final result = await authService.deleteAccount();

                    if (context.mounted) {
                      if (result.isSuccess) {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          AppRoutes.login,
                          (route) => false,
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(result.message),
                            backgroundColor: AppColors.danger,
                          ),
                        );
                      }
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error inesperado: ${e.toString()}'),
                          backgroundColor: AppColors.danger,
                        ),
                      );
                    }
                  }
                },
                child: Text(
                  'Eliminar',
                  style: AppFonts.bodyMedium.copyWith(color: AppColors.danger),
                ),
              ),
            ],
          ),
    );
  }
}

// Widget para elementos de lista de configuración
class _SettingsListItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Color? subtitleColor;
  final Widget trailing;
  final VoidCallback onTap;

  const _SettingsListItem({
    required this.icon,
    required this.title,
    this.subtitle,
    this.subtitleColor,
    required this.trailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            // Icono con contenedor circular
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.highlight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 16),
            // Contenido
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppFonts.bodyMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: AppFonts.bodySmall.copyWith(
                        color: subtitleColor ?? AppColors.placeholderText,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}

// Botones para la sección de sesión
class _SessionButton extends StatelessWidget {
  final String text;
  final Color textColor;
  final VoidCallback onTap;

  const _SessionButton({
    required this.text,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            text,
            style: AppFonts.bodyMedium.copyWith(
              color: textColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

// Toggle mejorado para notificaciones
class _NotificationToggle extends StatefulWidget {
  const _NotificationToggle();

  @override
  State<_NotificationToggle> createState() => _NotificationToggleState();
}

class _NotificationToggleState extends State<_NotificationToggle> {
  bool isEnabled = true;

  @override
  Widget build(BuildContext context) {
    return CupertinoSwitch(
      value: isEnabled,
      onChanged: (value) {
        setState(() {
          isEnabled = value;
        });
      },
      activeColor: AppColors.gold,
      trackColor: AppColors.highlight,
    );
  }
}

// Widget para el selector de idioma
class _LanguageTrailing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Español',
          style: AppFonts.bodyMedium.copyWith(
            color: AppColors.placeholderText,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 8),
        const Icon(Icons.chevron_right, color: Colors.white, size: 20),
      ],
    );
  }
}
