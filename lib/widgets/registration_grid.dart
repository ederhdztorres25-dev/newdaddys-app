import 'package:flutter/material.dart';
import 'package:newdaddys/theme/app_colors.dart';
import 'package:newdaddys/theme/app_fonts.dart';
import 'package:newdaddys/theme/app_sizes.dart';
import 'package:newdaddys/widgets/selection_button.dart';

class RegistrationGrid extends StatelessWidget {
  final List<String> options;
  final Set<String?> selectedOptions;
  final Function(String) onSelect;
  final int itemsPerRow;
  final bool isMultiSelect;
  final double? buttonHeight;

  const RegistrationGrid({
    super.key,
    required this.options,
    required this.selectedOptions,
    required this.onSelect,
    this.itemsPerRow = 3,
    this.isMultiSelect = false,
    this.buttonHeight,
  });

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double spacing = 10.0;
    final double totalPadding = screenWidth * AppSizes.horizontalPadding * 2;
    final double totalSpacing = spacing * (itemsPerRow - 1);
    final double buttonWidth =
        (screenWidth - totalPadding - totalSpacing) / itemsPerRow;
    final double height = buttonHeight ?? screenHeight * (220 / 3120);

    return Wrap(
      spacing: spacing,
      runSpacing: spacing,
      children:
          options.map((option) {
            return SizedBox(
              width: buttonWidth,
              child: SelectionButton(
                text: option,
                isSelected: selectedOptions.contains(option),
                onTap: () {
                  FocusScope.of(context).unfocus();
                  onSelect(option);
                },
                height: height,
              ),
            );
          }).toList(),
    );
  }
}

class RegistrationSingleRowSelection extends StatelessWidget {
  final List<String> options;
  final String? selectedOption;
  final Function(String) onSelect;
  final double? buttonHeight;

  const RegistrationSingleRowSelection({
    super.key,
    required this.options,
    required this.selectedOption,
    required this.onSelect,
    this.buttonHeight,
  });

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double spacing = 10.0;
    final double totalPadding = screenWidth * AppSizes.horizontalPadding * 2;
    final double totalSpacing = spacing * (options.length - 1);
    final double buttonWidth =
        (screenWidth - totalPadding - totalSpacing) / options.length;
    final double height = buttonHeight ?? screenHeight * (220 / 3120);

    return Row(
      children:
          options
              .map((option) {
                return Expanded(
                  child: SelectionButton(
                    text: option,
                    isSelected: selectedOption == option,
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      onSelect(option);
                    },
                    height: height,
                  ),
                );
              })
              .toList()
              .expand((widget) => [widget, SizedBox(width: spacing)])
              .toList()
            ..removeLast(),
    );
  }
}
