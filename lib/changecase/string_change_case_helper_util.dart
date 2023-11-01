import 'package:change_case/change_case.dart';
import 'package:flutter_utils_juni1289/apputil/enums_util_helper.dart';
import 'package:flutter_utils_juni1289/exceptions/string_change_case_exception.dart';

class StringChangeCaseHelperUtil {
  /// private constructor
  StringChangeCaseHelperUtil._();

  /// the one and only instance of this singleton
  static final instance = StringChangeCaseHelperUtil._();

  ///to change the String case
  ///[givenString] is required and must not be empty
  ///[StringChangeCaseEnums] is required, determines the type of change case that needs to changed
  String changeCase({required String givenString, required StringChangeCaseEnums stringChangeCaseEnum}) {
    if (givenString.isNotEmpty) {
      if (stringChangeCaseEnum == StringChangeCaseEnums.title) {
        return givenString.toTitleCase();
      } else if (stringChangeCaseEnum == StringChangeCaseEnums.camel) {
        return givenString.toCamelCase();
      } else if (stringChangeCaseEnum == StringChangeCaseEnums.constant) {
        return givenString.toConstantCase();
      } else if (stringChangeCaseEnum == StringChangeCaseEnums.dot) {
        return givenString.toDotCase();
      } else if (stringChangeCaseEnum == StringChangeCaseEnums.kebab) {
        return givenString.toKebabCase();
      } else if (stringChangeCaseEnum == StringChangeCaseEnums.lowerFirst) {
        return givenString.toLowerFirstCase();
      } else if (stringChangeCaseEnum == StringChangeCaseEnums.no) {
        return givenString.toNoCase();
      } else if (stringChangeCaseEnum == StringChangeCaseEnums.pascal) {
        return givenString.toPascalCase();
      } else if (stringChangeCaseEnum == StringChangeCaseEnums.path) {
        return givenString.toPathCase();
      } else if (stringChangeCaseEnum == StringChangeCaseEnums.sentence) {
        return givenString.toSentenceCase();
      } else if (stringChangeCaseEnum == StringChangeCaseEnums.snake) {
        return givenString.toSnakeCase();
      } else if (stringChangeCaseEnum == StringChangeCaseEnums.swap) {
        return givenString.toSwapCase();
      } else if (stringChangeCaseEnum == StringChangeCaseEnums.upperFirst) {
        return givenString.toUpperCase();
      } else if (stringChangeCaseEnum == StringChangeCaseEnums.capital) {
        return givenString.toCapitalCase();
      } else if (stringChangeCaseEnum == StringChangeCaseEnums.header) {
        return givenString.toHeaderCase();
      } else if (stringChangeCaseEnum == StringChangeCaseEnums.sponge) {
        return givenString.toSpongeCase();
      } else {
        return givenString;
      }
    }

    throw StringChangeCaseException(cause: "The given string is empty");
  }
}
