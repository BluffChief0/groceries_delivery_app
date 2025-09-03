import 'package:cubit_form/cubit_form.dart';
import 'package:flutter/material.dart';
import 'package:grocery_delivery/logic/bloc/cart_cubit.dart';
import 'package:grocery_delivery/logic/models/product.dart';
import 'package:grocery_delivery/ui/components/brand_button.dart';
import 'package:grocery_delivery/ui/components/product_card_cart.dart';
import 'package:grocery_delivery/ui/theme/brand_colors.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Корзина')),
      body: BlocBuilder<CartCubit, Map<Product, int>>(
        builder: (context, cartItems) {
          if (cartItems.isEmpty) {
            return const Center(child: Text('Корзина пуста'));
          }
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(top: 16),
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final product = cartItems.entries.toList()[index].key;
                    return ProductCardCart(product: product);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: BrandButton(
                  onTap: () => Navigator.pushNamed(context, '/checkout'),
                  height: 45,
                  label: 'Оформить заказ на ${BlocProvider.of<CartCubit>(context).totalPrice} ₽',
                  labelColor: BrandColors.white,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
