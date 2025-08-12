import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:newdaddys/theme/app_colors.dart';
import 'package:newdaddys/theme/app_fonts.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // Estas medidas deben ser consistentes con tu diseño
    final double backBtnSize = size.width * 0.09; // Ajusta según sea necesario

    return AppBar(
      backgroundColor: AppColors.primary,
      elevation: 0,
      leading: Padding(
        padding: EdgeInsets.only(left: size.width * 0.02), // Ajusta el padding
        child: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: SvgPicture.asset(
            'assets/icons/move-left.svg',
            color: AppColors.secondary,
            width: backBtnSize,
            height: backBtnSize,
          ),
          iconSize: backBtnSize,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ),
      centerTitle: true,
      title: Text(title, style: AppFonts.bodyMedium),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
