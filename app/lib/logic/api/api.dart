import 'package:grocery_delivery/logic/models/category.dart';
import 'package:grocery_delivery/logic/models/product.dart';
import 'package:grocery_delivery/logic/models/user.dart';

class MockApiService {
  Future<List<Product>> fetchProductsByCategory(Category category) async {
    await Future.delayed(const Duration(seconds: 1));

    return Product.getMockProducts()
        .where((item) => item.category == category)
        .toList();
  }

  Future<List<Category>> fetchCategories() async {
    await Future.delayed(const Duration(seconds: 1));
    return Category.mockCategories;
  }

  Future<User?> authenticate(String emailOrPhone) async {
    await Future.delayed(const Duration(seconds: 1));
    if (emailOrPhone.isNotEmpty) {
      return User(emailOrPhone: emailOrPhone, name: 'Пользователь');
    }
    return null;
  }
}