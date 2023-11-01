import 'package:flutter_utils_juni1289/apputil/enums_util_helper.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class NumberFieldInputFormatterHelperUtil {
  /// private constructor
  NumberFieldInputFormatterHelperUtil._();

  /// the one and only instance of this singleton
  static final instance = NumberFieldInputFormatterHelperUtil._();

  ///to get the auto formatter for number type fields
  ///[mask] is required to auto format the field's input on change
  ///[maskAutoCompletionTypeEnum] is optional to define the eager or lazy behavior for the formatter
  ///this can only be used for number type fields, as this will only allow the numbers in the field
  MaskTextInputFormatter getNumberFieldInputFormatter({required String mask, MaskAutoCompletionTypeEnums? maskAutoCompletionTypeEnum}) {
    MaskAutoCompletionType maskAutoCompletionType = MaskAutoCompletionType.eager;
    //set the auto completion type
    if (maskAutoCompletionTypeEnum != null) {
      if (maskAutoCompletionTypeEnum == MaskAutoCompletionTypeEnums.lazy) {
        maskAutoCompletionType == MaskAutoCompletionType.lazy;
      } else {
        maskAutoCompletionType = MaskAutoCompletionType.eager;
      }
    }
    return MaskTextInputFormatter(
        mask: mask,
        filter: {"#": RegExp(r'\d')}, //allow only numbers
        type: maskAutoCompletionType);
  }
}
