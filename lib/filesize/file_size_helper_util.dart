import 'package:filesize/filesize.dart';

class FileSizeHelperUtil {
  /// private constructor
  FileSizeHelperUtil._();

  /// the one and only instance of this singleton
  static final instance = FileSizeHelperUtil._();

  ///Get the file size in humanized string
  ///1024 ==> 1 KB
  String getHumanizedFileSize({required double fileSize}) {
    return filesize(fileSize);
  }
}
