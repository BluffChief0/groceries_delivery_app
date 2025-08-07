import 'package:flutter/material.dart';
import 'package:grocery_delivery/ui/theme/brand_colors.dart';
import 'package:shimmer/shimmer.dart';

class BrandSkeleton extends StatelessWidget {
  const BrandSkeleton(
      this.child, {
        this.baseColor,
        this.highlightColor,
        this.margin = EdgeInsets.zero,
      });

  BrandSkeleton.container({
    required double borderRadius,
    required double height,
    this.baseColor,
    this.highlightColor,
    this.margin = EdgeInsets.zero,
  })  : child = Container(
    height: height,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(borderRadius),
      color: Colors.white,
    ),
  ),
        super();

  BrandSkeleton.circle({
    required double size,
    this.baseColor,
    this.highlightColor,
    this.margin = EdgeInsets.zero,
  })  : child = Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(size),
      color: Colors.white,
    ),
  ),
        super();

  BrandSkeleton.square({
    required double size,
    this.baseColor,
    this.highlightColor,
    this.margin = EdgeInsets.zero,
    double borderRadius = 8,
  })  : child = Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(borderRadius),
      color: Colors.white,
    ),
  ),
        super();

  BrandSkeleton.text({
    double width = double.infinity,
    double height = 16,
    this.baseColor,
    this.highlightColor,
    this.margin = EdgeInsets.zero,
  })  : child = Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(6),
      color: Colors.white,
    ),
  ),
        super();

  final Widget child;
  final EdgeInsets margin;
  final Color? baseColor;
  final Color? highlightColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Shimmer.fromColors(
        baseColor: baseColor ?? Colors.grey[200]!,
        highlightColor: highlightColor ?? BrandColors.accentLight,
        child: child,
      ),
    );
  }
}