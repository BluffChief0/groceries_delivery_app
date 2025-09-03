import 'package:flutter/material.dart';
import 'package:grocery_delivery/logic/models/category.dart';
import 'package:grocery_delivery/logic/models/product.dart';
import 'package:grocery_delivery/main.dart';
import 'package:grocery_delivery/ui/screens/category_screen.dart';
import 'package:grocery_delivery/ui/screens/checkout_screen.dart';
import 'package:grocery_delivery/ui/screens/product_screen.dart';

class AppRouter {
  static Route buildRoute(
    Widget widget, {
    RouteSettings? settings,
    bool useFadeAnim = false,
  }) {
    if (useFadeAnim) {
      return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => widget,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = 0.0;
          const end = 1.0;
          final tween = Tween(begin: begin, end: end);
          final opacityAnimation = animation.drive(tween);

          return FadeTransition(
            opacity: opacityAnimation,
            child: child,
          );
        },
      );
    }
    return MaterialPageRoute(builder: (context) => widget, settings: settings);
  }

  static Route<dynamic> generateRoute(
    RouteSettings settings,
  ) {
    Route route(
      Widget widget, {
      bool useFadeAnim = false,
    }) =>
        buildRoute(
          widget,
          settings: settings,
          useFadeAnim: useFadeAnim,
        );

    switch (settings.name) {
      case '/':
        return route(MainScreen());
      case '/category':
        return route(
          CategoryScreen(
            category: settings.arguments as Category,
          ),
        );
      case '/checkout':
        return route(CheckoutScreen());
      case '/product':
        return route(
          ProductScreen(
            product: settings.arguments as Product,
          ),
        );
      default:
        return route(MainScreen());
    }
  }
}
