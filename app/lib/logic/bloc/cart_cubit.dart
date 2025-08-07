import 'package:cubit_form/cubit_form.dart';
import 'package:grocery_delivery/logic/models/product.dart';

class CartCubit extends Cubit<Map<Product, int>> {
  CartCubit() : super({});

  void addToCart(Product product) {
    if (state.containsKey(product)) {
      state[product] = state[product]! + 1;
    } else {
      state[product] = 1;
    }

    emit(Map.from(state));
  }

  void removeFromCart(Product product) {

    if (state[product]! > 1) {
      state[product] = state[product]! - 1;
    } else {
      state.remove(product);
    }
    emit(Map.from(state));
  }
}