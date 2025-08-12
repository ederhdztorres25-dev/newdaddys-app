import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:newdaddys/theme/app_colors.dart';
import 'package:newdaddys/theme/app_fonts.dart';

class PremiumSubscriptionScreen extends StatefulWidget {
  const PremiumSubscriptionScreen({super.key});

  @override
  State<PremiumSubscriptionScreen> createState() =>
      _PremiumSubscriptionScreenState();
}

class _PremiumSubscriptionScreenState extends State<PremiumSubscriptionScreen> {
  bool isGoldSelected = true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double w(double px) => px * size.width / 1440;
    double h(double px) => px * size.height / 3120;

    // Medidas
    final double cardWidth = w(540);
    final double cardHeight = h(260);
    final double cardRadius = w(24);
    final double cardSpacing = w(32);
    final double iconSize = w(60);
    final double planBoxWidth = w(1320);
    final double planBoxRadius = w(32);
    final double planBoxPadding = w(48);
    final double planBoxSpacing = h(32);
    final double benefitIconSize = w(44);
    final double buttonHeight = h(140);

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: EdgeInsets.only(left: w(10)),
          child: SizedBox(
            width: w(130),
            height: w(130),
            child: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: SvgPicture.asset(
                'assets/icons/move-left.svg',
                color: AppColors.secondary,
                width: w(130),
                height: w(130),
              ),
              iconSize: w(130),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ),
        ),
        title: Text('Suscripciones Premium', style: AppFonts.bodyMedium),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: (size.width - w(1320)) / 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: h(60)),
            Text('Mejora tu experiencia',
                style: AppFonts.bodyMedium, textAlign: TextAlign.center),
            SizedBox(height: h(16)),
            Text(
              'Elige el plan que mejor se adapte a ti',
              style: AppFonts.bodyMedium
                  .copyWith(color: AppColors.placeholderText),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: h(60)),
            SizedBox(
              width: w(1320),
              child: Row(
                children: [
                  Expanded(
                    child: _PlanToggleCard(
                      selected: isGoldSelected,
                      icon: 'assets/icons/crown.svg',
                      title: 'Gold',
                      price: '399 MXN / Mes',
                      onTap: () => setState(() => isGoldSelected = true),
                      borderColor: AppColors.gold,
                      iconColor: AppColors.gold,
                    ),
                  ),
                  SizedBox(width: w(32)),
                  Expanded(
                    child: _PlanToggleCard(
                      selected: !isGoldSelected,
                      icon: 'assets/icons/star.svg',
                      title: 'Elite',
                      price: '2,499 MXN / Mes',
                      onTap: () => setState(() => isGoldSelected = false),
                      borderColor: AppColors.elite,
                      iconColor: AppColors.elite,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: h(60)),
            // Beneficios del plan (scrolleable)
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  width: w(1320),
                  padding: EdgeInsets.all(planBoxPadding),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(planBoxRadius),
                  ),
                  child: isGoldSelected
                      ? _GoldBenefits(
                          iconSize: benefitIconSize, spacing: planBoxSpacing)
                      : _EliteBenefits(
                          iconSize: benefitIconSize, spacing: planBoxSpacing),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          left: (size.width - w(1320)) / 2,
          right: (size.width - w(1320)) / 2,
          bottom: h(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: w(1320),
              height: h(250),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isGoldSelected ? AppColors.gold : AppColors.elite,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(planBoxRadius),
                  ),
                  elevation: 0,
                ),
                onPressed: () {},
                child: Text(
                  isGoldSelected ? 'Suscríbete a Gold' : 'Suscríbete a Elite',
                  style: AppFonts.h3.copyWith(color: Colors.black),
                ),
              ),
            ),
            SizedBox(height: h(16)),
            Text(
              'Se renovará automáticamente. Puedes cancelar en cualquier momento.',
              style:
                  AppFonts.bodySmall.copyWith(color: AppColors.placeholderText),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _PlanToggleCard extends StatelessWidget {
  final bool selected;
  final String icon;
  final String title;
  final String price;
  final VoidCallback onTap;
  final Color borderColor;
  final Color iconColor;
  const _PlanToggleCard({
    required this.selected,
    required this.icon,
    required this.title,
    required this.price,
    required this.onTap,
    required this.borderColor,
    required this.iconColor,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: selected ? borderColor : AppColors.primary.withOpacity(0.5),
            width: 2.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(icon, width: 36, height: 36, color: iconColor),
            SizedBox(height: 8),
            Text(title,
                style: AppFonts.bodyMedium.copyWith(
                    color: Colors.white, fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            Text(price,
                style: AppFonts.bodyMedium.copyWith(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}

class _BenefitRow extends StatelessWidget {
  final String icon;
  final Color color;
  final String title;
  final String desc;
  final double iconSize;
  const _BenefitRow({
    required this.icon,
    required this.color,
    required this.title,
    required this.desc,
    required this.iconSize,
  });
  @override
  Widget build(BuildContext context) {
    final double bigIconSize = iconSize * 1.45;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 2),
          child: SvgPicture.asset(icon,
              width: bigIconSize, height: bigIconSize, color: color),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: AppFonts.bodyMedium
                      .copyWith(color: color, fontWeight: FontWeight.bold)),
              SizedBox(height: 2),
              Text(desc,
                  style: AppFonts.bodyMedium.copyWith(color: Colors.white)),
            ],
          ),
        ),
      ],
    );
  }
}

