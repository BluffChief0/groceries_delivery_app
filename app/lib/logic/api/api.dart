import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:grocery_delivery/logic/api/api_client.dart';
import 'package:grocery_delivery/logic/models/category.dart';
import 'package:grocery_delivery/logic/models/order_request.dart';
import 'package:grocery_delivery/logic/models/product.dart';
import 'package:grocery_delivery/logic/models/user.dart';
import 'package:talker/talker.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';

class ApiService {
  static Dio getClient() {
    final options = BaseOptions(
      baseUrl: baseUrl,
      receiveTimeout: const Duration(seconds: 30),
    );
    final dio = Dio(options);
    dio.interceptors.add(
      TalkerDioLogger(
        talker: Talker(
          settings: TalkerSettings(
            enabled: true,
            maxHistoryItems: 100000,
            useConsoleLogs: true,
            useHistory: true,
          ),
          filter: CustomTalkerFilter(),
          logger: TalkerLogger(
            output: (String message) {
              final StringBuffer buffer = StringBuffer();
              final lines = message.split('\n');
              lines.forEach(buffer.writeln);
              Platform.isIOS ? lines.forEach(print) : log(buffer.toString());
            },
          ),
        ),
        settings: const TalkerDioLoggerSettings(
          printResponseData: true,
          printRequestData: true,
          printResponseHeaders: true,
          printRequestHeaders: true,
          printResponseMessage: true,
        ),
      ),
    );
    return dio;
  }

  static Future<List<Product>> fetchAllProducts() async {
    final client = getClient();
    final res = await client.get('/products');
    final products = Product.parseListFromJson(res.data);

    return products;
  }

  static Future<List<Category>> fetchCategories() async {
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

  static Future<bool> createOrder(OrderRequest order) async {
    final client = getClient();
    final res = await client.post(
      '/orders/orders/',
      data: order.toJson(),
    );
    if (res.statusCode == 200) {
      return true;
    }
    return false;
  }

  static Future<User?> authenticate(String emailOrPhone) async {
    await Future.delayed(const Duration(seconds: 1));
    if (emailOrPhone.isNotEmpty) {
      return User(emailOrPhone: emailOrPhone, name: 'Пользователь');
    }
    return null;
  }
}

class CustomTalkerFilter extends TalkerFilter {
  static const List<String> ignoredMessages = [];

  @override
  bool filter(TalkerData item) => !ignoredMessages.any((e) => item.message?.contains(e) == true);
}
