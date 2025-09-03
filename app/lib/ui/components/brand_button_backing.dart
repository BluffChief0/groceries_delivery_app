import 'package:flutter/material.dart';
import 'package:grocery_delivery/ui/theme/brand_colors.dart';

class BrandButtonBacking extends StatelessWidget {
  const BrandButtonBacking({
    required this.child,
    this.topSpacer,
    this.bottomSpacer,
    this.useDivider = true,
    this.padding,
    this.boxShadow,
    this.color = BrandColors.white,
    super.key,
  });

  final Widget child;
  final Widget? topSpacer;
  final Widget? bottomSpacer;
  final bool useDivider;
  final EdgeInsets? padding;
  final List<BoxShadow>? boxShadow;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          border: useDivider
              ? const Border(
                  top: BorderSide(
                    width: 0.5,
                    color: BrandColors.grey,
                  ),
                )
              : null,
          boxShadow: boxShadow,
          color: color,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            topSpacer ?? const SizedBox(height: 10),
            Container(
              color: color,
              child: child,
            ),
            bottomSpacer ??
                SizedBox(
                  height: MediaQuery.paddingOf(context).bottom +
                      (MediaQuery.paddingOf(context).bottom != 0 ? 8 : 16),
                ),
          ],
        ),
      ),
    );
  }
}
