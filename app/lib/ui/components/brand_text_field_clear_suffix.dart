import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery_delivery/ui/theme/brand_colors.dart';

class BrandTextFieldClearSuffix extends StatelessWidget {
  const BrandTextFieldClearSuffix({
    required this.visible,
    required this.onTap,
  });

  final bool visible;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      alignment: Alignment.center,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: visible
            ? InkWell(
                splashFactory: NoSplash.splashFactory,
                highlightColor: BrandColors.fillTertiary,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                onTap: onTap,
                child: const Align(
                  alignment: Alignment.bottomCenter,
                  child: Center(
                    child: Icon(
                      CupertinoIcons.clear_circled_solid,
                      color: BrandColors.textSecondary,
                      size: 20,
                    ),
                  ),
                ),
              )
            : null,
      ),
    );
  }
}
