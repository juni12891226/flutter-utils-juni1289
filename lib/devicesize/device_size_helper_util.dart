import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class DeviceSizeHelperUtil {
  /// private constructor
  DeviceSizeHelperUtil._();

  /// the one and only instance of this singleton
  static final instance = DeviceSizeHelperUtil._();

  ///Get the device height
  ///With bottom and top padding minus from the total height of the device
  ///Which means that the height returned will contain the
  ///Safe area height, top padding and bottom padding height minus from the total height
  ///The kToolBar height will also be minus from the total height of the device
  double getActualDeviceHeight({required BuildContext context}) {
    var mainHeight = MediaQuery.of(context).size.height;

    // Height (without SafeArea)
    var padding = MediaQuery.of(context).viewPadding;
    // Height (without status and toolbar)
    double deviceHeight = (mainHeight - padding.top - kToolbarHeight);

    return deviceHeight;
  }

  ///Get the device width
  double getDeviceWidth({required BuildContext context}) {
    return MediaQuery.of(context).size.width;
  }

  ///Get the given dimen converted according to the device screen size & aspect ratio
  ///Pixels so that for each screen the UI should be render accordingly
  ///[givenDimen] is mandatory and must not be null
  ///If [isConvert] is true, then the conversion will be done accordingly
  ///Else, the [givenDimen] will be returned same as provided!
  ///Bingo!
  double getDeviceSizeConvertedInPixel({required double givenDimen, bool isConvert = true}) {
    if (isConvert) {
      return givenDimen.sp;
    } else {
      return givenDimen + 2 /*scaling factor :)*/;
    }
  }

  ///Get the presets list for the AutoSizeTexts
  ///[maxValue] determines the top value
  ///[minValue] determines the bottom value
  ///[isPixelConversionNeeded] determines whether the screen pixels dimens needed or not
  ///Example
  ///[maxValue] -> 4
  ///[minValue] -> 2
  ///Result will be
  ///[4,3,2]
  ///and with pixel dimens
  ///[4.sp,3.sp,2.sp] something like that but converted in sp (pixels)
  List<double> getAutoSizeTextPresetsList<double>({required int maxValue, required int minValue, bool isPixelConversionNeeded = true}) {
    List<double> presetsList = [];

    for (int i = maxValue; i >= minValue; i--) {
      if (isPixelConversionNeeded) {
        presetsList.add(i.sp as double);
      } else {
        presetsList.add(i as double);
      }
    }
    return presetsList;
  }
}
