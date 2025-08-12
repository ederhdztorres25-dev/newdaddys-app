import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:newdaddys/theme/app_colors.dart';
import 'package:newdaddys/theme/app_fonts.dart';
import 'package:newdaddys/widgets/app_bottom_nav_bar.dart';
import 'package:newdaddys/widgets/primary_button.dart';

// ─────────────────────────────────────────────────────────────────
// PANTALLA PRINCIPAL DEL DETALLE DE PERFIL
// ─────────────────────────────────────────────────────────────────
class ProfileBabyDetailScreen extends StatefulWidget {
  const ProfileBabyDetailScreen({super.key});

  @override
  State<ProfileBabyDetailScreen> createState() =>
      _ProfileBabyDetailScreenState();
}

class _ProfileBabyDetailScreenState extends State<ProfileBabyDetailScreen> {
  // --- ESTADO ---
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  final List<String> _images =
      List.generate(5, (_) => 'assets/images/karen.png');

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // --- UI ---
  @override
  Widget build(BuildContext context) {
    // Funciones para medidas proporcionales
    final size = MediaQuery.of(context).size;
    double w(double px) => px * size.width / 1440;
    double h(double px) => px * size.height / 3120;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Stack(
        children: [
          // Contenido principal con scroll
          CustomScrollView(
            slivers: [
              _ProfileSliverAppBar(
                h: h,
                w: w,
                images: _images,
                pageController: _pageController,
                currentIndex: _currentIndex,
                onPageChanged: (index) => setState(() => _currentIndex = index),
              ),
              _ProfileBody(h: h, w: w),
            ],
          ),
          // Botón de regreso flotante
          _FloatingBackButton(h: h, w: w),
        ],
      ),
      bottomNavigationBar: _BottomBar(h: h, w: w),
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// WIDGETS PRIVADOS DE LA PANTALLA
// ─────────────────────────────────────────────────────────────────

// --- 1. Botón de Regreso Flotante ---
class _FloatingBackButton extends StatelessWidget {
  const _FloatingBackButton({required this.h, required this.w});
  final double Function(double) h;
  final double Function(double) w;

  @override
  Widget build(BuildContext context) {
    final double backBtnSize = w(130);
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(left: w(30), top: h(20 + 8 + 60)),
        child: SizedBox(
          width: backBtnSize,
          height: backBtnSize,
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
      ),
    );
  }
}

// --- 2. Barra Superior Colapsable con Galería ---
class _ProfileSliverAppBar extends StatelessWidget {
  const _ProfileSliverAppBar({
    required this.h,
    required this.w,
    required this.images,
    required this.pageController,
    required this.currentIndex,
    required this.onPageChanged,
  });

  final double Function(double) h;
  final double Function(double) w;
  final List<String> images;
  final PageController pageController;
  final int currentIndex;
  final ValueChanged<int> onPageChanged;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: h(1200),
      pinned: true,
      backgroundColor: AppColors.primary,
      elevation: 0,
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        background: _AppBarBackground(
          h: h,
          w: w,
          images: images,
          pageController: pageController,
          currentIndex: currentIndex,
          onPageChanged: onPageChanged,
        ),
      ),
    );
  }
}

// --- 3. Contenido de Fondo del AppBar ---
class _AppBarBackground extends StatelessWidget {
  const _AppBarBackground({
    required this.h,
    required this.w,
    required this.images,
    required this.pageController,
    required this.currentIndex,
    required this.onPageChanged,
  });
  final double Function(double) h;
  final double Function(double) w;
  final List<String> images;
  final PageController pageController;
  final int currentIndex;
  final ValueChanged<int> onPageChanged;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        PageView.builder(
          controller: pageController,
          itemCount: images.length,
          onPageChanged: onPageChanged,
          itemBuilder: (context, index) {
            return Image.asset(images[index], fit: BoxFit.cover);
          },
        ),
        const _BottomGradient(),
        const _TopGradient(),
        _GalleryNavigation(pageController: pageController),
        _ProgressIndicators(
            h: h, w: w, images: images, currentIndex: currentIndex),
      ],
    );
  }
}

// --- 4. Componentes del AppBarBackground ---

class _BottomGradient extends StatelessWidget {
  const _BottomGradient();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.transparent, Colors.black],
          stops: [0.7, 1.0],
        ),
      ),
    );
  }
}

class _TopGradient extends StatelessWidget {
  const _TopGradient();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.primary, Colors.transparent],
          stops: const [0.0, 0.4],
        ),
      ),
    );
  }
}

class _GalleryNavigation extends StatelessWidget {
  const _GalleryNavigation({required this.pageController});
  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => pageController.previousPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            ),
            child: Container(color: Colors.transparent),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () => pageController.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            ),
            child: Container(color: Colors.transparent),
          ),
        ),
      ],
    );
  }
}

