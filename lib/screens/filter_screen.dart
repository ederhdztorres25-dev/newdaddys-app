import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:newdaddys/theme/app_colors.dart';
import 'package:newdaddys/theme/app_fonts.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  // Estados para los controles
  bool hombres = false;
  bool mujeres = true;
  double distancia = 178;
  double edadMin = 18;
  double edadMax = 36;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // Medidas proporcionales a Figma
    double w(double px) => px * size.width / 1440;
    double h(double px) => px * size.height / 3120;

    final double boxWidth = w(1320);
    final double boxSpacing = w(30);
    final double borderRadius = w(25);
    final double boxPadding = w(60);
    final double titleContentSpacing = w(50);
    final double contentSpacing = w(30);
    final double locationBoxHeight = h(220);
    final double backBtnSize = w(130);
    final double thumbRadius = w(18); // Ajustable para ambos sliders

    final sliderTheme = SliderTheme.of(context).copyWith(
      trackHeight: h(20),
      thumbShape: RoundSliderThumbShape(enabledThumbRadius: thumbRadius),
      rangeThumbShape:
          RoundRangeSliderThumbShape(enabledThumbRadius: thumbRadius),
      overlayShape: RoundSliderOverlayShape(overlayRadius: thumbRadius + 6),
      activeTrackColor: AppColors.placeholderText,
      inactiveTrackColor: AppColors.placeholderText.withOpacity(0.3),
      thumbColor: AppColors.secondary,
    );

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: Padding(
          padding: EdgeInsets.only(left: w(10)),
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
        centerTitle: true,
        title: Text('Filtros', style: AppFonts.bodyMedium),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: boxSpacing),
              _FilterBox(
                width: boxWidth,
                borderRadius: borderRadius,
                padding: boxPadding,
                title: 'Ubicación',
                titleContentSpacing: titleContentSpacing,
                child: Container(
                  height: locationBoxHeight,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(borderRadius),
                    border: Border.all(color: AppColors.borderColor, width: 2),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: w(30)),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/online.svg',
                        color: AppColors.placeholderText,
                        width: w(40),
                        height: w(40),
                      ),
                      SizedBox(width: w(20)),
                      Text(
                        'Playa del Carmen',
                        style: AppFonts.bodyMedium.copyWith(
                          color: AppColors.placeholderText,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: boxSpacing),
              _FilterBox(
                width: boxWidth,
                borderRadius: borderRadius,
                padding: boxPadding,
                title: 'Distancia',
                titleContentSpacing: titleContentSpacing,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(),
                        Text('${distancia.toInt()} cm',
                            style: AppFonts.bodyMedium
                                .copyWith(color: AppColors.placeholderText)),
                      ],
                    ),
                    SizedBox(height: contentSpacing),
                    SliderTheme(
                      data: sliderTheme,
                      child: Slider(
                        value: distancia,
                        min: 0,
                        max: 300,
                        onChanged: (v) => setState(() => distancia = v),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: boxSpacing),
              _FilterBox(
                width: boxWidth,
                borderRadius: borderRadius,
                padding: boxPadding,
                title: 'Edad',
                titleContentSpacing: titleContentSpacing,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${edadMin.toInt()} años',
                            style: AppFonts.bodyMedium
                                .copyWith(color: AppColors.placeholderText)),
                        Text('${edadMax.toInt()} años',
                            style: AppFonts.bodyMedium
                                .copyWith(color: AppColors.placeholderText)),
                      ],
                    ),
                    SizedBox(height: contentSpacing),
                    SliderTheme(
                      data: sliderTheme,
                      child: RangeSlider(
                        values: RangeValues(edadMin, edadMax),
                        min: 18,
                        max: 100,
                        onChanged: (values) => setState(() {
                          edadMin = values.start;
                          edadMax = values.end;
                        }),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: boxSpacing),
              _FilterBox(
                width: boxWidth,
                borderRadius: borderRadius,
                padding: boxPadding,
                title: 'Idioma',
                titleContentSpacing: titleContentSpacing,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Idioma',
                        style: AppFonts.bodyMedium
                            .copyWith(color: AppColors.secondary)),
                    Row(
                      children: [
                        Text('Español',
                            style: AppFonts.bodyMedium
                                .copyWith(color: AppColors.placeholderText)),
                        Icon(Icons.keyboard_arrow_down_rounded,
                            color: AppColors.placeholderText, size: h(50)),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: boxSpacing),
              _FilterBox(
                width: boxWidth,
                borderRadius: borderRadius,
                padding: boxPadding,
                title: 'Género',
                titleContentSpacing: titleContentSpacing,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Hombres',
                            style: AppFonts.bodyMedium
                                .copyWith(color: AppColors.secondary)),
                        Switch(
                          value: hombres,
                          onChanged: (v) => setState(() => hombres = v),
                          activeColor: AppColors.secondary,
                          inactiveThumbColor: AppColors.placeholderText,
                          inactiveTrackColor:
                              AppColors.placeholderText.withOpacity(0.3),
                        ),
                      ],
                    ),
                    SizedBox(height: contentSpacing),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Mujeres',
                            style: AppFonts.bodyMedium
                                .copyWith(color: AppColors.secondary)),
                        Switch(
                          value: mujeres,
                          onChanged: (v) => setState(() => mujeres = v),
                          activeColor: AppColors.secondary,
                          inactiveThumbColor: AppColors.placeholderText,
                          inactiveTrackColor:
                              AppColors.placeholderText.withOpacity(0.3),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: boxSpacing),
            ],
          ),
        ),
      ),
    );
  }
}

class _FilterBox extends StatelessWidget {
  final String title;
  final Widget child;
  final double width;
  final double borderRadius;
  final double padding;
  final double titleContentSpacing;
  const _FilterBox({
    required this.title,
    required this.child,
    required this.width,
    required this.borderRadius,
    required this.padding,
    required this.titleContentSpacing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      margin: EdgeInsets.zero,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppFonts.bodyMedium.copyWith(
              color: AppColors.secondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: titleContentSpacing),
          child,
        ],
      ),
    );
  }
}
