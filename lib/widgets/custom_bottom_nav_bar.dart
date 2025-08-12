import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:newdaddys/theme/app_colors.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final void Function(int) onTap;
  const CustomBottomNavBar(
      {super.key, required this.selectedIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final List<_NavBarItemData> items = [
      _NavBarItemData('assets/icons/compas.svg', 'Descubrir'),
      _NavBarItemData('assets/icons/heart.svg', 'Babys'),
      _NavBarItemData('assets/icons/profile.svg', 'Perfil'),
      _NavBarItemData('assets/icons/more.svg', 'Más'),
    ];
    return Container(
      padding:
          EdgeInsets.symmetric(vertical: 8, horizontal: screenWidth * 0.06),
      decoration: BoxDecoration(
        color: AppColors.primary,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(items.length, (i) {
          final selected = i == selectedIndex;
          return GestureDetector(
            onTap: () => onTap(i),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  items[i].icon,
                  color: selected
                      ? AppColors.secondary
                      : AppColors.placeholderText,
                  width: 28,
                  height: 28,
                ),
                const SizedBox(height: 2),
                Text(
                  items[i].label,
                  style: TextStyle(
                    color: selected
                        ? AppColors.secondary
                        : AppColors.placeholderText,
                    fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _NavBarItemData {
  final String icon;
  final String label;
  _NavBarItemData(this.icon, this.label);
}
