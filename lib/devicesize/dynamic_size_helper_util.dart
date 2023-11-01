import 'package:flutter/material.dart';

class DynamicSizeHelperUtil {
  /// private constructor
  DynamicSizeHelperUtil._();

  /// the one and only instance of this singleton
  static final instance = DynamicSizeHelperUtil._();

  ///get the height in percentage
  ///[context] is required
  ///[percentage] is required
  double height({required BuildContext context, required double percentage}) {
    double height = MediaQuery.of(context).size.height;
    return height * percentage;
  }

  ///get the width in percentage
  ///[context] is required
  ///[percentage] is required
  double width({required BuildContext context, required double percentage}) {
    double width = MediaQuery.of(context).size.width;
    return width * percentage;
  }
}
