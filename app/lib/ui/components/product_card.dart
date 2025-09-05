import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:cubit_form/cubit_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery_delivery/logic/bloc/cart_cubit.dart';
import 'package:grocery_delivery/logic/bloc/favourites_cubit.dart';
import 'package:grocery_delivery/logic/models/product.dart';
import 'package:grocery_delivery/ui/components/brand_network_image.dart';
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
        return GestureDetector(
          onTap: () => Navigator.pushNamed(
            context,
            '/product',
            arguments: product,
          ),
          child: Container(
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
                        style: BrandTypography.titleBigBold.copyWith(
                          color: BrandColors.black70,
                        ),
                      ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: BrandColors.fillTertiary,
                          shape: BoxShape.circle,
                        ),
                        child: LikeButton(product: product),
                      ).blurry(
                        blur: 20,
                        padding: const EdgeInsets.all(4),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '${product.price.toInt()} ₽',
                  style: BrandTypography.titleSmallBold,
                ),
                const SizedBox(height: 8),
                Text(
                  product.name,
                  style: BrandTypography.body,
                  maxLines: 2,
                  textAlign: TextAlign.left,
                ),
                const Spacer(),
                Text(
                  '${product.weight} кг',
                  style: BrandTypography.subheadline.copyWith(
                    color: BrandColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 6),
                if (!state.containsKey(product))
                  InkWell(
                    onTap: () {
                      BlocProvider.of<CartCubit>(context).addToCart(product);
                    },
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: BrandColors.fillTertiary,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Center(
                              child: Text(
                                'Добавить',
                                style: BrandTypography.subheadline,
                              ),
                            ),
                          ),
                        ),
                      ],
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
          ),
        );
      },
    );
  }
}

class LikeButton extends StatefulWidget {
  const LikeButton({required this.product});
  final Product product;

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 200),
    vsync: this,
    value: 1,
  );

  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = BlocProvider.of<FavouritesCubit>(context).state.contains(widget.product.id);
  }

  @override
  void didUpdateWidget(covariant LikeButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.product != widget.product) {
      _isFavorite = BlocProvider.of<FavouritesCubit>(context).state.contains(widget.product.id);
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isFavorite = !_isFavorite;
        });
        BlocProvider.of<FavouritesCubit>(context).addToFavourites(widget.product);
        _controller.reverse().then((value) => _controller.forward());
      },
      child: ScaleTransition(
        scale: Tween<double>(
          begin: 0.7,
          end: 1,
        ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut)),
        child: Icon(
          Icons.favorite,
          size: 20,
          color: _isFavorite ? BrandColors.totalBlack : BrandColors.textTertiary,
        ),
      ),
    );
  }
}
