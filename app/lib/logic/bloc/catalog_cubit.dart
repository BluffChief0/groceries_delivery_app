import 'package:cubit_form/cubit_form.dart';
import 'package:grocery_delivery/logic/api/api.dart';
import 'package:grocery_delivery/logic/models/category.dart';
import 'package:grocery_delivery/logic/models/product.dart';

class CatalogCubit extends Cubit<List<Product>> {
  CatalogCubit(this.apiService) : super([]);
  final MockApiService apiService;

  Future<void> fetchProductsByCategory(Category category) async {
    emit([]);
    final products = await apiService.fetchProductsByCategory(category);
    emit(products);
  }
}