// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dartx/dartx.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_utils_juni1289/apputil/enums_util_helper.dart';
import 'package:flutter_utils_juni1289/exceptions/base64_format_exception.dart';
import 'package:oktoast/oktoast.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:flutter_utils_juni1289/datetime/date_time_helper_util.dart';
import 'package:flutter_utils_juni1289/exceptions/app_store_launch_url_exception.dart';
import 'package:flutter_utils_juni1289/exceptions/base64_format_exception.dart';
import 'package:flutter_utils_juni1289/exceptions/file_name_extenstion_exception.dart';
import 'package:flutter_utils_juni1289/formatters/field_length_formatter.dart';
import 'package:flutter_utils_juni1289/widgets/misc/empty_container_helper_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class AppHelperUtil {
  /// private constructor
  AppHelperUtil._();

  /// the one and only instance of this singleton
  static final instance = AppHelperUtil._();

  ///To show the log
  ///[logData] is required, to be used for printing the logs
  ///[logKey] is optional and can be used as a unique random string to find the logs
  ///[isReleaseMode] is optional and default is false, if you want to only show the logs for release build
  ///[usePrint] is optional and if true, the print will be used else debugPrint
  ///You can use the [usePrint] if you want to show the logs in the pre-released build for your own logs
  ///But using print is highly not recommended!
  ///Signature ==> void showLog(String logData, {bool? isReleaseMode, String? logKey, bool? usePrint})
  void showLog(String logData, {bool? isReleaseMode, String? logKey, bool? usePrint}) {
    if (isReleaseMode ?? false) {
      if (logKey != null && logKey.isNotEmpty) {
        (usePrint ?? false) ? print("$logKey:::$logData") : debugPrint("$logKey:::$logData");
      } else {
        (usePrint ?? false) ? print("AppUtilHelper:::$logData") : debugPrint("AppUtilHelper:::$logData");
      }
    }
  }

  ///Open System Settings to allow the permissions from the system settings screen
  ///In case when the permissions are permanently denied
  ///[onSystemSettingsClosedCallback] is optional
  ///can be used to get to know when the system settings closed
  ///If after the allowing of permissions
  ///Signature ==> void openSystemSettingsForPermissions({Function? onSystemSettingsClosedCallback})
  void openSystemSettingsForPermissions({Function? onSystemSettingsClosedCallback}) {
    openAppSettings().then((value) {
      if (onSystemSettingsClosedCallback != null) {
        onSystemSettingsClosedCallback();
      }
    });
  }

  ///Hide the keyboard UX point
  ///That is when the user tries to start/perform an action
  ///Signature ==> void hideKeyboard()
  void hideKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  ///Convert the image to the base64
  ///[imagePath] is required and should not be null or empty
  ///The returned result can be null
  String? getBase64EncodedImageString({required String imagePath}) {
    late String base64;
    if (imagePath.isNotEmpty) {
      File file = File(imagePath);
      Uint8List bytes = file.readAsBytesSync();
      base64 = "data:image/jpg;base64,${base64Encode(bytes)}";
    }
    return base64;
  }

  ///[imageBase64String] is required and should not be null or empty
  ///To get the base64 to image Uint8List data
  ///The returned result can be null
  Uint8List? getBase64DecodedImageBytes({required String imageBase64String}) {
    if (imageBase64String.isNotEmpty) {
      final UriData? base64Data = Uri.parse(imageBase64String).data;
      if (base64Data != null && base64Data.isBase64) {
        return base64Data.contentAsBytes();
      } else {
        throw Base64FormatException(cause: "Given Base64 string is not valid!");
      }
    }
    return null;
  }

  ///extract the numbers from the string
  ///[alphaNumericString] will be like 100 98.22 Ar
  ///The return for example would be 1009822 only numbers
  ///The returned result can be null
  String? extractOnlyNumbersFromString({required String alphaNumericString}) {
    return alphaNumericString.isNotEmpty ? ((alphaNumericString).replaceAll(RegExp(r'\D'), '')) : null;
  }

  ///Space is considered as a character
  ///[alphaNumericString] is required and should not be null or empty
  ///The returned result can be null
  String? extractOnlyCharactersFromString({required String alphaNumericString}) {
    return alphaNumericString.isNotEmpty ? ((alphaNumericString).replaceAll(RegExp(r'[^A-Z a-z]'), '')) : null;
  }

  ///To copy the text to the clip board
  ///[context] is required
  ///[textToCopied] is required to be used for clipboard
  ///[snackBarContentWidget] is optional, to be used to show the snackBar when the text copied to the clipboard
  void copyTextToClipBoard({BuildContext? context, required String textToCopied, Widget? snackBarContentWidget}) {
    Clipboard.setData(ClipboardData(text: textToCopied)).then((_) {
      if (context != null && snackBarContentWidget != null) {
        showSnackBar(context: context, snackBarContentWidget: snackBarContentWidget);
      }
    });
  }

  ///To show the SnackBar
  ///[context] is mandatory
  ///[snackBarContentWidget] is mandatory
  void showSnackBar({required BuildContext context, required Widget snackBarContentWidget}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: snackBarContentWidget));
  }

  ///Show the toast where required
  ///[toastMessageTextWidget] is a mandatory param
  ///[toastTitleTextWidget] optional, to show the title on the toast
  ///[timeInSecondsForDismiss] optional, default is 2 seconds | set the delay for the toast to dismiss
  ///[toastBackgroundColor] optional, default is blue
  ///[toastBorderRadius] optional, default is 16
  ///[toastPadding] optional, default is 20
  ///[toastOuterMargin] optional, default is start and end to 20
  ///[toastTitleTextWidgetMargin] optional, margin below title | between title and message default is 20
  ///[toastPositionEnum] optional, default is bottom
  ///[onToastDismissCallback] optional, to do when the toast dismissed
  void showToast(
      {Widget? toastTitleTextWidget,
      required Widget toastMessageTextWidget,
      int timeInSecondsForDismiss = 2,
      Color? toastBackgroundColor,
      double? toastBorderRadius,
      double? toastPadding,
      EdgeInsetsDirectional? toastOuterMargin,
      EdgeInsetsDirectional? toastTitleTextWidgetMargin,
      ToastPositionEnums? toastPositionEnum,
      Function? onToastDismissCallback}) {
    showToastWidget(
        Container(
            margin: toastOuterMargin ?? const EdgeInsetsDirectional.only(start: 20, end: 20),
            padding: EdgeInsetsDirectional.all(toastPadding ?? 20),
            decoration: BoxDecoration(color: toastBackgroundColor ?? Colors.blue, borderRadius: BorderRadius.all(Radius.circular(toastBorderRadius ?? 16))),
            child: Column(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              toastTitleTextWidget != null
                  ? Container(
                      margin: toastTitleTextWidgetMargin ?? const EdgeInsetsDirectional.only(top: 20),
                      child: Row(mainAxisSize: MainAxisSize.max, children: [Expanded(child: toastTitleTextWidget)]))
                  : const EmptyContainerHelperWidget(),
              Row(mainAxisSize: MainAxisSize.max, children: [Expanded(child: toastMessageTextWidget)])
            ])),
        duration: Duration(seconds: timeInSecondsForDismiss), onDismiss: () {
      if (onToastDismissCallback != null) {
        onToastDismissCallback();
      }
    }, position: _getToastPosition(toastPositionEnum));
  }

  ///get the toast position based on local enums util
  ToastPosition _getToastPosition(ToastPositionEnums? toastPositionEnum) {
    if (toastPositionEnum != null) {
      if (toastPositionEnum == ToastPositionEnums.top) {
        return ToastPosition.top;
      } else if (toastPositionEnum == ToastPositionEnums.center) {
        return ToastPosition.center;
      } else if (toastPositionEnum == ToastPositionEnums.bottom) {
        return ToastPosition.bottom;
      } else {
        return ToastPosition.bottom;
      }
    }

    return ToastPosition.bottom;
  }

  ///get the random number
  ///[isDoubleValueRequired] is optional and default is false, if double value is required
  ///[maxRange] is optional and default is 9999
  String getRandomNumber({bool isDoubleValueRequired = false, int maxRange = 9999}) {
    int range = maxRange;
    Random random = Random();

    String randomNoString = "0";
    if (isDoubleValueRequired) {
      randomNoString = ((((random.nextDouble() / random.nextDouble()) * random.nextDouble()) / random.nextDouble() * random.nextDouble()).toString()).replaceAll(".", "");
    } else {
      randomNoString =
          ((((random.nextInt(range) / random.nextInt(range)) * random.nextInt(range)) / random.nextInt(range) * random.nextInt(range)).toString()).replaceAll(".", "");
    }
    return randomNoString;
  }

  /// Get file name for saving the image
  /// [prefix] is required, to be appended in the start of the file name
  /// For example the [prefix] is myfile_ then the file name returned would be myfile_(getFileNameForSaveResult)
  /// [fileExtension] is the extension of the file that needs to saved, default is .png
  String getFileNameForSave({required String prefix, String fileExtension = ".png"}) {
    if (fileExtension.startsWith(".")) {
      return (prefix.isNotEmpty ? prefix : getRandomNumber()) + DateTimeHelperUtil.instance.getCurrentDateTimeForFileName() + fileExtension;
    }
    throw FileNameExtensionException(cause: "The file extension is not correct!");
  }

  ///To launch the app stores based on the platform
  ///[appStoreLink] is required and must not be empty
  void launchAppStores({required String appStoreLink}) {
    if (appStoreLink.isNotEmpty) {
      if (isAndroid()) {
        launchUrl(Uri.parse(appStoreLink));
      } else {
        launchUrl(Uri.parse(appStoreLink));
      }
    } else {
      throw AppStoreLaunchURLException(cause: "App Store link has problem!");
    }
  }

  ///To check if the current platform is Android
  bool isAndroid() {
    return Platform.isAndroid;
  }

  ///To check if the current platform is iOS
  bool isIOS() {
    return Platform.isIOS;
  }

  ///To check if the current build is release build
  bool isReleaseBuild() {
    return kReleaseMode; //when the flutter build needs to be secured
  }

  ///To check if the current platform is iOS
  bool isWeb() {
    return kIsWeb;
  }

  ///convert the string to the json
  dynamic getDecodedJSON({required String responseBody}) {
    return json.decode(responseBody);
  }

  ///convert the json to the string
  String getEncodedJSONString({required dynamic toEncode}) {
    return json.encode(toEncode);
  }

  ///method to check if the render has inflated all the children in widget tree
  void onEnsureWidgetsTreeBindingDoneCallback(VoidCallback callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }

  ///set the length constraint
  ///the maximum number of characters allowed in the text field
  FieldLengthFormatter getLengthLimitingFormatter({required int lengthConstraint}) {
    return FieldLengthFormatter(lengthConstraint);
  }

  ///to make the first char Capital
  ///[givenString] is required and must not be null
  String capitalized({required String givenString}) {
    return givenString.capitalize();
  }

  ///to make the first char small
  ///[givenString] is required and must not be null
  String deCapitalized({required String givenString}) {
    return givenString.decapitalize();
  }

  ///Util method to replace a given string or a list
  ///[givenString] is required and must not be empty from which the replacements needs to be done
  ///[replacementString] is required and must not be empty, the string to be replaced
  ///[toReplace] can be null is a string to replace
  ///[listToReplace] can be null is a list of strings that needs to be replaced in given string by replacementString
  ///[trimLeft] is optional to trim from start
  ///[trimRight] is optional to trim from end
  String replacer({
    bool? trimLeft,
    bool? trimRight,
    required String givenString, required String replacementString, String? toReplace, List<String?>? listToReplace}) {
    //process toReplace string
    String processedString = givenString.isNotEmpty ? givenString : "";
    if (toReplace != null && toReplace.isNotEmpty) {
      processedString = processedString.replaceAll(toReplace, replacementString);
    }

    //process listToReplace
    if (listToReplace != null && listToReplace.isNotEmpty) {
      for (var element in listToReplace) {
        if (element != null && element.isNotEmpty) {
          processedString = processedString.replaceAll(element, replacementString);
        }
      }
    }

    if(trimLeft??false){
      processedString=processedString.trimLeft();
    }

    if(trimRight??false){
      processedString=processedString.trimRight();
    }
    return processedString;
  }

  ///Get the amount string for the BE purpose without the currency symbol
  ///Without the space
  ///Only with the numbers
  String getAmountValueWithoutCurrency({required String givenAmount}) {
    String amount = "0";
    if (givenAmount.isNotEmpty) {
      if (givenAmount.contains(".")) {
        String amountLeftToDecimal = givenAmount.split(".")[0];
        String amountRightToDecimal = givenAmount.split(".")[1];

        String numericAmountLeftToDecimal = extractOnlyNumbersFromString(alphaNumericString: amountLeftToDecimal) ?? amount;
        String numericAmountRightToDecimal = extractOnlyNumbersFromString(alphaNumericString: amountRightToDecimal) ?? amount;

        amount = "$numericAmountLeftToDecimal.$numericAmountRightToDecimal";
      } else {
        amount = extractOnlyNumbersFromString(alphaNumericString: givenAmount) ?? amount;
      }
    }
    return amount;
  }

  ///move the cursor to the next field on textInputAction.next
  void moveCursorToNextField({required BuildContext context}) {
    try {
      FocusScope.of(context).nextFocus();
    } catch (exp) {
      //dafuq
    }
  }

  ///get the amount field keyboard type
  ///this type will only be used for the amount fields
  TextInputType getAmountFieldKeyBoardType() {
    return const TextInputType.numberWithOptions(signed: true, decimal: false);
  }
}
