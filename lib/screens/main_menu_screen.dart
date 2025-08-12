import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:newdaddys/theme/app_colors.dart';
import 'package:newdaddys/theme/app_fonts.dart';
import 'package:newdaddys/theme/app_sizes.dart';
import 'package:newdaddys/screens/filter_screen.dart';

import 'package:newdaddys/widgets/app_bottom_nav_bar.dart';
import 'package:newdaddys/screens/profile_baby_detail_screen.dart';

// Pantalla principal del menú
class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  // Esto es para saber si está seleccionado "Online" o "Nuevos"
  bool isOnlineSelected = true;

  @override
  Widget build(BuildContext context) {
    // Obtenemos el tamaño de la pantalla para usarlo en los tamaños
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    // Tamaños para los botones y los íconos
    final double buttonHeight = screenHeight * 0.05;
    final double buttonFontSize = screenHeight * 0.019;
    final double iconSize = screenHeight * 0.025;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        shadowColor: Colors.transparent,
        automaticallyImplyLeading: false,
        centerTitle: true,
        toolbarHeight: screenHeight * 0.07,
        title: const Text(
          'Intereses',
          style: AppFonts.h2,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * AppSizes.horizontalPadding,
          ),
          child: Column(
            children: [
              const SizedBox(height: 16),
              // Filtros de arriba (Online, Nuevos, Filtro)
              Row(
                children: [
                  MenuFilterButton(
                    svgIcon: 'assets/icons/online.svg',
                    label: 'Online',
                    selected: isOnlineSelected,
                    onPressed: () {
                      setState(() {
                        isOnlineSelected = true;
                      });
                    },
                    height: buttonHeight,
                    fontSize: buttonFontSize,
                    iconSize: iconSize,
                  ),
                  const SizedBox(width: 12),
                  MenuFilterButton(
                    svgIcon: 'assets/icons/fire.svg',
                    label: 'Nuevos',
                    selected: !isOnlineSelected,
                    onPressed: () {
                      setState(() {
                        isOnlineSelected = false;
                      });
                    },
                    height: buttonHeight,
                    fontSize: buttonFontSize,
                    iconSize: iconSize,
                  ),
                  const Spacer(),
                  MenuFilterIconButton(
                    svgIcon: 'assets/icons/filter.svg',
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => const FilterScreen()),
                      );
                    },
                    backgroundColor: AppColors.primary,
                    iconColor: AppColors.secondary,
                    size: buttonHeight,
                  ),
                ],
              ),
              const SizedBox(height: 18),
              // Lista de tarjetas de perfiles
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: GirlProfileCard(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const ProfileBabyDetailScreen(),
                                  ),
                                );
                              },
                              name: 'Karen',
                              age: 21,
                              distance: 'a 15 km',
                              isVerified: true,
                              imagePath: 'assets/images/karen.png',
                              whatsappIcon: 'assets/images/whatsapp.png',
                              instagramIcon: 'assets/images/instagram.png',
                              telegramIcon: 'assets/images/telegram.png',
                            ),
                          ),
                          SizedBox(width: 14),
                          Expanded(
                            child: GirlProfileCard(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const ProfileBabyDetailScreen(),
                                  ),
                                );
                              },
                              name: 'Naomy',
                              age: 24,
                              distance: 'a 2 km',
                              isVerified: true,
                              imagePath: 'assets/images/karen.png',
                              whatsappIcon: 'assets/images/whatsapp.png',
                              instagramIcon: 'assets/images/instagram.png',
                              telegramIcon: 'assets/images/telegram.png',
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: GirlProfileCard(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const ProfileBabyDetailScreen(),
                                  ),
                                );
                              },
                              name: 'Mafer',
                              age: 24,
                              distance: 'a 21 km',
                              isVerified: true,
                              imagePath: 'assets/images/karen.png',
                              whatsappIcon: 'assets/images/whatsapp.png',
                              instagramIcon: 'assets/images/instagram.png',
                              telegramIcon: 'assets/images/telegram.png',
                            ),
                          ),
                          SizedBox(width: 14),
                          Expanded(
                            child: GirlProfileCard(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const ProfileBabyDetailScreen(),
                                  ),
                                );
                              },
                              name: 'Ambar',
                              age: 25,
                              distance: 'a 35 km',
                              isVerified: true,
                              imagePath: 'assets/images/karen.png',
                              whatsappIcon: 'assets/images/whatsapp.png',
                              instagramIcon: 'assets/images/instagram.png',
                              telegramIcon: 'assets/images/telegram.png',
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: GirlProfileCard(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const ProfileBabyDetailScreen(),
                                  ),
                                );
                              },
                              name: 'Sofi',
                              age: 23,
                              distance: 'a 10 km',
                              isVerified: false,
                              imagePath: 'assets/images/karen.png',
                              whatsappIcon: 'assets/images/whatsapp.png',
                              instagramIcon: 'assets/images/instagram.png',
                              telegramIcon: 'assets/images/telegram.png',
                            ),
                          ),
                          SizedBox(width: 14),
                          Expanded(
                            child: GirlProfileCard(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const ProfileBabyDetailScreen(),
                                  ),
                                );
                              },
                              name: 'Luna',
                              age: 22,
                              distance: 'a 8 km',
                              isVerified: true,
                              imagePath: 'assets/images/karen.png',
                              whatsappIcon: 'assets/images/whatsapp.png',
                              instagramIcon: 'assets/images/instagram.png',
                              telegramIcon: 'assets/images/telegram.png',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AppBottomNavBar(selectedIndex: 0),
    );
  }
}