class _GoldBenefits extends StatelessWidget {
  final double iconSize;
  final double spacing;
  const _GoldBenefits({required this.iconSize, required this.spacing});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Plan Gold',
              style: AppFonts.bodyMedium.copyWith(
                  color: AppColors.gold, fontWeight: FontWeight.bold)),
          SizedBox(height: spacing),
          _BenefitRow(
            icon: 'assets/icons/heart.svg',
            color: AppColors.gold,
            title: 'Invitaciones ilimitadas',
            desc: 'Invita y conoce a todas las babys que quieras al mes',
            iconSize: iconSize,
          ),
          SizedBox(height: spacing),
          _BenefitRow(
            icon: 'assets/icons/chat.svg',
            color: AppColors.gold,
            title: 'Mensajes ilimitados',
            desc: 'Lee y responde todos los mensajes en tu bandeja',
            iconSize: iconSize,
          ),
          SizedBox(height: spacing),
          _BenefitRow(
            icon: 'assets/icons/doublecheck.svg',
            color: AppColors.gold,
            title: 'Revisa quien ha visto tu perfil',
            desc: 'Lee y responde todos los mensajes en tu bandeja',
            iconSize: iconSize,
          ),
          SizedBox(height: spacing),
          _BenefitRow(
            icon: 'assets/icons/clock.svg',
            color: AppColors.gold,
            title: 'Ver última conexión',
            desc: 'Conoce la última actividad de las chicas en la app',
            iconSize: iconSize,
          ),
        ],
      ),
    );
  }
}

class _EliteBenefits extends StatelessWidget {
  final double iconSize;
  final double spacing;
  const _EliteBenefits({required this.iconSize, required this.spacing});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Plan Elite',
              style: AppFonts.bodyMedium.copyWith(
                  color: AppColors.elite, fontWeight: FontWeight.bold)),
          SizedBox(height: spacing),
          _BenefitRow(
            icon: 'assets/icons/star.svg',
            color: AppColors.elite,
            title: 'Insignia Elite',
            desc:
                'Emblema exclusivo que demuestra tu alto estatus económico y compromiso con la app',
            iconSize: iconSize,
          ),
          SizedBox(height: spacing),
          _BenefitRow(
            icon: 'assets/icons/discreto.svg',
            color: AppColors.elite,
            title: 'Modo discreto',
            desc:
                'Mantén tu privacidad ocultando tus fotos mientras conservas tu prestigiosa Insignia Elite',
            iconSize: iconSize,
          ),
          SizedBox(height: spacing),
          _BenefitRow(
            icon: 'assets/icons/block_screenshots.svg',
            color: AppColors.elite,
            title: 'Bloqueo de screenshots',
            desc:
                'Protege tu privacidad: las chicas no pueden capturar pantalla de tus conversaciones',
            iconSize: iconSize,
          ),
          SizedBox(height: spacing),
          _BenefitRow(
            icon: 'assets/icons/flash.svg',
            color: AppColors.elite,
            title: 'Invitaciones prioritarias',
            desc:
                'Tus invitaciones se muestran primero en la bandeja de las chicas',
            iconSize: iconSize,
          ),
          SizedBox(height: spacing),
          _BenefitRow(
            icon: 'assets/icons/chat.svg',
            color: AppColors.elite,
            title: 'Mensajes directos',
            desc:
                'Contacta hasta 3 chicas diarias sin invitación previa (solo chat interno)',
            iconSize: iconSize,
          ),
          SizedBox(height: spacing),
          _BenefitRow(
            icon: 'assets/icons/information.svg',
            color: AppColors.elite,
            title: 'Incluye todos los beneficios Gold',
            desc: 'Además de los beneficios exclusivos Elite',
            iconSize: iconSize,
          ),
        ],
      ),
    );
  }
}
