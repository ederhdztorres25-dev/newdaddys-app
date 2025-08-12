import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:newdaddys/theme/app_colors.dart';
import 'package:newdaddys/theme/app_fonts.dart';
import 'package:newdaddys/widgets/app_bottom_nav_bar.dart';

import 'package:newdaddys/screens/chat_screen.dart';

// Esta es la pantalla principal de Babys (chats)
class BabysScreen extends StatelessWidget {
  const BabysScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtenemos el tamaño de la pantalla para hacer todo responsivo
    final size = MediaQuery.of(context).size;
    double w(double px) => px * size.width / 1440;
    double h(double px) => px * size.height / 3120;

    // Aquí puedes agregar o quitar chats fácilmente
    final List<ChatInfo> chats = [
      ChatInfo('Sofia Pedraza', 24),
      ChatInfo('Andrea Magali', null),
      ChatInfo('Naomy Fuentes', null),
      ChatInfo('Paulina Hernández', null),
      ChatInfo('María López', 22),
      ChatInfo('Camila Torres', 25),
      ChatInfo('Valeria Ruiz', 23),
      ChatInfo('Fernanda Díaz', 21),
      ChatInfo('Isabella Gómez', 26),
      ChatInfo('Ximena Castro', 24),
      ChatInfo('Regina Morales', 22),
      ChatInfo('Renata Herrera', 23),
      ChatInfo('Alexa Mendoza', 25),
      ChatInfo('Pamela Salinas', 21),
    ];

    // Medidas y estilos para que todo sea fácil de cambiar
    final double boxSpacing = h(60); // Espacio entre elementos
    final double cardWidth = w(1320); // Ancho de cada cajita
    final double cardHeight = h(270); // Alto de cada cajita
    final double avatarSize = w(164); // Tamaño de la foto
    final double cardRadius = w(25); // Bordes redondeados
    final double cardPadding = w(60); // Padding interno de la cajita
    final double searchHeight = h(185); // Alto de la barra de búsqueda
    final double searchRadius =
        w(25); // Bordes redondeados de la barra de búsqueda
    final double searchIconSize = w(60); // Tamaño de la lupa
    final double dotsIconSize = w(52); // Tamaño de los tres puntos
    final double verifiedIconSize = w(48); // Tamaño del icono de verificado

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        automaticallyImplyLeading: false, // No mostrar flecha de regreso
        centerTitle: true,
        title: Text('Chats', style: AppFonts.h2),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: boxSpacing),
            // Barra de búsqueda arriba
            SearchBar(
              width: cardWidth,
              height: searchHeight,
              borderRadius: searchRadius,
              iconSize: searchIconSize,
              horizontalPadding: w(30),
            ),
            SizedBox(height: boxSpacing),
            // Lista de chats (cajitas)
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.zero,
                itemCount: chats.length,
                separatorBuilder: (_, __) => SizedBox(height: boxSpacing),
                itemBuilder: (context, index) {
                  // Aquí solo ves que agregas una cajita más
                  return Center(
                    child: ChatCard(
                      info: chats[index],
                      width: cardWidth,
                      height: cardHeight,
                      avatarSize: avatarSize,
                      borderRadius: cardRadius,
                      padding: cardPadding,
                      dotsIconSize: dotsIconSize,
                      verifiedIconSize: verifiedIconSize,
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: boxSpacing),
          ],
        ),
      ),
      // Barra de navegación de abajo, el botón Babys está seleccionado
      bottomNavigationBar: AppBottomNavBar(selectedIndex: 1),
    );
  }
}

// Modelo simple para la info de cada chat
class ChatInfo {
  final String name;
  final int? age;
  ChatInfo(this.name, this.age);
}

// Widget para la barra de búsqueda
class SearchBar extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;
  final double iconSize;
  final double horizontalPadding;
  const SearchBar({
    super.key,
    required this.width,
    required this.height,
    required this.borderRadius,
    required this.iconSize,
    required this.horizontalPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: AppColors.secondary, width: 1),
      ),
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/icons/lupa.svg',
            color: AppColors.secondary,
            width: iconSize,
            height: iconSize,
          ),
          SizedBox(width: horizontalPadding / 2),
          Expanded(
            child: TextField(
              style: AppFonts.bodyMedium.copyWith(color: AppColors.secondary),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Buscar',
                hintStyle:
                    AppFonts.bodyMedium.copyWith(color: AppColors.secondary),
                isCollapsed: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Widget para cada cajita de chat
class ChatCard extends StatelessWidget {
  final ChatInfo info;
  final double width;
  final double height;
  final double avatarSize;
  final double borderRadius;
  final double padding;
  final double dotsIconSize;
  final double verifiedIconSize;
  const ChatCard({
    super.key,
    required this.info,
    required this.width,
    required this.height,
    required this.avatarSize,
    required this.borderRadius,
    required this.padding,
    required this.dotsIconSize,
    required this.verifiedIconSize,
  });

  @override
  Widget build(BuildContext context) {
    // Key para mostrar el menú justo debajo de los tres puntos
    final GlobalKey dotsKey = GlobalKey();
    return GestureDetector(
      onTap: () {
        // Al tocar la cajita, vas a la vista de chat
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const ChatScreen()),
        );
      },
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        padding: EdgeInsets.all(padding),
        child: Row(
          children: [
            // Foto de perfil (siempre la misma)
            GestureDetector(
              onTap: () {
                // Al tocar la foto, vas al perfil de la chica
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const GirlProfileView()),
                );
              },
              child: CircleAvatar(
                radius: avatarSize / 2,
                backgroundImage: AssetImage('assets/images/karen.png'),
              ),
            ),
            SizedBox(width: padding),
            // Nombre, edad y verificado
            Expanded(
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      info.age != null
                          ? '${info.name}, ${info.age}'
                          : info.name,
                      style: AppFonts.bodyMedium
                          .copyWith(color: AppColors.secondary),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: SvgPicture.asset(
                      'assets/icons/verified.svg',
                      width: verifiedIconSize,
                      height: verifiedIconSize,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: padding),
            // Botón de los tres puntos
            GestureDetector(
              key: dotsKey,
              onTap: () async {
                // Calcula la posición para mostrar el menú justo debajo
                final RenderBox renderBox =
                    dotsKey.currentContext!.findRenderObject() as RenderBox;
                final Offset offset = renderBox.localToGlobal(Offset.zero);
                final Size size = renderBox.size;
                await showMenu(
                  context: context,
                  position: RelativeRect.fromLTRB(
                    offset.dx,
                    offset.dy + size.height,
                    offset.dx + size.width,
                    offset.dy,
                  ),
                  items: [
                    PopupMenuItem(
                      value: 'eliminar',
                      child: Text('Eliminar match', style: AppFonts.bodyMedium),
                    ),
                  ],
                );
              },
              child: Container(
                width: dotsIconSize * 2,
                height: dotsIconSize * 2,
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  'assets/icons/dots.svg',
                  color: AppColors.secondary,
                  width: dotsIconSize * 1.3,
                  height: dotsIconSize * 1.3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Vista vacía para el perfil de la chica
class GirlProfileView extends StatelessWidget {
  const GirlProfileView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
        title: const Text('Perfil'),
      ),
      body: const Center(
        child: Text(
          'Aquí irá la información de la chica',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }
}
