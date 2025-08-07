import 'package:cubit_form/cubit_form.dart';
import 'package:flutter/material.dart';
import 'package:grocery_delivery/logic/bloc/catalog_cubit.dart';
import 'package:grocery_delivery/logic/models/category.dart';
import 'package:grocery_delivery/logic/models/product.dart';
import 'package:grocery_delivery/ui/components/product_card.dart';

class CategoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final category = ModalRoute.of(context)!.settings.arguments as Category;
    context.read<CatalogCubit>().fetchProductsByCategory(category);

    return Scaffold(
      appBar: AppBar(title: Text(category.name)),
      body: BlocBuilder<CatalogCubit, List<Product>>(
        builder: (context, products) {
          if (products.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          final cardWidth = MediaQuery.sizeOf(context).width / 2 - 16;
          return GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: cardWidth / (cardWidth + 123),
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
            children: products
                .map((product) => ProductCard(product: product))
                .toList(),
          );
        },
      ),
    );
  }
}
