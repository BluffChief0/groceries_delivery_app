import 'package:flutter/rendering.dart';
import 'package:grocery_delivery/ui/theme/brand_colors.dart';

class BrandTypography {
  static const defaultText = TextStyle(
    fontFamily: 'SF UI Text',
    fontSize: 14,
    height: 1.2,
    fontWeight: FontWeight.normal,
    letterSpacing: -0.4,
    color: BrandColors.totalBlack,
  );

  static final h1 = defaultText.copyWith(
    fontSize: 32,
    fontFamily: 'SF UI Display',
    fontWeight: FontWeight.w600,
  );

  static final h2 = defaultText.copyWith(
    fontSize: 20,
    fontFamily: 'SF UI Display',
    fontWeight: FontWeight.w600,
  );

  static final h3 = defaultText.copyWith(
    fontSize: 18,
    fontFamily: 'SF UI Text',
    fontWeight: FontWeight.w600,
  );

  static final h4 = defaultText.copyWith(
    fontSize: 16,
    fontFamily: 'SF UI Text',
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  static final h5 = defaultText.copyWith(
    fontSize: 14,
    fontFamily: 'SF UI Text',
    fontWeight: FontWeight.w500,
  );

  static final h6 = defaultText.copyWith(
    fontSize: 12,
    fontFamily: 'SF UI Text',
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  static final pageTitle = defaultText.copyWith(
    fontSize: 22,
    fontFamily: 'SF UI Display',
    fontWeight: FontWeight.w600,
  );

  static final subtitle = defaultText.copyWith(
    fontSize: 18,
    fontFamily: 'SF UI Text',
    fontWeight: FontWeight.w500,
  );

  static final text22 = defaultText.copyWith(
    fontSize: 22,
    fontFamily: 'SF UI Display',
  );

  static final text24 = defaultText.copyWith(
    fontSize: 24,
    fontFamily: 'SF UI Display',
  );

  static final text26 = defaultText.copyWith(
    fontSize: 26,
    fontFamily: 'SF UI Display',
  );

  static final buttonText = bodyBold;

  static final backButtonText =
  defaultText.copyWith(fontSize: 17, fontWeight: FontWeight.w400);

  static final tableTitle = text16.copyWith(
    fontWeight: FontWeight.w600,
    fontFamily: 'SF UI Text',
  );

  static final text18 = defaultText.copyWith(
    fontSize: 18,
    fontFamily: 'SF UI Text',
  );

  static final text17 = defaultText.copyWith(
    fontSize: 17,
    fontFamily: 'SF UI Text',
  );

  static final text16 = defaultText.copyWith(
    fontSize: 16,
    fontFamily: 'SF UI Text',
    height: 1.3,
  );

  static final text15 = defaultText.copyWith(
    fontSize: 15,
    fontFamily: 'SF UI Text',
    height: 1.3,
  );

  static final text13 = defaultText.copyWith(
    fontSize: 13,
    fontFamily: 'SF UI Text',
  );

  static final text12 = defaultText.copyWith(
    fontSize: 12,
    fontFamily: 'SF UI Text',
  );

  static final text11 = defaultText.copyWith(
    fontSize: 11,
    fontFamily: 'SF UI Text',
  );

  static final text10 = defaultText.copyWith(
    fontSize: 10,
    fontFamily: 'SF UI Text',
  );

  static final text20 = defaultText.copyWith(
    fontWeight: FontWeight.w600,
    fontSize: 20,
    height: 24 / 20,
    fontFamily: 'SF UI Display',
  );

  static final text7 = defaultText.copyWith(
    fontSize: 7.2,
    fontFamily: 'SF UI Text',
  );

  static final text28 = defaultText.copyWith(
    fontSize: 28,
    fontFamily: 'SF UI Display',
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  static final text30 = defaultText.copyWith(
    fontSize: 30,
    fontFamily: 'SF UI Display',
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  static final text32 = defaultText.copyWith(
    fontSize: 32,
    fontFamily: 'SF UI Display',
    fontWeight: FontWeight.w600,
  );

  static final text34 = defaultText.copyWith(
    fontSize: 34,
    fontFamily: 'SF UI Display',
    fontWeight: FontWeight.w600,
  );

  //

  static const baseNormal = TextStyle(
    fontFamily: 'SF UI Text',
    fontSize: 14,
    height: 1.2,
    fontWeight: FontWeight.normal,
    color: BrandColors.totalBlack,
  );

  static const baseBig = TextStyle(
    fontFamily: 'SF UI Display',
    fontSize: 14,
    height: 1.2,
    fontWeight: FontWeight.normal,
    color: BrandColors.totalBlack,
  );

  // buttons

  static final buttonTextNew = baseNormal.copyWith(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    height: 1,
    letterSpacing: -0.41,
  );

  // headers
  static final largeTitle = baseBig.copyWith(
    fontSize: 30,
    letterSpacing: 0.4,
  );
  static final largeTitleBold = largeTitle.copyWith(
    fontWeight: FontWeight.w600,
  );

  static final largeTitle34 = baseBig.copyWith(
    fontSize: 34,
    letterSpacing: 0.4,
  );
  static final largeTitle34Bold = largeTitle34.copyWith(
    fontWeight: FontWeight.w600,
  );

  static final titleBig = baseBig.copyWith(
    fontSize: 26,
    height: 32 / 26,
    letterSpacing: 0.22,
  );
  static final titleBigBold = titleBig.copyWith(
    fontWeight: FontWeight.w600,
  );

  static final titleMedium = baseBig.copyWith(
    fontSize: 22,
    height: 28 / 22,
    letterSpacing: -0.26,
  );
  static final titleMediumBold = titleMedium.copyWith(
    fontWeight: FontWeight.w600,
  );

  static final titleSmall = baseBig.copyWith(
    fontSize: 20,
    letterSpacing: -0.45,
  );
  static final titleSmallBold = titleSmall.copyWith(
    fontWeight: FontWeight.w600,
  );

  // headline
  static final headline = baseNormal.copyWith(
    fontSize: 17,
    height: 22 / 17,
    letterSpacing: -0.43,
  );
  static final headlineBold = headline.copyWith(
    fontWeight: FontWeight.w600,
  );

  // body
  static final body = baseNormal.copyWith(
    fontSize: 17,
    height: 22 / 17,
    letterSpacing: -0.43,
  );
  static final bodyBold = body.copyWith(
    fontWeight: FontWeight.w600,
  );
  static final bodyItalic = body.copyWith(
    fontStyle: FontStyle.italic,
  );
  static final bodyItalicBold = bodyItalic.copyWith(
    fontWeight: FontWeight.w600,
  );

  // callout
  static final callout = baseNormal.copyWith(
    fontSize: 16,
    height: 22 / 16,
    letterSpacing: -0.31,
  );
  static final calloutBold = callout.copyWith(
    fontWeight: FontWeight.w600,
  );
  static final calloutItalic = callout.copyWith(
    fontStyle: FontStyle.italic,
  );
  static final calloutItalicBold = calloutItalic.copyWith(
    fontWeight: FontWeight.w600,
  );

  // subheadline
  static final subheadline = baseNormal.copyWith(
    fontSize: 15,
    letterSpacing: -0.23,
  );
  static final subheadlineBold = subheadline.copyWith(
    fontWeight: FontWeight.w600,
  );
  static final subheadlineItalic = subheadline.copyWith(
    fontStyle: FontStyle.italic,
  );
  static final subheadlineItalicBold = subheadlineItalic.copyWith(
    fontWeight: FontWeight.w600,
  );

  // footnote
  static final footnote = baseNormal.copyWith(
    fontSize: 13,
    height: 18 / 13,
    letterSpacing: -0.08,
  );
  static final footnoteBold = footnote.copyWith(
    fontWeight: FontWeight.w600,
  );
  static final footnoteItalic = footnote.copyWith(
    fontStyle: FontStyle.italic,
  );
  static final footnoteItalicBold = footnoteItalic.copyWith(
    fontWeight: FontWeight.w600,
  );

  // caption
  static final caption = baseNormal.copyWith(
    fontSize: 12,
    height: 16 / 12,
  );
  static final captionBold = caption.copyWith(
    fontWeight: FontWeight.w600,
  );
  static final captionItalic = caption.copyWith(
    fontStyle: FontStyle.italic,
  );
  static final captionItalicBold = captionItalic.copyWith(
    fontWeight: FontWeight.w600,
  );

  static final captionSmall = baseNormal.copyWith(
    fontSize: 11,
    height: 13 / 11,
    letterSpacing: 0.06,
  );
  static final captionSmallBold = captionSmall.copyWith(
    fontWeight: FontWeight.w600,
  );
  static final captionSmallItalic = captionSmall.copyWith(
    fontStyle: FontStyle.italic,
  );
  static final captionSmallItalicBold = captionSmallItalic.copyWith(
    fontWeight: FontWeight.w600,
  );
}