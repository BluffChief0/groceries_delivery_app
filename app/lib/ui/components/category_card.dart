import 'package:flutter/material.dart';
import 'package:grocery_delivery/logic/models/category.dart';
import 'package:grocery_delivery/ui/components/brand_network_image.dart';
import 'package:grocery_delivery/ui/theme/brand_colors.dart';
import 'package:grocery_delivery/ui/theme/brand_typography.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({required this.category});
  final Category category;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        '/category',
        arguments: category,
      ),
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.fromLTRB(16, 4, 16, 4),
        decoration: BoxDecoration(
          //boxShadow: BrandShadows.projectCard,
          color: BrandColors.fillTertiary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            BrandNetworkImage(
              src: category.imageUrl,
              width: 30,
              height: 30,
            ),
            const SizedBox(width: 16),
            Text(
              category.name,
              style: BrandTypography.body,
            ),
          ],
        ),
      ),
    );
  }
}