// Botón para los filtros de arriba (Online, Nuevos)
class MenuFilterButton extends StatelessWidget {
  final String svgIcon;
  final String label;
  final bool selected;
  final VoidCallback onPressed;
  final double height;
  final double fontSize;
  final double iconSize;

  const MenuFilterButton({
    required this.svgIcon,
    required this.label,
    required this.selected,
    required this.onPressed,
    required this.height,
    required this.fontSize,
    required this.iconSize,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final Color iconAndTextColor =
        selected ? AppColors.secondary : AppColors.placeholderText;
    return SizedBox(
      width: screenWidth * 0.32,
      height: height,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: selected ? AppColors.highlight : AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.03,
            vertical: 0,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              svgIcon,
              color: iconAndTextColor,
              width: iconSize,
              height: iconSize,
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: iconAndTextColor,
                  fontSize: fontSize,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Botón de ícono para el filtro (el de la derecha)
class MenuFilterIconButton extends StatelessWidget {
  final String svgIcon;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color iconColor;
  final double size;

  const MenuFilterIconButton({
    required this.svgIcon,
    required this.onPressed,
    required this.backgroundColor,
    required this.iconColor,
    required this.size,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(size * 0.35),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: SvgPicture.asset(
          svgIcon,
          color: iconColor,
          width: size * 0.6,
          height: size * 0.6,
        ),
        iconSize: size * 0.6,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
      ),
    );
  }
}

// Tarjeta de perfil de chica
class GirlProfileCard extends StatelessWidget {
  final String name;
  final int age;
  final String distance;
  final bool isVerified;
  final String imagePath;
  final String whatsappIcon;
  final String instagramIcon;
  final String telegramIcon;
  final VoidCallback? onTap;

  const GirlProfileCard({
    super.key,
    required this.name,
    required this.age,
    required this.distance,
    required this.isVerified,
    required this.imagePath,
    required this.whatsappIcon,
    required this.instagramIcon,
    required this.telegramIcon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final double cardWidth = MediaQuery.of(context).size.width * 0.43;
    final double cardHeight = cardWidth * 1.52;
    return InkWell(
      onTap: onTap,
      child: AspectRatio(
        aspectRatio: 0.7, // Proporción ancho/alto
        child: Container(
          width: cardWidth,
          height: cardHeight,
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              // Degradado para que se vea bien el texto
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: cardHeight * 0.38,
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Color.fromRGBO(0, 0, 0, 0.7), // 70% opacidad
                        Colors.black54,
                        Colors.transparent,
                      ],
                      stops: [0.0, 0.5, 1.0],
                    ),
                  ),
                ),
              ),
              // Información de la chica
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Nombre, edad y verificado
                      Row(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '$name, $age',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (isVerified)
                                const Padding(
                                  padding: EdgeInsets.only(left: 6),
                                  child: Icon(Icons.verified,
                                      color: Colors.blue, size: 18),
                                ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      // Distancia y redes sociales
                      Row(
                        children: [
                          Text(
                            distance,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              Image.asset(whatsappIcon, width: 22, height: 22),
                              const SizedBox(width: 8),
                              Image.asset(instagramIcon, width: 22, height: 22),
                              const SizedBox(width: 8),
                              Image.asset(telegramIcon, width: 22, height: 22),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
