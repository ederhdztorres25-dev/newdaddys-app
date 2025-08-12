import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:newdaddys/theme/app_colors.dart';
import 'package:newdaddys/theme/app_fonts.dart';
import 'package:newdaddys/widgets/custom_bottom_nav_bar.dart';
import 'package:newdaddys/screens/main_menu_screen.dart';
import 'package:newdaddys/screens/babys_screen.dart';
import 'package:newdaddys/widgets/app_bottom_nav_bar.dart';
import 'package:newdaddys/screens/premium_subscription_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // Funciones para medidas proporcionales
    double w(double px) => px * size.width / 1440;
    double h(double px) => px * size.height / 3120;

    // Constantes de diseño (proporcionales a Figma)
    const double figmaProfilePic = 367;
    const double figmaBoxWidth = 1320;
    const double figmaBoxHeight = 245;
    const double figmaEditBtnHeight = 190;
    const double figmaBoxRadius = 32;
    const double figmaBoxSpacing = 40;
    const double figmaIconInfo = 115;
    const double figmaPremiumHeight = 340;
    const double figmaPremiumRadius = 40;
    const double figmaPremiumIcon = 80;
    const double figmaPremiumStar = 50;

    // Medidas responsivas
    final double profilePicSize = w(figmaProfilePic);
    final double boxWidth = w(figmaBoxWidth);
    final double boxHeight = h(figmaBoxHeight);
    final double editBtnHeight = h(figmaEditBtnHeight);
    final double boxRadius = w(figmaBoxRadius);
    final double boxSpacing = h(figmaBoxSpacing);
    final double iconInfoSize = w(figmaIconInfo);
    final double premiumHeight = h(figmaPremiumHeight);
    final double premiumRadius = w(figmaPremiumRadius);
    final double premiumIcon = w(figmaPremiumIcon);
    final double premiumStar = w(figmaPremiumStar);

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('Perfil', style: AppFonts.h2),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: w(60)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: h(60)),
                // Foto de perfil
                CircleAvatar(
                  radius: profilePicSize / 2,
                  backgroundImage: const AssetImage('assets/images/juan.png'),
                ),
                SizedBox(height: h(40)),
                // Nombre
                Text('Eduardo Hernández',
                    style: AppFonts.h2, textAlign: TextAlign.center),
                SizedBox(height: h(40)),
                // Botón Editar mi perfil
                _ProfileEditButton(
                  width: boxWidth,
                  height: editBtnHeight,
                  radius: boxRadius,
                  text: 'Editar mi perfil',
                  onTap: () {},
                ),
                SizedBox(height: boxSpacing),
                // Tarjeta premium
                _PremiumBox(
                  width: boxWidth,
                  radius: premiumRadius,
                  iconSize: premiumIcon,
                  starSize: premiumStar,
                ),
                SizedBox(height: boxSpacing),
                // Botones de info
                _ProfileInfoList(
                  boxWidth: boxWidth,
                  boxHeight: boxHeight,
                  boxRadius: boxRadius,
                  iconSize: iconInfoSize,
                  boxSpacing: boxSpacing,
                ),
                SizedBox(height: boxSpacing),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: AppBottomNavBar(selectedIndex: 2),
    );
  }
}