class _ProgressIndicators extends StatelessWidget {
  const _ProgressIndicators({
    required this.h,
    required this.w,
    required this.images,
    required this.currentIndex,
  });
  final double Function(double) h;
  final double Function(double) w;
  final List<String> images;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: w(30), vertical: h(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: List.generate(
                images.length,
                (index) => Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: w(5)),
                    child: Container(
                      height: h(8),
                      decoration: BoxDecoration(
                        color: currentIndex == index
                            ? Colors.white
                            : Colors.white.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(h(4)),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- 5. Cuerpo Principal del Perfil ---
class _ProfileBody extends StatelessWidget {
  const _ProfileBody({required this.h, required this.w});
  final double Function(double) h;
  final double Function(double) w;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Transform.translate(
        offset: Offset(0, -h(40)),
        child: Container(
          padding: EdgeInsets.only(top: h(40), left: w(60), right: w(60)),
          decoration: BoxDecoration(
            color: AppColors.backgroundColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(w(40))),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ProfileHeader(w: w),
              SizedBox(height: h(50)),
              _InfoCard(
                  w: w,
                  h: h,
                  title: 'Busco',
                  content:
                      'Hola, busco SD. Quiero salir de mi zona de Comfort'),
              SizedBox(height: h(50)),
              _HabitsCard(w: w, h: h),
              SizedBox(height: h(50)),
              _SocialsCard(w: w, h: h),
              SizedBox(height: h(50)),
              _LanguagesCard(w: w, h: h),
              SizedBox(height: h(50)),
              _VerificationsCard(w: w, h: h),
              SizedBox(height: h(50)),
            ],
          ),
        ),
      ),
    );
  }
}

// --- 6. Componentes del _ProfileBody ---

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.w});
  final double Function(double) w;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Sofia Pedraza', style: AppFonts.h1),
            SizedBox(width: w(20)),
            SvgPicture.asset('assets/icons/verified.svg', width: w(50)),
          ],
        ),
        SizedBox(height: w(40)),
        Row(
          children: [
            _InfoChip(w: w, icon: 'assets/icons/compas.svg', text: 'A 4km'),
            SizedBox(width: w(40)),
            _InfoChip(w: w, icon: 'assets/icons/clock.svg', text: 'Activa hoy'),
          ],
        ),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.w, required this.icon, required this.text});
  final double Function(double) w;
  final String icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(icon, width: w(40), color: AppColors.secondary),
        SizedBox(width: w(15)),
        Text(text,
            style: AppFonts.bodyMedium.copyWith(color: AppColors.secondary)),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard(
      {required this.w,
      required this.h,
      required this.title,
      required this.content});
  final double Function(double) w;
  final double Function(double) h;
  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(w(50)),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(w(25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: AppFonts.h3.copyWith(
                  color: AppColors.secondary, fontWeight: FontWeight.bold)),
          SizedBox(height: h(20)),
          Text(content,
              style:
                  AppFonts.bodyMedium.copyWith(color: AppColors.secondaryText)),
        ],
      ),
    );
  }
}

class _HabitsCard extends StatelessWidget {
  const _HabitsCard({required this.w, required this.h});
  final double Function(double) w;
  final double Function(double) h;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(w(50)),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(w(25)),
      ),
      child: Column(
        children: [
          _HabitRow(icon: Icons.no_drinks_outlined, text: 'No bebedor', w: w),
          SizedBox(height: h(30)),
          _HabitRow(icon: Icons.smoke_free_outlined, text: 'No fumador', w: w),
          SizedBox(height: h(30)),
          _HabitRow(
              icon: Icons.fitness_center_outlined, text: 'Algunas veces', w: w),
        ],
      ),
    );
  }
}

class _HabitRow extends StatelessWidget {
  const _HabitRow({required this.icon, required this.text, required this.w});
  final IconData icon;
  final String text;
  final double Function(double) w;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.secondary, size: w(50)),
        SizedBox(width: w(30)),
        Text(text,
            style: AppFonts.bodyMedium.copyWith(color: AppColors.secondary)),
      ],
    );
  }
}

