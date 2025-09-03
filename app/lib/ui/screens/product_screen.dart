import 'package:cubit_form/cubit_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery_delivery/logic/bloc/cart_cubit.dart';
import 'package:grocery_delivery/logic/models/product.dart';
import 'package:grocery_delivery/ui/components/brand_button_backing.dart';
import 'package:grocery_delivery/ui/components/brand_network_image.dart';
import 'package:grocery_delivery/ui/theme/brand_colors.dart';
import 'package:grocery_delivery/ui/theme/brand_typography.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: Stack(
        children: [
          ListView(
            children: [
              BrandNetworkImage(
                src: product.imageUrl,
                height: MediaQuery.sizeOf(context).width,
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8,
                  children: [
                    Text(
                      product.name,
                      style: BrandTypography.titleSmallBold,
                    ),
                    Text(
                      product.description,
                      style: BrandTypography.body,
                    ),
                    const SizedBox(height: 120),
                  ],
                ),
              ),
            ],
          ),
          BlocBuilder<CartCubit, Map<Product, int>>(
            builder: (context, state) {
              return BrandButtonBacking(
                child: Row(
                  children: [
                    Text(
                      '${product.price.toInt()} ₽',
                      style: BrandTypography.bodyBold,
                    ),
                    const Spacer(),
                    if (!state.containsKey(product))
                      InkWell(
                        onTap: () => BlocProvider.of<CartCubit>(context).addToCart(product),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 12,
                          ),
                          decoration: BoxDecoration(
                            color: BrandColors.fillTertiary,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Center(
                            child: Text(
                              'Купить',
                              style: BrandTypography.subheadline,
                            ),
                          ),
                        ),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 16,
                        ),
                        decoration: BoxDecoration(
                          color: BrandColors.fillTertiary,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          spacing: 12,
                          children: [
                            GestureDetector(
                              onTap: () {
                                BlocProvider.of<CartCubit>(context).removeFromCart(product);
                              },
                              child: const Icon(
                                CupertinoIcons.minus,
                                size: 15,
                              ),
                            ),
                            Text(
                              state[product].toString(),
                              style: BrandTypography.subheadline,
                            ),
                            GestureDetector(
                              onTap: () {
                                BlocProvider.of<CartCubit>(context).addToCart(product);
                              },
                              child: const Icon(
                                CupertinoIcons.plus,
                                size: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
