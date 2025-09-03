import 'package:cubit_form/cubit_form.dart';
import 'package:flutter/material.dart';
import 'package:grocery_delivery/logic/bloc/products/products_cubit.dart';
import 'package:grocery_delivery/logic/models/category.dart';
import 'package:grocery_delivery/ui/components/product_card.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({required this.category, super.key});

  final Category category;
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<ProductsCubit>(context).fetchProductsByCategory(category);

    return Scaffold(
      appBar: AppBar(title: Text(category.name)),
      body: BlocBuilder<ProductsCubit, ProductsState>(
        builder: (context, state) {
          if (state is! ProductsLoaded) {
            return const Center(child: CircularProgressIndicator());
          }
          final cardWidth = MediaQuery.sizeOf(context).width / 2 - 16;
          return GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: cardWidth / (cardWidth + 150),
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            children: state.products.map((product) => ProductCard(product: product)).toList(),
          );
        },
      ),
    );
  }
}
