import 'package:flutter/material.dart';
import 'package:flutter_utils_juni1289/widgets/lists/menu/list_child_item_widget.dart';
import 'package:flutter_utils_juni1289/widgets/lists/models/simple_menu_list_widget_helper_model.dart';

class SimpleMenuListWidget extends StatelessWidget {
  final List<SimpleMenuListWidgetHelperModel> simpleMenuListHelperModelList;

  final double? leftIconHeight;
  final double? leftIconWidth;
  final TextStyle? middleTitleTextStyle;
  final TextStyle? detailTextBelowMiddleTextStyle;
  final double? rightIconHeight;
  final double? rightIconWidth;
  final Color? backgroundColor;
  final EdgeInsetsDirectional? padding;
  final EdgeInsetsDirectional? margin;
  final BorderRadius? borderRadius;
  final double? marginBetweenTexts;
  final String placeHolderImagePathLocal;
  final EdgeInsetsDirectional? rightIconMargin;
  final EdgeInsetsDirectional? leftIconMargin;
  final Widget? separatorWidget;
  final bool? shrinkWrap;
  final ScrollPhysics? physics;
  final OnListItemClickedCallback? onListItemClickedCallback;

  const SimpleMenuListWidget(
      {super.key,
      this.onListItemClickedCallback,
      this.physics,
      this.shrinkWrap,
      this.separatorWidget,
      required this.simpleMenuListHelperModelList,
      this.leftIconMargin,
      this.rightIconMargin,
      required this.placeHolderImagePathLocal,
      this.marginBetweenTexts,
      this.borderRadius,
      this.leftIconHeight,
      this.leftIconWidth,
      this.middleTitleTextStyle,
      this.detailTextBelowMiddleTextStyle,
      this.rightIconHeight,
      this.rightIconWidth,
      this.backgroundColor,
      this.padding,
      this.margin});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        shrinkWrap: shrinkWrap ?? true,
        physics: physics ?? const AlwaysScrollableScrollPhysics(),
        itemBuilder: (BuildContext itemBuilderContext, int itemIndex) {
          return ListChildItemWidget(
              onListItemClickedCallback: onListItemClickedCallback,
              itemIndex: itemIndex,
              marginBetweenTexts: marginBetweenTexts ?? 8,
              borderRadius: borderRadius ?? BorderRadius.all(Radius.circular(8)),
              rightIconMargin: rightIconMargin ?? EdgeInsetsDirectional.all(8),
              leftIconPath: simpleMenuListHelperModelList[itemIndex].leftIconPath ?? placeHolderImagePathLocal,
              leftIconHeight: leftIconHeight ?? 24,
              leftIconWidth: leftIconWidth ?? 24,
              middleTitleText: simpleMenuListHelperModelList[itemIndex].middleTitleText ?? "",
              middleTitleTextStyle: middleTitleTextStyle ?? TextStyle(fontSize: 12, color: Colors.black),
              detailTextBelowMiddleTitle: simpleMenuListHelperModelList[itemIndex].detailTextBelowMiddleTitle ?? "",
              detailTextBelowMiddleTextStyle: detailTextBelowMiddleTextStyle ?? TextStyle(fontSize: 12, color: Colors.black),
              rightIconPath: simpleMenuListHelperModelList[itemIndex].rightIconPath ?? placeHolderImagePathLocal,
              rightIconHeight: rightIconHeight ?? 24,
              rightIconWidth: rightIconWidth ?? 24,
              backgroundColor: backgroundColor ?? Colors.transparent,
              placeHolderImagePathLocal: placeHolderImagePathLocal,
              padding: padding ?? EdgeInsetsDirectional.all(8),
              leftIconMargin: leftIconMargin ?? EdgeInsetsDirectional.all(8),
              isNetworkImage: simpleMenuListHelperModelList[itemIndex].isNetworkImage ?? false,
              margin: margin ?? EdgeInsetsDirectional.all(8));
        },
        separatorBuilder: (BuildContext separatorContext, int itemIndex) {
          return separatorWidget ??
              SizedBox(
                height: 16,
                width: 0,
              );
        },
        itemCount: simpleMenuListHelperModelList.length);
  }
}
