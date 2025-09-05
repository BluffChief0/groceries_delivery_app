import 'package:cubit_form/cubit_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:grocery_delivery/logic/bloc/cart_cubit.dart';
import 'package:grocery_delivery/logic/models/product.dart';
import 'package:grocery_delivery/ui/components/brand_divider.dart';
import 'package:grocery_delivery/ui/components/brand_network_image.dart';
import 'package:grocery_delivery/ui/theme/brand_colors.dart';
import 'package:grocery_delivery/ui/theme/brand_typography.dart';

class ProductCardCart extends StatelessWidget {
  const ProductCardCart({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        '/product',
        arguments: product,
      ),
      child: Column(
        children: [
          const SizedBox(height: 8),
          Row(
            children: [
              const SizedBox(width: 16),
              BrandNetworkImage(
                src: product.imageUrl,
                borderRadius: BorderRadius.circular(8),
                width: 50,
                height: 50,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: BrandTypography.subheadline,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          '${product.price.toInt()} ₽',
                          style: BrandTypography.footnote,
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 4,
                            horizontal: 8,
                          ),
                          decoration: BoxDecoration(
                            color: BrandColors.fillTertiary,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: BlocBuilder<CartCubit, Map<Product, int>>(
                            builder: (context, state) {
                              return Row(
                                spacing: 10,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
            ],
          ),
          const SizedBox(height: 16),
          const BrandDivider(),
        ],
      ),
    );
  }
}
