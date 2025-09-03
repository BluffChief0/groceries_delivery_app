import 'package:flutter/material.dart';
import 'package:grocery_delivery/ui/theme/brand_colors.dart';
import 'package:grocery_delivery/ui/theme/brand_typography.dart';

class BrandButton extends StatelessWidget {
  const BrandButton({
    required this.onTap,
    this.labelWidget,
    this.buttonColor = BrandColors.accent,
    this.label,
    this.labelColor,
    this.height,
  });
  final VoidCallback onTap;
  final String? label;
  final Widget? labelWidget;
  final Color buttonColor;
  final Color? labelColor;
  final double? height;

  @override
  Widget build(BuildContext context) {
    assert(
      label != null || labelWidget != null,
      'One of label and labelWidget must not be null',
    );

    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: height,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: buttonColor,
              ),
              child: Center(
                child: labelWidget ??
                    Text(
                      label!,
                      style: BrandTypography.bodyBold.copyWith(color: labelColor),
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
