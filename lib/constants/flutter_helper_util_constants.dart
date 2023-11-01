///regex constraints, they have their default values for the case
///if the firebase remote configs won't be available for some reason
class HelperUtilRegexConstants {
  ///regex to allow only numeric chars in the field
  static const String allowOnlyNumbersRegex = "[0-9]?";

  ///regex to allow only Alphabets in the field
  static const String allowOnlyLetters = "[A-Z a-z]";

  ///regex for alpha-numeric chars only
  static String alphaNumericOnly = "[0-9a-zA-Z]";

  ///regex for amount field with decimal
  static const String amountFieldRegexWithDecimal = "[0-9 .A-Z a-z]";

  ///regex for amount field without decimal
  static const String amountFieldRegexWithoutDecimal = "[0-9 A-Z a-z]";

  ///regex for field where the first character should not be an empty space
  static const String firstCharacterShouldNotBeASpace = "\\s{2,}";
}