class _SocialsCard extends StatelessWidget {
  const _SocialsCard({required this.w, required this.h});
  final double Function(double) w;
  final double Function(double) h;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(w(50)),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(w(25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Redes sociales',
                  style: AppFonts.h3.copyWith(
                      color: AppColors.secondary, fontWeight: FontWeight.bold)),
              SizedBox(width: w(30)),
              PrimaryButton(
                text: 'Desbloquea con plan Elite',
                onPressed: () {},
                backgroundColor: const Color(0xFF0891B2),
                textColor: AppColors.secondary,
                height: h(130),
                width: w(600),
                fontSize: w(30),
                borderRadius: 8.0,
              ),
            ],
          ),
          SizedBox(height: h(60)),
          Row(
            children: [
              Image.asset('assets/images/whatsapp.png', width: w(120)),
              SizedBox(width: w(40)),
              Image.asset('assets/images/instagram.png', width: w(120)),
              SizedBox(width: w(40)),
              Image.asset('assets/images/telegram.png', width: w(120)),
            ],
          ),
        ],
      ),
    );
  }
}

class _LanguagesCard extends StatelessWidget {
  const _LanguagesCard({required this.w, required this.h});
  final double Function(double) w;
  final double Function(double) h;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(w(50)),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(w(25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Idiomas',
              style: AppFonts.h3.copyWith(
                  color: AppColors.secondary, fontWeight: FontWeight.bold)),
          SizedBox(height: h(30)),
          Row(
            children: [
              _LanguageChip(language: 'Español', w: w),
              SizedBox(width: w(30)),
              _LanguageChip(language: 'Inglés', w: w),
            ],
          )
        ],
      ),
    );
  }
}

class _LanguageChip extends StatelessWidget {
  const _LanguageChip({required this.language, required this.w});
  final String language;
  final double Function(double) w;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: w(40), vertical: w(20)),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(w(15)),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Text(language,
          style: AppFonts.bodyMedium.copyWith(color: AppColors.secondary)),
    );
  }
}

class _VerificationsCard extends StatelessWidget {
  const _VerificationsCard({required this.w, required this.h});
  final double Function(double) w;
  final double Function(double) h;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(w(50)),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(w(25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Verificaciones',
              style: AppFonts.h3.copyWith(
                  color: AppColors.secondary, fontWeight: FontWeight.bold)),
          SizedBox(height: h(30)),
          _VerificationItem(
              letter: 'A',
              color: Colors.pink,
              name: 'A*********',
              date: '26/10/2025',
              comment:
                  'Cumplió con todo lo acordado desde el primer momento. Muy respetuosa y generosa. La discreción ha sido total.',
              w: w,
              h: h),
          SizedBox(height: h(40)),
          _VerificationItem(
              letter: 'M',
              color: Colors.purple,
              name: 'Mariana',
              date: 'Hoy',
              comment:
                  'Excelente SD. Muy generoso y puntual con los apoyos. 100% recomendado para cualquier SB',
              w: w,
              h: h),
          SizedBox(height: h(50)),
          PrimaryButton(
            text: 'Añadir verificación',
            onPressed: () {},
            backgroundColor: const Color(0xFF0891B2),
            textColor: AppColors.secondary,
            height: h(170),
            width: double.infinity,
            icon: SvgPicture.asset(
              'assets/icons/chat.svg',
              color: AppColors.secondary,
              width: w(50),
            ),
            borderRadius: 8.0,
          )
        ],
      ),
    );
  }
}

class _VerificationItem extends StatelessWidget {
  const _VerificationItem({
    required this.letter,
    required this.color,
    required this.name,
    required this.date,
    required this.comment,
    required this.w,
    required this.h,
  });
  final String letter;
  final Color color;
  final String name;
  final String date;
  final String comment;
  final double Function(double) w;
  final double Function(double) h;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: color,
                  radius: w(40),
                  child: Text(letter, style: AppFonts.h3),
                ),
                SizedBox(width: w(30)),
                Text(name,
                    style: AppFonts.bodyMedium
                        .copyWith(color: AppColors.secondary)),
              ],
            ),
            Text(date,
                style: AppFonts.bodySmall
                    .copyWith(color: AppColors.placeholderText)),
          ],
        ),
        SizedBox(height: h(20)),
        Text(comment,
            style:
                AppFonts.bodyMedium.copyWith(color: AppColors.placeholderText)),
      ],
    );
  }
}

// --- 7. Barra Inferior con Botón de Acción y Navegación ---
class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.h, required this.w});
  final double Function(double) h;
  final double Function(double) w;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary,
      padding:
          EdgeInsets.only(top: h(40), bottom: h(20), left: w(60), right: w(60)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PrimaryButton(
            text: 'Invitar',
            onPressed: () {},
            height: h(170),
            width: double.infinity,
            backgroundColor: AppColors.secondary,
            textColor: AppColors.inputTextBlack,
            textStyle: AppFonts.h3.copyWith(fontWeight: FontWeight.bold),
            borderRadius: 8.0,
          ),
          SizedBox(height: h(40)),
          const AppBottomNavBar(selectedIndex: 0),
        ],
      ),
    );
  }
}
