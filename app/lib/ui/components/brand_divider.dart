import 'package:flutter/material.dart';
import 'package:grocery_delivery/ui/theme/brand_colors.dart';

class BrandDivider extends StatelessWidget {
  const BrandDivider({
    this.margin = EdgeInsets.zero,
    this.height = 0.5,
    this.thickness = 0.5,
    this.color = BrandColors.divider,
  });

  final EdgeInsetsGeometry margin;
  final double height;
  final double thickness;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: Divider(
        height: height,
        thickness: thickness,
        color: color,
      ),
    );
  }
}