import 'package:cubit_form/cubit_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:grocery_delivery/logic/bloc/cart_cubit.dart';
import 'package:grocery_delivery/logic/models/product.dart';
import 'package:grocery_delivery/ui/components/brand_divider.dart';
import 'package:grocery_delivery/ui/components/brand_network_image.dart';
import 'package:grocery_delivery/ui/components/icon_button.dart';
import 'package:grocery_delivery/ui/theme/brand_colors.dart';
import 'package:grocery_delivery/ui/theme/brand_typography.dart';

class ProductCardCart extends StatelessWidget {
  const ProductCardCart({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8),
        Row(
          children: [
            const SizedBox(width: 16),
            BrandNetworkImage(
              src: product.imageUrl,
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
                        '${product.price} ₽',
                        style: BrandTypography.footnote,
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          BrandIconButton(
                            onTap: () {
                              BlocProvider.of<CartCubit>(context)
                                  .removeFromCart(product);
                            },
                            iconData: CupertinoIcons.minus,
                            color: BrandColors.errorLight,
                          ),
                          //const SizedBox(width: 8),
                          BlocBuilder<CartCubit, Map<Product, int>>(
                            builder: (context, state) {
                              return SizedBox(
                                width: 40,
                                child: Center(
                                  child: Text(
                                    state[product].toString(),
                                    style: BrandTypography.subheadlineBold,
                                  ),
                                ),
                              );
                            },
                          ),
                          //const SizedBox(width: 8),
                          BrandIconButton(
                            onTap: () {
                              BlocProvider.of<CartCubit>(context)
                                  .addToCart(product);
                            },
                            iconData: CupertinoIcons.plus,
                            color: BrandColors.accent,
                          ),
                        ],
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
    );
  }
}