// Botón grande para editar perfil
class _ProfileEditButton extends StatelessWidget {
  final double width;
  final double height;
  final double radius;
  final String text;
  final VoidCallback onTap;
  const _ProfileEditButton({
    required this.width,
    required this.height,
    required this.radius,
    required this.text,
    required this.onTap,
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(color: AppColors.secondary, width: 1),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: AppFonts.bodyMedium.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

// Tarjeta premium con degradado naranja
class _PremiumBox extends StatelessWidget {
  final double width;
  final double radius;
  final double iconSize;
  final double starSize;
  const _PremiumBox({
    required this.width,
    required this.radius,
    required this.iconSize,
    required this.starSize,
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const PremiumSubscriptionScreen()),
        );
      },
      child: Container(
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFDA7806), Color(0xFFF49C0B)],
          ),
        ),
        padding: EdgeInsets.symmetric(
            horizontal: radius * 1.5, vertical: radius * 1.5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/icons/crown.svg',
                    width: iconSize, height: iconSize),
                SizedBox(width: radius * 0.7),
                Expanded(
                  child: Text(
                    '¡Mejora tu experiencia!',
                    style: AppFonts.bodyMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: radius * 0.7),
            Text(
              'Desbloquea funciones premium y conoce más personas',
              style: AppFonts.bodySmall.copyWith(color: Colors.white),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: radius * 0.7),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/icons/star.svg',
                    width: starSize, height: starSize, color: Colors.white),
                SizedBox(width: radius * 0.7),
                Expanded(
                  child: Text(
                    'Mensajes ilimitados',
                    style: AppFonts.bodySmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: radius * 0.5),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/icons/star.svg',
                    width: starSize, height: starSize, color: Colors.white),
                SizedBox(width: radius * 0.7),
                Expanded(
                  child: Text(
                    'Perfil destacado',
                    style: AppFonts.bodySmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Lista de botones de info
class _ProfileInfoList extends StatelessWidget {
  final double boxWidth;
  final double boxHeight;
  final double boxRadius;
  final double iconSize;
  final double boxSpacing;
  const _ProfileInfoList({
    required this.boxWidth,
    required this.boxHeight,
    required this.boxRadius,
    required this.iconSize,
    required this.boxSpacing,
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ProfileInfoButton(
          width: boxWidth,
          height: boxHeight,
          radius: boxRadius,
          icon: 'assets/images/chat.png',
          iconSize: iconSize,
          title: 'Reseñas',
          trailing: const Icon(Icons.chevron_right, color: Colors.white),
        ),
        SizedBox(height: boxSpacing),
        _ProfileInfoButton(
          width: boxWidth,
          height: boxHeight,
          radius: boxRadius,
          icon: 'assets/images/phone.png',
          iconSize: iconSize,
          title: 'Teléfono',
          trailing: Text(
            '+52 999 242 6465',
            style: AppFonts.bodyMedium.copyWith(color: Colors.white),
          ),
        ),
        SizedBox(height: boxSpacing),
        _ProfileInfoButton(
          width: boxWidth,
          height: boxHeight,
          radius: boxRadius,
          icon: 'assets/images/mail.png',
          iconSize: iconSize,
          title: 'Correo',
          trailing: Text(
            'ederhernadez@outlook.com',
            style: AppFonts.bodyMedium.copyWith(color: Colors.white),
          ),
        ),
        SizedBox(height: boxSpacing),
        _ProfileInfoButton(
          width: boxWidth,
          height: boxHeight,
          radius: boxRadius,
          icon: 'assets/images/location.png',
          iconSize: iconSize,
          title: 'Ubicación',
          trailing: Text(
            'Playa del carmen, México',
            style: AppFonts.bodyMedium.copyWith(color: Colors.white),
          ),
        ),
      ],
    );
  }
}

// Botón de info (reusable)
class _ProfileInfoButton extends StatelessWidget {
  final double width;
  final double height;
  final double radius;
  final String icon;
  final double iconSize;
  final String title;
  final Widget trailing;
  const _ProfileInfoButton({
    required this.width,
    required this.height,
    required this.radius,
    required this.icon,
    required this.iconSize,
    required this.title,
    required this.trailing,
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(radius),
      ),
      padding: EdgeInsets.symmetric(horizontal: radius, vertical: radius * 0.3),
      child: Row(
        children: [
          Image.asset(icon, width: iconSize, height: iconSize),
          SizedBox(width: radius),
          Expanded(
            child: Text(
              title,
              style: AppFonts.bodyMedium.copyWith(color: Colors.white),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          trailing,
        ],
      ),
    );
  }
}
