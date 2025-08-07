import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery_delivery/ui/components/brand_skeleton.dart';
import 'package:grocery_delivery/ui/theme/brand_colors.dart';

class BrandNetworkImage extends StatelessWidget {
  const BrandNetworkImage({
    required this.src,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.center,
    this.width = double.infinity,
    this.height = double.infinity,
    this.borderRadius,
    this.errorIconSize = 24,
    this.scale = 1,
    this.color,
    this.cacheHeight,
    this.cacheWidth,
    this.bgColor = Colors.transparent,
    this.withContainer = true,
    this.isCircle = false,
    this.showDummyImageOnError = false,
    this.skeletonBaseColor,
    this.skeletonHighlightColor,
    this.isSocialNetworkPicture = false,
    this.isBlackIcon = false,
  });

  final String? src;
  final BoxFit fit;
  final Alignment alignment;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final double errorIconSize;
  final double scale;
  final Color bgColor;
  final int? cacheHeight;
  final int? cacheWidth;

  final Color? color;
  final bool withContainer;
  final bool isCircle;
  final bool showDummyImageOnError;
  final Color? skeletonBaseColor;
  final Color? skeletonHighlightColor;
  final bool isSocialNetworkPicture;
  final bool isBlackIcon;

  Widget get _errorWidget {
    return Container(
      width: width,
      height: height,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
        color: BrandColors.errorLight,
        borderRadius: isCircle ? null : borderRadius,
      ),
      child: Icon(
        Icons.image_not_supported_outlined,
        color: BrandColors.error,
        size: errorIconSize,
      ),
    );
  }

  Widget get _altErrorWidget {
    return Container(
      width: width ?? 40,
      height: height ?? 40,
      decoration: BoxDecoration(
        color: BrandColors.accent,
        shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: isCircle ? null : borderRadius,
      ),
      child: Center(
        child: Icon(
          CupertinoIcons.bubble_left,
          color: BrandColors.white,
          size: errorIconSize,
        ),
      ),
    );
  }

  Widget get _blackSocialNetworkIcon {
    return Container(
      width: width ?? 40,
      height: height ?? 40,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: BrandColors.totalBlack,
      ),
      child: Center(
        child: Icon(
          CupertinoIcons.bubble_left_fill,
          color: BrandColors.white,
          size: (width ?? 40) / 3,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (withContainer) {
      if (src?.trim().isEmpty ?? true) {
        return Container(
          width: width,
          height: height,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
            color: bgColor,
            borderRadius: isCircle ? null : borderRadius,
          ),
          child: isBlackIcon
              ? _blackSocialNetworkIcon
              : isSocialNetworkPicture
                  ? _altErrorWidget
                  : _errorWidget,
        );
      } else {
        return SizedBox(
          width: width,
          height: height,
          child: CachedNetworkImage(
            imageUrl: src!,
            color: color,
            imageBuilder: (context, imageProvider) {
              if (cacheWidth != null || cacheHeight != null) {
                imageProvider = ResizeImage(
                  imageProvider,
                  width: cacheWidth == null
                      ? null
                      : cacheWidth! *
                          MediaQuery.devicePixelRatioOf(context).round(),
                  height: cacheHeight == null
                      ? null
                      : cacheHeight! *
                          MediaQuery.devicePixelRatioOf(context).round(),
                );
              }

              return Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageProvider,
                    fit: fit,
                    alignment: alignment,
                  ),
                  shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
                  color: bgColor,
                  borderRadius: isCircle ? null : borderRadius,
                ),
              );
            },
            fit: fit,
            alignment: alignment,
            memCacheHeight: cacheHeight == null
                ? null
                : cacheHeight! * MediaQuery.devicePixelRatioOf(context).round(),
            memCacheWidth: cacheWidth == null
                ? null
                : cacheWidth! * MediaQuery.devicePixelRatioOf(context).round(),
            placeholder: (context, url) => Container(
              width: width,
              height: height,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
                color: bgColor,
                borderRadius: isCircle ? null : borderRadius,
              ),
              child: BrandSkeleton(
                Container(color: skeletonBaseColor ?? Colors.white),
                baseColor: skeletonBaseColor,
                highlightColor: skeletonHighlightColor,
              ),
            ),
            errorWidget: (_, __, ___) => isBlackIcon
                ? _blackSocialNetworkIcon
                : isSocialNetworkPicture
                    ? _altErrorWidget
                    : _errorWidget,
          ),
        );
      }
    } else {
      return ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.zero,
        child: CachedNetworkImage(
          imageUrl: src!,
          color: color,
          width: width,
          height: height,
          fit: fit,
          alignment: alignment,
          memCacheHeight: cacheHeight == null
              ? null
              : cacheHeight! * MediaQuery.devicePixelRatioOf(context).round(),
          memCacheWidth: cacheWidth == null
              ? null
              : cacheWidth! * MediaQuery.devicePixelRatioOf(context).round(),
          placeholder: (context, url) => BrandSkeleton(
            Container(color: skeletonBaseColor ?? Colors.white),
            baseColor: skeletonBaseColor,
            highlightColor: skeletonHighlightColor,
          ),
          errorWidget: (_, __, ___) => isBlackIcon
              ? _blackSocialNetworkIcon
              : isSocialNetworkPicture
                  ? _altErrorWidget
                  : _errorWidget,
        ),
      );
    }
  }
}
