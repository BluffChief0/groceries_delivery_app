import 'package:cubit_form/cubit_form.dart';
import 'package:equatable/equatable.dart';
import 'package:grocery_delivery/logic/api/api.dart';
import 'package:grocery_delivery/logic/models/category.dart';
import 'package:grocery_delivery/logic/models/product.dart';

part 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  ProductsCubit() : super(ProductsInitial());
  List<Product> products = [];

  Future<void> getAllProducts() async {
    emit(ProductsLoading());
    products = await ApiService.fetchAllProducts();
    emit(ProductsLoaded(products: products));
  }

  Future<void> fetchProductsByCategory(Category category) async {
    if (products.isEmpty) {
      emit(ProductsLoading());
      products = await ApiService.fetchAllProducts();
    }
    final categoryProducts = products.where((item) => item.categoryId == category.id).toList();
    emit(ProductsLoaded(products: [...categoryProducts]));
  }
}
