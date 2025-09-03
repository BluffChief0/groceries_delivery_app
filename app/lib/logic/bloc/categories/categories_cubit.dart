import 'package:cubit_form/cubit_form.dart';
import 'package:equatable/equatable.dart';
import 'package:grocery_delivery/logic/api/api.dart';
import 'package:grocery_delivery/logic/models/category.dart';

part 'categories_state.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  CategoriesCubit() : super(CategoriesInitial());
  List<Category> categories = [];

  Future<void> getAllCategories() async {
    emit(CategoriesLoading());
    categories = await ApiService.fetchCategories();
    emit(CategoriesLoaded(categories: categories));
  }

  void searchCategories(String search) {
    final searchedCategories = categories
        .where((category) => category.name.toLowerCase().contains(search.toLowerCase()))
        .toList();
    emit(CategoriesLoaded(categories: searchedCategories));
  }
}
