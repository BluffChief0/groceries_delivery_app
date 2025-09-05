import 'package:cubit_form/cubit_form.dart';
import 'package:grocery_delivery/logic/models/product.dart';
import 'package:grocery_delivery/logic/services/storage_service.dart';

class FavouritesCubit extends Cubit<List<String>> {
  FavouritesCubit() : super([]);

  void initFavourites() {
    final favProductsIds = StorageService.getListString(key: StorageConsts.favourites.txt) ?? [];
    emit(favProductsIds);
  }

  void saveFavourites() {
    StorageService.setListString(
      key: StorageConsts.favourites.txt,
      value: state,
    );
  }

  void addToFavourites(Product product) {
    final favourites = state;
    if (favourites.contains(product.id)) {
      favourites.remove(product.id);
    } else {
      favourites.insert(0, product.id);
    }
    emit([...favourites]);
    saveFavourites();
  }

  void clearFavourites() {
    emit([]);
    saveFavourites();
  }
}
