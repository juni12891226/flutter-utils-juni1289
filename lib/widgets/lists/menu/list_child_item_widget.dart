import 'package:flutter/material.dart';
import 'package:flutter_utils_juni1289/widgets/image/app_image_widget.dart';

typedef OnListItemClickedCallback = void Function(int itemClickedIndex);

class ListChildItemWidget extends StatelessWidget {
  final int itemIndex;

  final String leftIconPath;
  final double leftIconHeight;
  final double leftIconWidth;
  final String middleTitleText;
  final TextStyle middleTitleTextStyle;
  final String detailTextBelowMiddleTitle;
  final TextStyle detailTextBelowMiddleTextStyle;
  final String rightIconPath;
  final double rightIconHeight;
  final double rightIconWidth;
  final Color backgroundColor;
  final EdgeInsetsDirectional padding;
  final EdgeInsetsDirectional margin;
  final BorderRadius borderRadius;
  final EdgeInsetsDirectional rightIconMargin;
  final EdgeInsetsDirectional leftIconMargin;
  final double marginBetweenTexts;
  final String placeHolderImagePathLocal;
  final bool isNetworkImage;
  final OnListItemClickedCallback? onListItemClickedCallback;

  const ListChildItemWidget(
      {super.key,
      this.onListItemClickedCallback,
      required this.itemIndex,
      required this.leftIconPath,
      required this.borderRadius,
      required this.placeHolderImagePathLocal,
      required this.marginBetweenTexts,
      required this.isNetworkImage,
      required this.middleTitleText,
      required this.middleTitleTextStyle,
      required this.detailTextBelowMiddleTitle,
      required this.detailTextBelowMiddleTextStyle,
      required this.rightIconPath,
      required this.leftIconHeight,
      required this.leftIconWidth,
      required this.rightIconHeight,
      required this.rightIconWidth,
      required this.backgroundColor,
      required this.padding,
      required this.leftIconMargin,
      required this.rightIconMargin,
      required this.margin});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onListItemClickedCallback != null) {
          onListItemClickedCallback!(itemIndex);
        }
      },
      child: Container(
        padding: padding,
        margin: margin,
        decoration: BoxDecoration(color: backgroundColor, borderRadius: borderRadius),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: leftIconMargin,
              child: FlexiblePngSvgNetworkImageWidget(
                networkErrorPlaceHolderImagePath: placeHolderImagePathLocal,
                imagePathOrURL: leftIconPath,
                isNetworkImage: isNetworkImage,
                height: leftIconHeight,
                width: leftIconWidth,
                filterQuality: FilterQuality.high,
                svgLoadRetryLimit: 1,
              ),
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    middleTitleText,
                    style: middleTitleTextStyle,
                  ),
                  Container(
                      margin: EdgeInsetsDirectional.only(top: marginBetweenTexts),
                      child: Text(
                        detailTextBelowMiddleTitle,
                        style: detailTextBelowMiddleTextStyle,
                      ))
                ],
              ),
            ),
            Container(
              margin: rightIconMargin,
              child: FlexiblePngSvgNetworkImageWidget(
                networkErrorPlaceHolderImagePath: placeHolderImagePathLocal,
                imagePathOrURL: leftIconPath,
                isNetworkImage: isNetworkImage,
                height: leftIconHeight,
                width: leftIconWidth,
                filterQuality: FilterQuality.high,
                svgLoadRetryLimit: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
