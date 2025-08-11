import 'package:dio/dio.dart';
import 'package:grocery_delivery/logic/api/api_client.dart';
import 'package:grocery_delivery/logic/models/category.dart';
import 'package:grocery_delivery/logic/models/product.dart';
import 'package:grocery_delivery/logic/models/user.dart';

class MockApiService {
  Dio getClient() {
    final options = BaseOptions(
      baseUrl: baseUrl,
      receiveTimeout: const Duration(seconds: 30),
    );
    final dio = Dio(options);
    return dio;
  }

  Future<List<Product>> fetchProductsByCategory(Category category) async {
    final client = getClient();
    final res = await client.get('/products');
    final products = Product.parseListFromJson(res.data);

    return products.where((item) => item.categoryId == category.id).toList();
  }

  Future<List<Category>> fetchCategories() async {
    try {
      final client = getClient();
      final res = await client.get('/categories');
      final categories = Category.parseListFromJson(res.data);

      return categories;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<User?> authenticate(String emailOrPhone) async {
    await Future.delayed(const Duration(seconds: 1));
    if (emailOrPhone.isNotEmpty) {
      return User(emailOrPhone: emailOrPhone, name: 'Пользователь');
    }
    return null;
  }
}
