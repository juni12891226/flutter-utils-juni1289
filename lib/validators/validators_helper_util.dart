import 'package:dartx/dartx.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_utils_juni1289/apputil/app_util_helper.dart';
import 'package:flutter_utils_juni1289/exceptions/base64_format_exception.dart';
import 'package:string_validator/string_validator.dart';

class ValidatorsHelperUtil {
  /// private constructor
  ValidatorsHelperUtil._();

  /// the one and only instance of this singleton
  static final instance = ValidatorsHelperUtil._();

  ///To check if the text field entering amount values is valid or not
  ///[amountValue] is required
  ///[baseCurrencyString] is optional(can be useful in future) but if not null or empty, will be replaced with voids
  ///then check if the rest amount is numeric or not
  bool isValidAmountValue({required String amountValue, required double allowedMaxAmount, String baseCurrencyString = ""}) {
    bool isValid = false;
    if (amountValue.isNotEmpty) {
      String amountToCheck = AppHelperUtil.instance.getAmountValueWithoutCurrency(givenAmount: amountValue);
      if (isNumeric(stringValue: amountToCheck) && double.tryParse(amountToCheck) != null) {
        double amount = double.tryParse(amountToCheck)!;
        if (amount <= allowedMaxAmount) {
          isValid = true;
        }
      }
    }
    return isValid;
  }

  ///Method to check if the given string only contains
  ///Numbers or decimals
  bool isNumeric({String? stringValue}) {
    if (stringValue != null && stringValue.isNotEmpty) {
      return double.tryParse(stringValue) != null;
    }
    return false;
  }

  ///To check if given String id Double type
  ///[stringToCheck] is required and can be null
  bool isDouble({String? stringToCheck}) {
    return (stringToCheck ?? "").isDouble;
  }

  ///To check if given String id Integer type
  ///[stringToCheck] is required and can be null
  bool isInt({String? stringToCheck}) {
    return (stringToCheck ?? "").isInt;
  }

  /// isNull = null.isNullOrBlank; // true
  /// isEmpty = ''.isNullOrBlank; // true
  /// isBlank = ' '.isNullOrBlank; // true
  /// isLineBreak = '\n'.isNullOrBlank; // true
  /// isFoo = ' foo '.isNullOrBlank; // false
  bool isNullOrBlank({String? givenString}) {
    return givenString.isNullOrBlank;
  }

  ///To check if given email string is valid
  ///[givenEmail] is required
  bool isValidEmail({required String givenEmail}) {
    if (isNullOrBlank(givenString: givenEmail)) {
      return false;
    }
    return EmailValidator.validate(givenEmail);
  }

  ///To check if given url string is valid
  ///[givenUrlString] is required can be null
  bool isValidURL({String? givenUrlString}) {
    return isURL(givenUrlString);
  }

  ///To check if given url string is valid FQDN
  ///[givenUrlString] is required
  bool isValidFQDN({required String givenUrlString}) {
    return isFQDN(givenUrlString);
  }

  ///To check if given string is valid IP
  ///[givenString] is required
  bool isValidIP({required String givenString}) {
    return isIP(givenString);
  }

  ///To check if given string is valid Alphabetic String that is it should only contains alphabets
  ///[givenString] is required
  bool isValidAlphabetsString({required String givenString}) {
    return isAlpha(givenString);
  }

  ///To check if given string is valid Alphanumeric String that is it may contains alphabets and numbers
  ///[givenString] is required
  bool isValidAlphanumericString({required String givenString}) {
    return isAlphanumeric(givenString);
  }

  ///To check if given string is valid base64 String
  ///[givenString] is required
  bool isValidBase64({required String givenString}) {
    try {
      if (givenString.isNotEmpty) {
        final UriData? base64Data = Uri.parse(givenString).data;
        if (base64Data != null && base64Data.isBase64) {
          return true;
        }
      }
    } on Base64FormatException catch (exp) {
      throw Base64FormatException(cause: "Given Base64 format is not valid!");
    }
    return false;
  }

  ///To check if given String is valid hexa-decimal string
  ///[givenString] is required
  bool isValidHexadecimal({required String givenString}) {
    return isHexadecimal(givenString);
  }

  ///To check if the given color string is valid color
  ///[givenColorString] is required
  bool isValidHexColor({required String givenColorString}) {
    return isHexColor(givenColorString);
  }

  ///To check if the given string lies in the length range
  ///[min] is required
  ///[max] is optional
  ///[min] and [max] will do the job to determine if the given string length is under the min - max range!
  bool isValidLengthRange({required String givenString, required int min, int? max}) {
    if (max != null) {
      return isLength(givenString, min, max);
    } else {
      return isLength(givenString, min);
    }
  }

  ///To check if given String is divisible by any number
  ///[givenString] is required
  ///[number] is required to check if string can be multiplied with the number
  bool isStringDivisibleByNumber({required String givenString, required double number}) {
    return isDivisibleBy(givenString, number);
  }

  ///To check if the given string date time is valid date or not
  ///[givenString] is required
  bool isValidDate({required String givenString}) {
    return isDate(givenString);
  }

  ///To check if the given string is valid credit card number or no
  ///[givenString] is required
  bool isValidCreditCardNumber({required String givenString}) {
    return isCreditCard(givenString);
  }

  ///To check if the given string is in the range that is the range contains that string or not
  ///[givenString] is required
  ///[range] is object and should be a collection type range param
  bool isInRange({required String givenString, required Object range}) {
    return isIn(givenString, range);
  }

  ///To Check if the given string is valid JSON
  ///[givenJsonString] is required
  bool isValidJSON({required String givenJsonString}) {
    return isJson(givenJsonString);
  }
}
