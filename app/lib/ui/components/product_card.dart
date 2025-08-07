import 'package:cubit_form/cubit_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery_delivery/logic/bloc/cart_cubit.dart';
import 'package:grocery_delivery/logic/models/product.dart';
import 'package:grocery_delivery/ui/components/brand_network_image.dart';
import 'package:grocery_delivery/ui/components/icon_button.dart';
import 'package:grocery_delivery/ui/theme/brand_colors.dart';
import 'package:grocery_delivery/ui/theme/brand_shadows.dart';
import 'package:grocery_delivery/ui/theme/brand_typography.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final imageWidth = MediaQuery.sizeOf(context).width / 2 - 32;
    return BlocBuilder<CartCubit, Map<Product, int>>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: BrandColors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: BrandShadows.projectCard,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Opacity(
                    opacity: state.containsKey(product) ? 0.5 : 1,
                    child: BrandNetworkImage(
                      src: product.imageUrl,
                      width: imageWidth,
                      height: imageWidth,
                    ),
                  ),
                  if (state.containsKey(product))
                    Text(
                      state[product].toString(),
                      style: BrandTypography.titleBigBold.copyWith(color: BrandColors.black70,),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                product.name,
                style: BrandTypography.body,
                maxLines: 1,
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 4,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: BrandColors.systemLink,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  product.amountDescription,
                  style: BrandTypography.footnoteBold.copyWith(
                    color: BrandColors.white,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (!state.containsKey(product))
                Row(
                  children: [
                    Text(
                      '${product.price} ₽',
                      style: BrandTypography.subheadline,
                    ),
                    const Spacer(),
                    BrandIconButton(
                      onTap: () {
                        BlocProvider.of<CartCubit>(context).addToCart(product);
                      },
                      iconData: CupertinoIcons.cart,
                    ),
                  ],
                )
              else
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
                    Text(
                      '${product.price} ₽',
                      style: BrandTypography.subheadline,
                    ),
                    BrandIconButton(
                      onTap: () {
                        BlocProvider.of<CartCubit>(context).addToCart(product);
                      },
                      iconData: CupertinoIcons.plus,
                      color: BrandColors.accent,
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }
}
