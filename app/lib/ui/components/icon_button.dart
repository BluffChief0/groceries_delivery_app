import 'package:flutter/material.dart';
import 'package:grocery_delivery/ui/theme/brand_colors.dart';

class BrandIconButton extends StatelessWidget {
  const BrandIconButton({
    required this.onTap,
    required this.iconData,
    this.color = BrandColors.accent,
  });
  final VoidCallback onTap;
  final Color color;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 32,
        width: 32,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Icon(
            iconData,
            color: BrandColors.white,
          ),
        ),
      ),
    );
  }
}
