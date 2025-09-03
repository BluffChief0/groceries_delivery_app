import 'package:cubit_form/cubit_form.dart';
import 'package:flutter/material.dart';
import 'package:grocery_delivery/logic/bloc/categories/categories_cubit.dart';
import 'package:grocery_delivery/ui/components/category_card.dart';
import 'package:grocery_delivery/ui/components/search.dart';

class CatalogScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Каталог')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Search(
              hintText: 'Поиск категорий',
              onChanged: BlocProvider.of<CategoriesCubit>(context).searchCategories,
            ),
          ),
          Expanded(
            child: BlocBuilder<CategoriesCubit, CategoriesState>(
              builder: (context, state) {
                if (state is! CategoriesLoaded) {
                  return const Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                  itemCount: state.categories.length,
                  itemBuilder: (context, index) {
                    final category = state.categories[index];

                    return CategoryCard(category: category);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
