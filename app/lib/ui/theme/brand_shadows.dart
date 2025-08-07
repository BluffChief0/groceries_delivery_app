import 'package:flutter/material.dart';
import 'package:grocery_delivery/ui/theme/brand_colors.dart';

class BrandShadows {
  static final List<BoxShadow> primary = [
    BoxShadow(
      color: BrandColors.totalBlack.withValues(alpha: 0.01),
      blurRadius: 5,
      offset: const Offset(0, 0),
    ),
    BoxShadow(
      color: BrandColors.totalBlack.withValues(alpha: 0.02),
      blurRadius: 13,
      offset: const Offset(0, 2),
    ),
    BoxShadow(
      color: BrandColors.totalBlack.withValues(alpha: 0.03),
      blurRadius: 35,
      offset: const Offset(0, 6),
    ),
    BoxShadow(
      color: BrandColors.totalBlack.withValues(alpha: 0.04),
      blurRadius: 80,
      offset: const Offset(0, 12),
    ),
  ];

  static final List<BoxShadow> primaryFirstNew = [
    BoxShadow(
      color: BrandColors.totalBlack.withValues(alpha: 0.01),
      blurRadius: 5,
      offset: const Offset(0, 0),
    ),
    BoxShadow(
      color: BrandColors.totalBlack.withValues(alpha: 0.02),
      blurRadius: 13,
      offset: const Offset(0, 2),
    ),
    BoxShadow(
      color: BrandColors.totalBlack.withValues(alpha: 0.03),
      blurRadius: 10,
      offset: const Offset(0, 6),
    ),
    BoxShadow(
      color: BrandColors.totalBlack.withValues(alpha: 0.04),
      blurRadius: 10,
      offset: const Offset(0, 12),
    ),
  ];

  static final List<BoxShadow> contestCard = [
    BoxShadow(
      color: BrandColors.totalBlack.withValues(alpha: 0.04),
      blurRadius: 5,
      offset: const Offset(0, 6),
    ),
  ];

  static final List<BoxShadow> contestBubble = [
    BoxShadow(
      color: const Color(0xFF061540).withValues(alpha: 0.15),
      blurRadius: 20,
      offset: const Offset(0, 4),
    ),
    BoxShadow(
      color: const Color(0xFF061540).withValues(alpha: 0.07),
      blurRadius: 10,
      offset: const Offset(0, 2),
    ),
  ];

  static final List<BoxShadow> accountDetails = [
    BoxShadow(
      color: BrandColors.totalBlack.withValues(alpha: 0.02),
      blurRadius: 10,
      offset: const Offset(0, -10),
    ),
    BoxShadow(
      color: BrandColors.totalBlack.withValues(alpha: 0.07),
      blurRadius: 20,
      offset: const Offset(0, -20),
    ),
  ];

  static final List<BoxShadow> projectCard = [
    BoxShadow(
      color: BrandColors.totalBlack.withValues(alpha: 0.07),
      blurRadius: 10,
      offset: const Offset(0, 0),
    ),
  ];
}